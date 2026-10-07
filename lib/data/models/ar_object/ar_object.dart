import 'package:ar_app/core/enums/ar_object_origin.dart';
import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/share_status.dart';
import 'package:ar_app/data/models/ar_object/ar_object_content.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';

/// 端末内に保存するARオブジェクト
final class ArObject {
  const ArObject({
    required this.objectId,
    required this.origin,
    required this.content,
    required this.pose,
    required this.createdAt,
    required this.shareStatus,
    this.ownerId,
    this.latitude,
    this.longitude,
    this.placeName,
    this.thumbnailPath,
    this.shareCode,
    this.expiresAt,
  });

  final String objectId;

  /// 作成ユーザーID（Cognito）。認証導入前・未ログイン時は null
  final String? ownerId;
  final ArObjectOrigin origin;
  final ArObjectContent content;
  final ArPose pose;

  /// GPS 位置。取得できなかった場合は null（「場所不明」と表示する）
  final double? latitude;
  final double? longitude;

  /// 作成場所の表示名
  final String? placeName;

  /// サムネイル画像の端末内パス
  final String? thumbnailPath;
  final DateTime createdAt;

  /// 保存されている共有状態。期限切れ判定は [effectiveShareStatus] を使う
  final ShareStatus shareStatus;

  /// 共有コード（共有中・共有終了時のみ）
  final String? shareCode;

  /// 共有期限（共有中・共有終了時のみ）
  final DateTime? expiresAt;

  ArObjectType get type => content.type;

  bool get hasLocation => latitude != null && longitude != null;

  /// [now] 時点の共有状態を返す
  ///
  /// 共有中でも期限（[expiresAt]）を過ぎていれば共有終了とみなす。
  /// 期限ちょうどの時刻はまだ有効とする（仕様21: expiresAt < 現在時刻 で取得不可）。
  ShareStatus effectiveShareStatus(DateTime now) {
    final expiresAt = this.expiresAt;
    if (shareStatus != ShareStatus.sharing || expiresAt == null) {
      return shareStatus;
    }
    return expiresAt.isBefore(now) ? ShareStatus.ended : ShareStatus.sharing;
  }

  /// null を設定したい nullable 項目は `() => null` を渡す
  ArObject copyWith({
    String? objectId,
    String? Function()? ownerId,
    ArObjectOrigin? origin,
    ArObjectContent? content,
    ArPose? pose,
    double? Function()? latitude,
    double? Function()? longitude,
    String? Function()? placeName,
    String? Function()? thumbnailPath,
    DateTime? createdAt,
    ShareStatus? shareStatus,
    String? Function()? shareCode,
    DateTime? Function()? expiresAt,
  }) {
    return ArObject(
      objectId: objectId ?? this.objectId,
      ownerId: ownerId != null ? ownerId() : this.ownerId,
      origin: origin ?? this.origin,
      content: content ?? this.content,
      pose: pose ?? this.pose,
      latitude: latitude != null ? latitude() : this.latitude,
      longitude: longitude != null ? longitude() : this.longitude,
      placeName: placeName != null ? placeName() : this.placeName,
      thumbnailPath: thumbnailPath != null
          ? thumbnailPath()
          : this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      shareStatus: shareStatus ?? this.shareStatus,
      shareCode: shareCode != null ? shareCode() : this.shareCode,
      expiresAt: expiresAt != null ? expiresAt() : this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ArObject &&
      other.objectId == objectId &&
      other.ownerId == ownerId &&
      other.origin == origin &&
      other.content == content &&
      other.pose == pose &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.placeName == placeName &&
      other.thumbnailPath == thumbnailPath &&
      other.createdAt == createdAt &&
      other.shareStatus == shareStatus &&
      other.shareCode == shareCode &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(
    objectId,
    ownerId,
    origin,
    content,
    pose,
    latitude,
    longitude,
    placeName,
    thumbnailPath,
    createdAt,
    shareStatus,
    shareCode,
    expiresAt,
  );
}
