import 'package:drift/drift.dart';

import 'package:ar_app/core/errors/app_exception.dart';
import 'package:ar_app/data/db/app_database.dart';
import 'package:ar_app/data/models/ar_object/ar_object.dart';

/// 端末内のARオブジェクトの永続化を行う
///
/// 日時は UTC に揃えて保存し、UTC のまま返す（表示時に UI 側で `toLocal()` する）。
/// 保存データが壊れている場合は [DataFormatException] を送出するため、
/// 呼び出し側（ViewModel）はエラー状態として扱うこと。
class ArObjectRepository {
  const ArObjectRepository(this._database);

  final AppDatabase _database;

  /// 全件を作成日時の新しい順で監視する
  Stream<List<ArObject>> watchAll() {
    final query = _database.select(_database.arObjects)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query
        .watch()
        .map((records) => List<ArObject>.unmodifiable(records.map(_toModel)))
        .handleError(_throwDataFormatException, test: _isFormatException);
  }

  /// [objectId] のオブジェクトを取得する。存在しない場合は null
  Future<ArObject?> findById(String objectId) async {
    final query = _database.select(_database.arObjects)
      ..where((t) => t.objectId.equals(objectId));
    try {
      final record = await query.getSingleOrNull();
      return record == null ? null : _toModel(record);
    } on FormatException catch (error) {
      _throwDataFormatException(error);
    }
  }

  /// 新規に保存する
  ///
  /// 同じ objectId が既に存在する場合は [DuplicateException] を送出する。
  Future<void> insert(ArObject arObject) async {
    await _database.transaction(() async {
      if (await _exists(arObject.objectId)) {
        throw DuplicateException(
          'ArObject already exists: ${arObject.objectId}',
        );
      }
      await _database.into(_database.arObjects).insert(_toRecord(arObject));
    });
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

  Future<bool> _exists(String objectId) async {
    final query = _database.selectOnly(_database.arObjects)
      ..addColumns([_database.arObjects.objectId])
      ..where(_database.arObjects.objectId.equals(objectId));
    return await query.getSingleOrNull() != null;
  }

  bool _isFormatException(Object? error) => error is FormatException;

  Never _throwDataFormatException(Object error) {
    throw DataFormatException('Invalid ArObject data: $error');
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
      createdAt: arObject.createdAt.toUtc(),
      shareStatus: arObject.shareStatus,
      shareCode: arObject.shareCode,
      expiresAt: arObject.expiresAt?.toUtc(),
    );
  }
}
