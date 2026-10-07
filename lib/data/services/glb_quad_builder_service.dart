import 'dart:convert';
import 'dart:typed_data';

/// 画像（PNG）を貼った長方形の板を glTF バイナリ（GLB）として生成する
///
/// 板は XY 平面上に置かれ、下辺中央が原点、表面は +Z 方向を向く。
/// 平面アンカーに配置すると、下辺が平面に接した看板のように立つ。
class GlbQuadBuilderService {
  const GlbQuadBuilderService();

  static const int _GLB_MAGIC = 0x46546C67; // 'glTF'
  static const int _GLB_VERSION = 2;
  static const int _CHUNK_TYPE_JSON = 0x4E4F534A; // 'JSON'
  static const int _CHUNK_TYPE_BIN = 0x004E4942; // 'BIN\0'
  static const int _HEADER_LENGTH = 12;
  static const int _CHUNK_HEADER_LENGTH = 8;
  static const List<int> _PNG_SIGNATURE = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  ];

  /// [pngBytes] を貼った幅 [width]・高さ [height]（メートル）の板の GLB を返す
  ///
  /// サイズが正でない場合や PNG でない場合は [ArgumentError] を送出する。
  Uint8List build({
    required Uint8List pngBytes,
    required double width,
    required double height,
  }) {
    _validate(pngBytes: pngBytes, width: width, height: height);
    final binary = _QuadBinary.create(pngBytes, width, height);
    final json = _buildJson(binary, width, height);
    return _assembleGlb(json, binary.bytes);
  }

  void _validate({
    required Uint8List pngBytes,
    required double width,
    required double height,
  }) {
    if (!(width > 0) || !width.isFinite) {
      throw ArgumentError.value(width, 'width', 'must be positive');
    }
    if (!(height > 0) || !height.isFinite) {
      throw ArgumentError.value(height, 'height', 'must be positive');
    }
    if (!_isPng(pngBytes)) {
      throw ArgumentError.value(pngBytes.length, 'pngBytes', 'is not a PNG');
    }
  }

  bool _isPng(Uint8List bytes) {
    if (bytes.length < _PNG_SIGNATURE.length) return false;
    for (var i = 0; i < _PNG_SIGNATURE.length; i++) {
      if (bytes[i] != _PNG_SIGNATURE[i]) return false;
    }
    return true;
  }

  Map<String, dynamic> _buildJson(
    _QuadBinary binary,
    double width,
    double height,
  ) {
    return {
      'asset': {'version': '2.0', 'generator': 'ar_app'},
      'extensionsUsed': ['KHR_materials_unlit'],
      'scene': 0,
      'scenes': [
        {
          'nodes': [0],
        },
      ],
      'nodes': [
        {'mesh': 0},
      ],
      'meshes': [_buildMesh()],
      'materials': [_buildMaterial()],
      'textures': [
        {'sampler': 0, 'source': 0},
      ],
      'samplers': [
        // LINEAR / LINEAR_MIPMAP_LINEAR / CLAMP_TO_EDGE
        {'magFilter': 9729, 'minFilter': 9987, 'wrapS': 33071, 'wrapT': 33071},
      ],
      'images': [
        {'bufferView': 4, 'mimeType': 'image/png'},
      ],
      'buffers': [
        {'byteLength': binary.bytes.length},
      ],
      'bufferViews': binary.bufferViews,
      'accessors': _buildAccessors(width, height),
    };
  }

  Map<String, dynamic> _buildMesh() {
    return {
      'primitives': [
        {
          'attributes': {'POSITION': 0, 'NORMAL': 1, 'TEXCOORD_0': 2},
          'indices': 3,
          'material': 0,
        },
      ],
    };
  }

  Map<String, dynamic> _buildMaterial() {
    return {
      'pbrMetallicRoughness': {
        'baseColorTexture': {'index': 0},
        'metallicFactor': 0.0,
        'roughnessFactor': 1.0,
      },
      // 透過 PNG（図形の背景など）を透過表示し、裏側からも見えるようにする
      'alphaMode': 'BLEND',
      'doubleSided': true,
      'extensions': {'KHR_materials_unlit': <String, dynamic>{}},
    };
  }

  List<Map<String, dynamic>> _buildAccessors(double width, double height) {
    const float = 5126;
    const unsignedShort = 5123;
    return [
      {
        'bufferView': 0,
        'componentType': float,
        'count': 4,
        'type': 'VEC3',
        'min': [-width / 2, 0.0, 0.0],
        'max': [width / 2, height, 0.0],
      },
      {'bufferView': 1, 'componentType': float, 'count': 4, 'type': 'VEC3'},
      {'bufferView': 2, 'componentType': float, 'count': 4, 'type': 'VEC2'},
      {
        'bufferView': 3,
        'componentType': unsignedShort,
        'count': 6,
        'type': 'SCALAR',
      },
    ];
  }

  Uint8List _assembleGlb(Map<String, dynamic> json, Uint8List binary) {
    final jsonChunk = _padTo4(utf8.encode(jsonEncode(json)), 0x20);
    final binChunk = _padTo4(binary, 0x00);
    final totalLength =
        _HEADER_LENGTH +
        _CHUNK_HEADER_LENGTH +
        jsonChunk.length +
        _CHUNK_HEADER_LENGTH +
        binChunk.length;

    final builder = BytesBuilder(copy: false)
      ..add(_uint32List([_GLB_MAGIC, _GLB_VERSION, totalLength]))
      ..add(_uint32List([jsonChunk.length, _CHUNK_TYPE_JSON]))
      ..add(jsonChunk)
      ..add(_uint32List([binChunk.length, _CHUNK_TYPE_BIN]))
      ..add(binChunk);
    return builder.toBytes();
  }

  static Uint8List _uint32List(List<int> values) {
    final data = ByteData(values.length * 4);
    for (var i = 0; i < values.length; i++) {
      data.setUint32(i * 4, values[i], Endian.little);
    }
    return data.buffer.asUint8List();
  }

  static Uint8List _padTo4(List<int> bytes, int padByte) {
    final paddedLength = (bytes.length + 3) & ~3;
    final padded = Uint8List(paddedLength)..fillRange(0, paddedLength, padByte);
    padded.setRange(0, bytes.length, bytes);
    return padded;
  }
}

