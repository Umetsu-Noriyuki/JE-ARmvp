import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/my_ar/my_ar_pages.dart';

import '../../helper/pump_app.dart';

void main() {
  group('MyArPage', () {
    testWidgets('正常系: タイトルと準備中表示がされる', (tester) async {
      await pumpWidgetInApp(tester, const MyArPage());

      expect(find.widgetWithText(AppBar, 'マイAR'), findsOneWidget);
      expect(find.text('準備中'), findsOneWidget);
    });
  });
}
