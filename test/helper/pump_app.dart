import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/app/app.dart';

/// ProviderScope 付きでアプリ全体を起動し、テスト終了時に破棄する
Future<ProviderContainer> pumpApp(WidgetTester tester) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  return container;
}

/// 単一の Widget を MaterialApp で包んで表示する
Future<void> pumpWidgetInApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(MaterialApp(home: child));
}
