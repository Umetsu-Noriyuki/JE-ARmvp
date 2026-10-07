import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/features/ar_create/widgets/ar_pose_panel.dart';

import '../../../helper/ar_object_fixtures.dart';
import '../../../helper/pump_app.dart';

void main() {
  group('ArPosePanel', () {
    testWidgets('正常系: 平面の種類・位置・回転・大きさを表示する', (tester) async {
      await pumpWidgetInApp(tester, const ArPosePanel(pose: SAMPLE_POSE));

      expect(find.text('平面: 水平面'), findsOneWidget);
      expect(find.text('位置: 0.100, 0.000, -1.500'), findsOneWidget);
      expect(find.text('回転: 0.000, 0.707, 0.000, 0.707'), findsOneWidget);
      expect(find.text('大きさ: 1.00'), findsOneWidget);
    });

    testWidgets('正常系: 垂直面の場合は「垂直面」と表示する', (tester) async {
      await pumpWidgetInApp(
        tester,
        ArPosePanel(pose: SAMPLE_POSE.copyWith(planeType: PlaneType.vertical)),
      );

      expect(find.text('平面: 垂直面'), findsOneWidget);
    });
  });
}
