import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/share_receive/share_receive_pages.dart';

import '../../helper/pump_app.dart';

void main() {
  group('ShareReceivePage', () {
    testWidgets('正常系: タイトルと準備中表示がされる', (tester) async {
      await pumpWidgetInApp(tester, const ShareReceivePage());

      expect(find.widgetWithText(AppBar, '共有コード入力'), findsOneWidget);
      expect(find.text('準備中'), findsOneWidget);
    });
  });
}
