import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/ar_create/ar_create_pages.dart';

import '../../helper/pump_app.dart';

void main() {
  group('ArCreatePage', () {
    testWidgets('正常系: タイトルと準備中表示がされる', (tester) async {
      await pumpWidgetInApp(tester, const ArCreatePage());

      expect(find.widgetWithText(AppBar, 'ARを作成'), findsOneWidget);
      expect(find.text('準備中'), findsOneWidget);
    });
  });
}
