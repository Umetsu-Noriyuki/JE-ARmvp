import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/errors/app_exception.dart';

void main() {
  group('NotFoundException', () {
    test('正常系: message を保持し AppException として扱える', () {
      const exception = NotFoundException('not found');

      expect(exception, isA<AppException>());
      expect(exception, isA<Exception>());
      expect(exception.message, 'not found');
    });

    test('正常系: toString に型名とメッセージが含まれる', () {
      expect(
        const NotFoundException('id-1').toString(),
        'NotFoundException: id-1',
      );
    });
  });

  group('DuplicateException', () {
    test('正常系: message を保持し AppException として扱える', () {
      const exception = DuplicateException('duplicated');

      expect(exception, isA<AppException>());
      expect(exception.message, 'duplicated');
      expect(exception.toString(), 'DuplicateException: duplicated');
    });
  });

  group('DataFormatException', () {
    test('正常系: message を保持し AppException として扱える', () {
      const exception = DataFormatException('invalid');

      expect(exception, isA<AppException>());
      expect(exception.message, 'invalid');
      expect(exception.toString(), 'DataFormatException: invalid');
    });
  });
}
