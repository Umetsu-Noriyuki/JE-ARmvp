import 'package:ar_flutter_plugin_plus/widgets/ar_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/ar_create/widgets/ar_scene_view.dart';

import '../../../helper/pump_app.dart';

/// permission_handler のカメラ権限要求に「拒否」を返すモック
void _mockCameraPermissionDenied() {
  const channel = MethodChannel('flutter.baseflow.com/permissions/methods');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        // Permission.camera = 1, PermissionStatus.denied = 0
        return <int, int>{1: 0};
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );
}

ArSceneView _buildSceneView() {
  return ArSceneView(
    prepareModelUri: () async => 'model.glb',
    nodeScale: 1,
    onPlaced: (_, _) {},
    onNodeTransformed: (_) {},
    onError: (_) {},
  );
}

void main() {
  group('ArSceneView', () {
    testWidgets('正常系: ARView を表示する', (tester) async {
      _mockCameraPermissionDenied();

      await pumpWidgetInApp(tester, _buildSceneView());
      await tester.pumpAndSettle();

      expect(find.byType(ARView), findsOneWidget);
    });

    testWidgets('異常系: カメラ権限が無い場合は日本語の許可案内を表示する', (tester) async {
      _mockCameraPermissionDenied();

      await pumpWidgetInApp(tester, _buildSceneView());
      await tester.pumpAndSettle();

      expect(find.text('ARを利用するにはカメラへのアクセスを許可してください'), findsOneWidget);
      expect(find.text('許可する'), findsOneWidget);
    });
  });
}
