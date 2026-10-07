import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/db/converters/ar_object_converters.dart';

import '../../../helper/ar_object_fixtures.dart';

void main() {
  group('ArObjectContentConverter', () {
    const converter = ArObjectContentConverter();

    test('正常系: 文字オブジェクトを往復変換できる', () {
      final sql = converter.toSql(SAMPLE_TEXT_CONTENT);

      expect(converter.fromSql(sql), SAMPLE_TEXT_CONTENT);
    });

    test('正常系: 図形オブジェクトを往復変換できる', () {
      final sql = converter.toSql(SAMPLE_SHAPE_CONTENT);

      expect(converter.fromSql(sql), SAMPLE_SHAPE_CONTENT);
    });

    test('異常系: JSON として不正な文字列は FormatException', () {
      expect(() => converter.fromSql('{broken'), throwsFormatException);
    });

    test('異常系: JSON オブジェクト以外は FormatException', () {
      expect(() => converter.fromSql('[1, 2]'), throwsFormatException);
    });
  });

  group('ArPoseConverter', () {
    const converter = ArPoseConverter();

    test('正常系: 配置情報を往復変換できる', () {
      final sql = converter.toSql(SAMPLE_POSE);

      expect(converter.fromSql(sql), SAMPLE_POSE);
    });

    test('異常系: JSON として不正な文字列は FormatException', () {
      expect(() => converter.fromSql('not json'), throwsFormatException);
    });

    test('異常系: JSON オブジェクト以外は FormatException', () {
      expect(() => converter.fromSql('"text"'), throwsFormatException);
    });
  });
}
