import 'package:drift/drift.dart';

import 'package:ar_app/core/enums/ar_object_origin.dart';
import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/share_status.dart';
import 'package:ar_app/data/db/converters/ar_object_converters.dart';

/// 端末内のARオブジェクト
@DataClassName('ArObjectRecord')
@TableIndex(name: 'ar_objects_created_at', columns: {#createdAt})
class ArObjects extends Table {
  TextColumn get objectId => text()();
  TextColumn get ownerId => text().nullable()();
  TextColumn get origin => textEnum<ArObjectOrigin>()();

  /// 検索・集計用。値は [content] の種類と一致させる
  TextColumn get objectType => textEnum<ArObjectType>()();
  TextColumn get content => text().map(const ArObjectContentConverter())();
  TextColumn get pose => text().map(const ArPoseConverter())();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get placeName => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get shareStatus => textEnum<ShareStatus>()();
  TextColumn get shareCode => text().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {objectId};
}
