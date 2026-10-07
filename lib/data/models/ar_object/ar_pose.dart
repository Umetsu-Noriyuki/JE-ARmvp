import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/core/utils/json_reader.dart';

/// AR空間上の配置情報（検出平面に対する相対位置・回転・大きさ）
///
/// 別セッション・別端末ではローカルアンカーを復元できないため、
/// 再表示時は検出した平面とコンパス方位を基準に相対値で置き直す。
final class ArPose {
  const ArPose({
    required this.positionX,
    required this.positionY,
    required this.positionZ,
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
    required this.rotationW,
    required this.scale,
    required this.planeType,
    this.compassHeading,
  });

  factory ArPose.fromJson(Map<String, dynamic> json) {
    return ArPose(
      positionX: JsonReader.readDouble(json, 'positionX'),
      positionY: JsonReader.readDouble(json, 'positionY'),
      positionZ: JsonReader.readDouble(json, 'positionZ'),
      rotationX: JsonReader.readDouble(json, 'rotationX'),
      rotationY: JsonReader.readDouble(json, 'rotationY'),
      rotationZ: JsonReader.readDouble(json, 'rotationZ'),
      rotationW: JsonReader.readDouble(json, 'rotationW'),
      scale: JsonReader.readDouble(json, 'scale'),
      planeType: JsonReader.readEnum(json, 'planeType', PlaneType.values),
      compassHeading: JsonReader.readNullableDouble(json, 'compassHeading'),
    );
  }

  /// 位置（メートル）
  final double positionX;
  final double positionY;
  final double positionZ;

  /// 回転（クォータニオン）
  final double rotationX;
  final double rotationY;
  final double rotationZ;
  final double rotationW;

  /// 大きさ（等倍 = 1.0）
  final double scale;

  final PlaneType planeType;

  /// 配置時の端末のコンパス方位（度、北 = 0）。取得できない端末では null
  final double? compassHeading;

  ArPose copyWith({
    double? positionX,
    double? positionY,
    double? positionZ,
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    double? rotationW,
    double? scale,
    PlaneType? planeType,
    double? Function()? compassHeading,
  }) {
    return ArPose(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      positionZ: positionZ ?? this.positionZ,
      rotationX: rotationX ?? this.rotationX,
      rotationY: rotationY ?? this.rotationY,
      rotationZ: rotationZ ?? this.rotationZ,
      rotationW: rotationW ?? this.rotationW,
      scale: scale ?? this.scale,
      planeType: planeType ?? this.planeType,
      compassHeading: compassHeading != null
          ? compassHeading()
          : this.compassHeading,
    );
  }

  Map<String, dynamic> toJson() => {
    'positionX': positionX,
    'positionY': positionY,
    'positionZ': positionZ,
    'rotationX': rotationX,
    'rotationY': rotationY,
    'rotationZ': rotationZ,
    'rotationW': rotationW,
    'scale': scale,
    'planeType': planeType.name,
    'compassHeading': compassHeading,
  };

  @override
  bool operator ==(Object other) =>
      other is ArPose &&
      other.positionX == positionX &&
      other.positionY == positionY &&
      other.positionZ == positionZ &&
      other.rotationX == rotationX &&
      other.rotationY == rotationY &&
      other.rotationZ == rotationZ &&
      other.rotationW == rotationW &&
      other.scale == scale &&
      other.planeType == planeType &&
      other.compassHeading == compassHeading;

  @override
  int get hashCode => Object.hash(
    positionX,
    positionY,
    positionZ,
    rotationX,
    rotationY,
    rotationZ,
    rotationW,
    scale,
    planeType,
    compassHeading,
  );
}
