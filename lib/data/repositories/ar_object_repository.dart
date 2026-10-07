import 'package:drift/drift.dart';

import 'package:ar_app/core/errors/app_exception.dart';
import 'package:ar_app/data/db/app_database.dart';
import 'package:ar_app/data/models/ar_object/ar_object.dart';

/// 端末内のARオブジェクトの永続化を行う
class ArObjectRepository {
  const ArObjectRepository(this._database);

  final AppDatabase _database;

  /// 全件を作成日時の新しい順で監視する
  Stream<List<ArObject>> watchAll() {
    final query = _database.select(_database.arObjects)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map(
      (records) => List.unmodifiable(records.map(_toModel)),
    );
  }

  /// [objectId] のオブジェクトを取得する。存在しない場合は null
  Future<ArObject?> findById(String objectId) async {
    final query = _database.select(_database.arObjects)
      ..where((t) => t.objectId.equals(objectId));
    final record = await query.getSingleOrNull();
    return record == null ? null : _toModel(record);
  }

  /// 新規に保存する。同じ objectId が既に存在する場合は例外となる
  Future<void> insert(ArObject arObject) async {
    await _database.into(_database.arObjects).insert(_toRecord(arObject));
  }

  /// 既存のオブジェクトを更新する
  ///
  /// 対象が存在しない場合は [NotFoundException] を送出する。
  Future<void> update(ArObject arObject) async {
    final isUpdated = await _database
        .update(_database.arObjects)
        .replace(_toRecord(arObject));
    if (!isUpdated) {
      throw NotFoundException('ArObject not found: ${arObject.objectId}');
    }
  }

  /// [objectId] のオブジェクトを削除する。存在しない場合は何もしない
  Future<void> delete(String objectId) async {
    await (_database.delete(
      _database.arObjects,
    )..where((t) => t.objectId.equals(objectId))).go();
  }

  ArObject _toModel(ArObjectRecord record) {
    return ArObject(
      objectId: record.objectId,
      ownerId: record.ownerId,
      origin: record.origin,
      content: record.content,
      pose: record.pose,
      latitude: record.latitude,
      longitude: record.longitude,
      placeName: record.placeName,
      thumbnailPath: record.thumbnailPath,
      createdAt: record.createdAt,
      shareStatus: record.shareStatus,
      shareCode: record.shareCode,
      expiresAt: record.expiresAt,
    );
  }

  ArObjectRecord _toRecord(ArObject arObject) {
    return ArObjectRecord(
      objectId: arObject.objectId,
      ownerId: arObject.ownerId,
      origin: arObject.origin,
      objectType: arObject.type,
      content: arObject.content,
      pose: arObject.pose,
      latitude: arObject.latitude,
      longitude: arObject.longitude,
      placeName: arObject.placeName,
      thumbnailPath: arObject.thumbnailPath,
      createdAt: arObject.createdAt,
      shareStatus: arObject.shareStatus,
      shareCode: arObject.shareCode,
      expiresAt: arObject.expiresAt,
    );
  }
}
