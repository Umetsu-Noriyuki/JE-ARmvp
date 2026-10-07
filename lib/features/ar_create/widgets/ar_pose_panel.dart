import 'package:flutter/material.dart';

import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';

/// 配置情報（ArPose）の数値を表示する（技術検証用）
class ArPosePanel extends StatelessWidget {
  const ArPosePanel({super.key, required this.pose});

  final ArPose pose;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('平面: ${_planeLabel(pose.planeType)}', style: style),
        Text(
          '位置: ${_format([pose.positionX, pose.positionY, pose.positionZ])}',
          style: style,
        ),
        Text(
          '回転: ${_format([pose.rotationX, pose.rotationY, pose.rotationZ, pose.rotationW])}',
          style: style,
        ),
        Text('大きさ: ${pose.scale.toStringAsFixed(2)}', style: style),
      ],
    );
  }

  String _planeLabel(PlaneType planeType) {
    return switch (planeType) {
      PlaneType.horizontal => '水平面',
      PlaneType.vertical => '垂直面',
    };
  }

  String _format(List<double> values) {
    return values.map((value) => value.toStringAsFixed(3)).join(', ');
  }
}
