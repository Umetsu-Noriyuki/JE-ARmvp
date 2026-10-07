import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/services/ar_texture_renderer_service.dart';

import '../../helper/ar_object_fixtures.dart';

void main() {
  const service = ArTextureRendererService();
  const pngSignature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

  group('ArTextureRendererService.renderText', () {
    testWidgets('正常系: PNG 画像と正のピクセルサイズを返す', (tester) async {
      final texture = await tester.runAsync(
        () => service.renderText(SAMPLE_TEXT_CONTENT),
      );

      expect(texture, isNotNull);
      expect(texture!.pngBytes.sublist(0, 8), pngSignature);
      expect(texture.widthPx, greaterThan(0));
      expect(texture.heightPx, greaterThan(0));
    });

    testWidgets('正常系: 文字列が長いほど画像の幅が広くなる', (tester) async {
      final short = await tester.runAsync(
        () => service.renderText(SAMPLE_TEXT_CONTENT.copyWith(text: 'A')),
      );
      final long = await tester.runAsync(
        () => service.renderText(SAMPLE_TEXT_CONTENT.copyWith(text: 'AAAAAA')),
      );

      expect(long!.widthPx, greaterThan(short!.widthPx));
      expect(long.heightPx, short.heightPx);
    });

    testWidgets('正常系: 文字サイズが大きいほど画像が大きくなる', (tester) async {
      final small = await tester.runAsync(
        () => service.renderText(SAMPLE_TEXT_CONTENT.copyWith(fontSize: 10)),
      );
      final large = await tester.runAsync(
        () => service.renderText(SAMPLE_TEXT_CONTENT.copyWith(fontSize: 40)),
      );

      expect(large!.heightPx, greaterThan(small!.heightPx));
    });
  });

  group('ArTexture', () {
    test('正常系: heightPerWidth は高さ / 幅を返す', () {
      final texture = ArTexture(
        pngBytes: Uint8List(0),
        widthPx: 200,
        heightPx: 50,
      );

      expect(texture.heightPerWidth, 0.25);
    });
  });
}
