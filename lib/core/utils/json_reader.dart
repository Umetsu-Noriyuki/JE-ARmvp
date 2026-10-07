/// JSON(Map) から型を検証しながら値を読み出す
///
/// 期待する型・値でない場合は [FormatException] を送出する。
abstract final class JsonReader {
  static String readString(Map<String, dynamic> json, String key) {
    return _read<String>(json, key);
  }

  static int readInt(Map<String, dynamic> json, String key) {
    return _read<int>(json, key);
  }

  static double readDouble(Map<String, dynamic> json, String key) {
    return _read<num>(json, key).toDouble();
  }

  static double? readNullableDouble(Map<String, dynamic> json, String key) {
    if (json[key] == null) return null;
    return readDouble(json, key);
  }

  static T readEnum<T extends Enum>(
    Map<String, dynamic> json,
    String key,
    List<T> values,
  ) {
    final name = readString(json, key);
    for (final value in values) {
      if (value.name == name) return value;
    }
    throw FormatException('Unknown value "$name" for key "$key"');
  }

  /// JSON のデコード結果が Map であることを検証する
  static Map<String, dynamic> asObject(Object? decoded) {
    if (decoded is Map<String, dynamic>) return decoded;
    throw FormatException('Expected a JSON object but got $decoded');
  }

  static T _read<T>(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is T) return value;
    throw FormatException('Expected $T for key "$key" but got $value');
  }
}
