import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/ar_create/ar_create_pages.dart';
import 'package:ar_app/features/home/home_pages.dart';
import 'package:ar_app/features/my_ar/my_ar_pages.dart';
import 'package:ar_app/features/share_receive/share_receive_pages.dart';

import '../../helper/pump_app.dart';

void main() {
  group('HomePage', () {
    testWidgets('正常系: 3つのメニューボタンが表示される', (tester) async {
      await pumpApp(tester);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('ARを作成'), findsOneWidget);
      expect(find.text('マイAR'), findsOneWidget);
      expect(find.text('共有コード入力'), findsOneWidget);
    });

    final transitionCases = {
      'ARを作成': ArCreatePage,
      'マイAR': MyArPage,
      '共有コード入力': ShareReceivePage,
    };
    for (final entry in transitionCases.entries) {
      testWidgets('正常系: 「${entry.key}」をタップすると ${entry.value} へ遷移する', (
        tester,
      ) async {
        await pumpApp(tester);

        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();

        expect(find.byType(entry.value), findsOneWidget);
      });
    }

    testWidgets('正常系: 遷移先から戻るとホーム画面に戻る', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('マイAR'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(MyArPage), findsNothing);
    });
  });
}
