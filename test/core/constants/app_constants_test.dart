import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('正常系: 共有期限は24時間である', () {
      expect(AppConstants.SHARE_DURATION, const Duration(hours: 24));
    });

    test('正常系: アプリ表示名が設定されている', () {
      expect(AppConstants.APP_TITLE, 'AR共有');
    });
  });
}
