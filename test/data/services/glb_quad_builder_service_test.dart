import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/services/glb_quad_builder_service.dart';

/// テスト用の最小 PNG（シグネチャ + ダミーデータ）
final Uint8List _pngBytes = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 1, 2, 3, //
]);

/// GLB を JSON チャンクと BIN チャンクに分解する
({ByteData header, Map<String, dynamic> json, Uint8List bin}) _parseGlb(
  Uint8List glb,
) {
  final data = ByteData.sublistView(glb);
  final jsonLength = data.getUint32(12, Endian.little);
  final jsonBytes = glb.sublist(20, 20 + jsonLength);
  final binHeaderOffset = 20 + jsonLength;
  final binLength = data.getUint32(binHeaderOffset, Endian.little);
  return (
    header: data,
    json: jsonDecode(utf8.decode(jsonBytes)) as Map<String, dynamic>,
    bin: glb.sublist(binHeaderOffset + 8, binHeaderOffset + 8 + binLength),
  );
}

void main() {
  const service = GlbQuadBuilderService();

  group('GlbQuadBuilderService.build 正常系', () {
    final glb = service.build(pngBytes: _pngBytes, width: 0.5, height: 0.25);
    final parsed = _parseGlb(glb);

    test('ヘッダが glTF 2.0 で、総バイト数が実際の長さと一致する', () {
      expect(parsed.header.getUint32(0, Endian.little), 0x46546C67);
      expect(parsed.header.getUint32(4, Endian.little), 2);
      expect(parsed.header.getUint32(8, Endian.little), glb.length);
    });

    test('チャンク種別が JSON・BIN の順で、長さが4バイト境界に揃う', () {
      final jsonLength = parsed.header.getUint32(12, Endian.little);
      expect(parsed.header.getUint32(16, Endian.little), 0x4E4F534A);
      expect(
        parsed.header.getUint32(20 + jsonLength + 4, Endian.little),
        0x004E4942,
      );
      expect(jsonLength % 4, 0);
      expect(parsed.bin.length % 4, 0);
      expect(glb.length % 4, 0);
    });

    test('頂点座標の範囲が指定サイズ（下辺中央が原点）になる', () {
      final accessors = parsed.json['accessors'] as List<dynamic>;
      final position = accessors[0] as Map<String, dynamic>;

      expect(position['min'], [-0.25, 0.0, 0.0]);
      expect(position['max'], [0.25, 0.25, 0.0]);
    });

    test('BIN チャンク内の画像領域に PNG がそのまま格納される', () {
      final bufferViews = parsed.json['bufferViews'] as List<dynamic>;
      final images = parsed.json['images'] as List<dynamic>;
      final imageView =
          bufferViews[(images[0] as Map<String, dynamic>)['bufferView'] as int]
              as Map<String, dynamic>;
      final offset = imageView['byteOffset'] as int;
      final length = imageView['byteLength'] as int;

      expect(parsed.bin.sublist(offset, offset + length), _pngBytes);
      expect((images[0] as Map<String, dynamic>)['mimeType'], 'image/png');
    });

    test('各 bufferView の開始位置が4バイト境界に揃う', () {
      final bufferViews = parsed.json['bufferViews'] as List<dynamic>;

      for (final view in bufferViews.cast<Map<String, dynamic>>()) {
        expect((view['byteOffset'] as int) % 4, 0);
      }
    });

    test('頂点座標が BIN チャンクに float32 で格納される', () {
      final positions = Float32List.sublistView(parsed.bin, 0, 48);

      expect(positions, [
        -0.25, 0, 0, 0.25, 0, 0, 0.25, 0.25, 0, -0.25, 0.25, 0, //
      ]);
    });

    test('マテリアルは両面表示・透過・unlit である', () {
      final materials = parsed.json['materials'] as List<dynamic>;
      final material = materials[0] as Map<String, dynamic>;

      expect(material['doubleSided'], isTrue);
      expect(material['alphaMode'], 'BLEND');
      expect(
        (material['extensions'] as Map<String, dynamic>).keys,
        contains('KHR_materials_unlit'),
      );
    });
  });

  group('GlbQuadBuilderService.build 異常系', () {
    final invalidSizes = <String, (double, double)>{
      '幅が0': (0, 1),
      '高さが負': (1, -1),
      '幅が NaN': (double.nan, 1),
      '高さが無限大': (1, double.infinity),
    };
    for (final entry in invalidSizes.entries) {
      test('${entry.key}の場合は ArgumentError', () {
        expect(
          () => service.build(
            pngBytes: _pngBytes,
            width: entry.value.$1,
            height: entry.value.$2,
          ),
          throwsArgumentError,
        );
      });
    }

    test('PNG シグネチャで始まらない場合は ArgumentError', () {
      expect(
        () => service.build(
          pngBytes: Uint8List.fromList(List.filled(16, 0)),
          width: 1,
          height: 1,
        ),
        throwsArgumentError,
      );
    });

    test('PNG シグネチャより短い場合は ArgumentError', () {
      expect(
        () => service.build(
          pngBytes: Uint8List.fromList([0x89, 0x50]),
          width: 1,
          height: 1,
        ),
        throwsArgumentError,
      );
    });
  });
}
