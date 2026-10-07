import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/shape_type.dart';
import 'package:ar_app/core/enums/writing_direction.dart';
import 'package:ar_app/data/models/ar_object/ar_object_content.dart';

import '../../../helper/ar_object_fixtures.dart';

void main() {
  group('ArObjectContent.fromJson', () {
    test('正常系: type が text の場合は TextContent を復元する', () {
      final restored = ArObjectContent.fromJson(SAMPLE_TEXT_CONTENT.toJson());

      expect(restored, isA<TextContent>());
      expect(restored, SAMPLE_TEXT_CONTENT);
    });

    test('正常系: type が shape の場合は ShapeContent を復元する', () {
      final restored = ArObjectContent.fromJson(SAMPLE_SHAPE_CONTENT.toJson());

      expect(restored, isA<ShapeContent>());
      expect(restored, SAMPLE_SHAPE_CONTENT);
    });

    test('異常系: type が未定義の場合は FormatException', () {
      expect(
        () => ArObjectContent.fromJson({'type': 'model3d'}),
        throwsFormatException,
      );
    });

    test('異常系: type が無い場合は FormatException', () {
      expect(() => ArObjectContent.fromJson({}), throwsFormatException);
    });
  });

  group('TextContent', () {
    test('正常系: type は text である', () {
      expect(SAMPLE_TEXT_CONTENT.type, ArObjectType.text);
    });

    test('正常系: toJson に全項目と type が含まれる', () {
      expect(SAMPLE_TEXT_CONTENT.toJson(), {
        'type': 'text',
        'text': 'ここに集合！',
        'fontSize': 24.0,
        'textColorArgb': 0xFF000000,
        'backgroundColorArgb': 0xFFFFFFFF,
        'horizontalAlign': 'center',
        'verticalAlign': 'center',
        'writingDirection': 'horizontal',
      });
    });

    test('異常系: 必須項目が欠けている場合は FormatException', () {
      final json = SAMPLE_TEXT_CONTENT.toJson()..remove('text');

      expect(() => TextContent.fromJson(json), throwsFormatException);
    });

    test('正常系: copyWith で指定項目のみ変更される', () {
      final copied = SAMPLE_TEXT_CONTENT.copyWith(
        writingDirection: WritingDirection.vertical,
      );

      expect(copied.writingDirection, WritingDirection.vertical);
      expect(copied.text, SAMPLE_TEXT_CONTENT.text);
      expect(copied, isNot(SAMPLE_TEXT_CONTENT));
    });

    test('正常系: 引数なしの copyWith は等価なオブジェクトを返す', () {
      final copied = SAMPLE_TEXT_CONTENT.copyWith();

      expect(copied, SAMPLE_TEXT_CONTENT);
      expect(copied.hashCode, SAMPLE_TEXT_CONTENT.hashCode);
    });
  });

  group('ShapeContent', () {
    test('正常系: type は shape である', () {
      expect(SAMPLE_SHAPE_CONTENT.type, ArObjectType.shape);
    });

    test('正常系: toJson に全項目と type が含まれる', () {
      expect(SAMPLE_SHAPE_CONTENT.toJson(), {
        'type': 'shape',
        'shapeType': 'arrow',
        'colorArgb': 0xFFD4A64A,
      });
    });

    test('異常系: shapeType が未定義の場合は FormatException', () {
      final json = SAMPLE_SHAPE_CONTENT.toJson()..['shapeType'] = 'star';

      expect(() => ShapeContent.fromJson(json), throwsFormatException);
    });

    test('正常系: copyWith で指定項目のみ変更される', () {
      final copied = SAMPLE_SHAPE_CONTENT.copyWith(shapeType: ShapeType.circle);

      expect(copied.shapeType, ShapeType.circle);
      expect(copied.colorArgb, SAMPLE_SHAPE_CONTENT.colorArgb);
    });

    test('正常系: 引数なしの copyWith は等価なオブジェクトを返す', () {
      final copied = SAMPLE_SHAPE_CONTENT.copyWith();

      expect(copied, SAMPLE_SHAPE_CONTENT);
      expect(copied.hashCode, SAMPLE_SHAPE_CONTENT.hashCode);
    });
  });
}
