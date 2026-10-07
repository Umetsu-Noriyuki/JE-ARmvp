import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';

import '../../../helper/ar_object_fixtures.dart';

void main() {
  group('ArPose', () {
    test('正常系: toJson / fromJson で往復変換できる', () {
      final restored = ArPose.fromJson(SAMPLE_POSE.toJson());

      expect(restored, SAMPLE_POSE);
      expect(restored.hashCode, SAMPLE_POSE.hashCode);
    });

    test('正常系: compassHeading が null でも往復変換できる', () {
      const pose = ArPose(
        positionX: 0,
        positionY: 0,
        positionZ: 0,
        rotationX: 0,
        rotationY: 0,
        rotationZ: 0,
        rotationW: 1,
        scale: 2,
        planeType: PlaneType.vertical,
      );

      final restored = ArPose.fromJson(pose.toJson());

      expect(restored, pose);
      expect(restored.compassHeading, isNull);
    });

    test('正常系: 整数で保存された値も double として復元される', () {
      final json = SAMPLE_POSE.toJson()..['scale'] = 2;

      expect(ArPose.fromJson(json).scale, 2.0);
    });

    test('異常系: 必須項目が欠けている場合は FormatException', () {
      final json = SAMPLE_POSE.toJson()..remove('positionX');

      expect(() => ArPose.fromJson(json), throwsFormatException);
    });

    test('異常系: planeType が未定義の場合は FormatException', () {
      final json = SAMPLE_POSE.toJson()..['planeType'] = 'ceiling';

      expect(() => ArPose.fromJson(json), throwsFormatException);
    });
  });
}
