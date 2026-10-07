import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/ar_create/ar_create_pages.dart';
import 'package:ar_app/features/ar_create/ar_create_providers.dart';
import 'package:ar_app/features/ar_create/ar_create_viewmodels.dart';
import 'package:ar_app/features/ar_create/widgets/ar_pose_panel.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpPage(WidgetTester tester) async {
    container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ArCreatePage()),
      ),
    );
  }

  ArCreateViewModel viewModel() =>
      container.read(arCreateViewModelProvider.notifier);

  group('ArCreatePage', () {
    testWidgets('正常系: AR 非対応環境では非対応メッセージを表示する', (tester) async {
      await pumpPage(tester);

      expect(find.widgetWithText(AppBar, 'ARを作成'), findsOneWidget);
      expect(find.text('この端末ではARを利用できません'), findsOneWidget);
    });

    testWidgets('正常系: 未配置時は配置方法を表示し、大きさ・配置情報は表示しない', (tester) async {
      await pumpPage(tester);

      expect(find.text('検出された平面をタップして配置'), findsOneWidget);
      expect(find.byType(Slider), findsNothing);
      expect(find.byType(ArPosePanel), findsNothing);
    });

    testWidgets('正常系: 配置後は操作方法・大きさスライダー・配置情報を表示する', (tester) async {
      await pumpPage(tester);

      viewModel().onPlaced(
        anchorTransform: Matrix4.identity(),
        nodeTransform: Matrix4.identity(),
      );
      await tester.pump();

      expect(find.text('ドラッグで移動、2本指で回転できます'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(ArPosePanel), findsOneWidget);
    });

    testWidgets('正常系: スライダー操作で大きさが変更される', (tester) async {
      await pumpPage(tester);
      viewModel().onPlaced(
        anchorTransform: Matrix4.identity(),
        nodeTransform: Matrix4.identity(),
      );
      await tester.pump();

      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pump();

      expect(
        container.read(arCreateViewModelProvider).nodeScale,
        greaterThan(ArCreateViewModel.DEFAULT_NODE_SCALE),
      );
    });

    testWidgets('異常系: エラー発生時はエラーメッセージを表示する', (tester) async {
      await pumpPage(tester);

      viewModel().onError('平面が検出されていません');
      await tester.pump();

      expect(find.text('平面が検出されていません'), findsOneWidget);
    });
  });
}