/// 板の頂点・法線・UV・インデックス・画像を1つのバイナリバッファにまとめたもの
class _QuadBinary {
  const _QuadBinary(this.bytes, this.bufferViews);

  factory _QuadBinary.create(Uint8List pngBytes, double width, double height) {
    final halfWidth = width / 2;
    final sections = <Uint8List>[
      // 頂点: 左下, 右下, 右上, 左上
      _float32Bytes([
        -halfWidth, 0, 0, //
        halfWidth, 0, 0,
        halfWidth, height, 0,
        -halfWidth, height, 0,
      ]),
      _float32Bytes([0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1]),
      // UV は画像の左上が (0, 0)
      _float32Bytes([0, 1, 1, 1, 1, 0, 0, 0]),
      _uint16Bytes([0, 1, 2, 0, 2, 3]),
      pngBytes,
    ];

    final builder = BytesBuilder(copy: false);
    final bufferViews = <Map<String, dynamic>>[];
    for (final section in sections) {
      bufferViews.add({
        'buffer': 0,
        'byteOffset': builder.length,
        'byteLength': section.length,
      });
      builder.add(GlbQuadBuilderService._padTo4(section, 0x00));
    }
    return _QuadBinary(builder.toBytes(), bufferViews);
  }

  final Uint8List bytes;
  final List<Map<String, dynamic>> bufferViews;

  static Uint8List _float32Bytes(List<double> values) {
    final data = ByteData(values.length * 4);
    for (var i = 0; i < values.length; i++) {
      data.setFloat32(i * 4, values[i], Endian.little);
    }
    return data.buffer.asUint8List();
  }

  static Uint8List _uint16Bytes(List<int> values) {
    final data = ByteData(values.length * 2);
    for (var i = 0; i < values.length; i++) {
      data.setUint16(i * 2, values[i], Endian.little);
    }
    return data.buffer.asUint8List();
  }
}
