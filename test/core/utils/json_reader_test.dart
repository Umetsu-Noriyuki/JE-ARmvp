import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/shape_type.dart';
import 'package:ar_app/core/utils/json_reader.dart';

void main() {
  final json = <String, dynamic>{
    'string': 'abc',
    'int': 3,
    'double': 1.5,
    'nullValue': null,
    'enum': 'arrow',
  };

  group('JsonReader.readString', () {
    test('正常系: 文字列を読み出せる', () {
      expect(JsonReader.readString(json, 'string'), 'abc');
    });

    test('異常系: 型が異なる場合は FormatException', () {
      expect(() => JsonReader.readString(json, 'int'), throwsFormatException);
    });

    test('異常系: キーが存在しない場合は FormatException', () {
      expect(
        () => JsonReader.readString(json, 'missing'),
        throwsFormatException,
      );
    });
  });

  group('JsonReader.readInt', () {
    test('正常系: 整数を読み出せる', () {
      expect(JsonReader.readInt(json, 'int'), 3);
    });

    test('異常系: 小数の場合は FormatException', () {
      expect(() => JsonReader.readInt(json, 'double'), throwsFormatException);
    });
  });

  group('JsonReader.readDouble', () {
    test('正常系: 小数を読み出せる', () {
      expect(JsonReader.readDouble(json, 'double'), 1.5);
    });

    test('正常系: 整数は double に変換される', () {
      final value = JsonReader.readDouble(json, 'int');

      expect(value, 3.0);
      expect(value, isA<double>());
    });

    test('異常系: 文字列の場合は FormatException', () {
      expect(
        () => JsonReader.readDouble(json, 'string'),
        throwsFormatException,
      );
    });
  });

  group('JsonReader.readNullableDouble', () {
    test('正常系: null の場合は null を返す', () {
      expect(JsonReader.readNullableDouble(json, 'nullValue'), isNull);
      expect(JsonReader.readNullableDouble(json, 'missing'), isNull);
    });

    test('正常系: 数値の場合は double を返す', () {
      expect(JsonReader.readNullableDouble(json, 'double'), 1.5);
    });

    test('異常系: 数値以外の場合は FormatException', () {
      expect(
        () => JsonReader.readNullableDouble(json, 'string'),
        throwsFormatException,
      );
    });
  });

  group('JsonReader.readEnum', () {
    test('正常系: name に一致する enum 値を返す', () {
      expect(
        JsonReader.readEnum(json, 'enum', ShapeType.values),
        ShapeType.arrow,
      );
    });

    test('異常系: 未定義の name の場合は FormatException', () {
      expect(
        () => JsonReader.readEnum(json, 'string', ShapeType.values),
        throwsFormatException,
      );
    });
  });

  group('JsonReader.asObject', () {
    test('正常系: Map はそのまま返す', () {
      expect(JsonReader.asObject(json), same(json));
    });

    test('異常系: Map 以外は FormatException', () {
      expect(() => JsonReader.asObject([1, 2]), throwsFormatException);
      expect(() => JsonReader.asObject(null), throwsFormatException);
    });
  });
}
