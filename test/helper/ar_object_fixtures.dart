import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/ar_object_origin.dart';
import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/core/enums/shape_type.dart';
import 'package:ar_app/core/enums/share_status.dart';
import 'package:ar_app/core/enums/text_horizontal_align.dart';
import 'package:ar_app/core/enums/text_vertical_align.dart';
import 'package:ar_app/core/enums/writing_direction.dart';
import 'package:ar_app/data/db/app_database.dart';
import 'package:ar_app/data/models/ar_object/ar_object.dart';
import 'package:ar_app/data/models/ar_object/ar_object_content.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';

const TextContent SAMPLE_TEXT_CONTENT = TextContent(
  text: 'ここに集合！',
  fontSize: 24,
  textColorArgb: 0xFF000000,
  backgroundColorArgb: 0xFFFFFFFF,
  horizontalAlign: TextHorizontalAlign.center,
  verticalAlign: TextVerticalAlign.center,
  writingDirection: WritingDirection.horizontal,
);

const ShapeContent SAMPLE_SHAPE_CONTENT = ShapeContent(
  shapeType: ShapeType.arrow,
  colorArgb: 0xFFD4A64A,
);

const ArPose SAMPLE_POSE = ArPose(
  positionX: 0.1,
  positionY: 0,
  positionZ: -1.5,
  rotationX: 0,
  rotationY: 0.7071,
  rotationZ: 0,
  rotationW: 0.7071,
  scale: 1,
  planeType: PlaneType.horizontal,
  compassHeading: 90.5,
);

/// テスト用の ArObject を生成する
ArObject buildArObject({
  String objectId = 'object-1',
  ArObjectContent content = SAMPLE_TEXT_CONTENT,
  DateTime? createdAt,
  ShareStatus shareStatus = ShareStatus.notShared,
  DateTime? expiresAt,
}) {
  return ArObject(
    objectId: objectId,
    origin: ArObjectOrigin.own,
    content: content,
    pose: SAMPLE_POSE,
    createdAt: createdAt ?? DateTime.utc(2026, 9, 30, 10),
    shareStatus: shareStatus,
    latitude: 37.7608,
    longitude: 140.4747,
    expiresAt: expiresAt,
  );
}

/// メモリ上の DB を生成し、テスト終了時に閉じる
AppDatabase createInMemoryDatabase() {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  return database;
}
