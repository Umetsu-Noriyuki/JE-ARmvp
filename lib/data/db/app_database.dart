import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:ar_app/core/enums/ar_object_origin.dart';
import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/share_status.dart';
import 'package:ar_app/data/db/converters/ar_object_converters.dart';
import 'package:ar_app/data/db/tables/ar_objects.dart';
import 'package:ar_app/data/models/ar_object/ar_object_content.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';

part 'app_database.g.dart';

/// アプリのローカルDB（Drift / SQLite）
@DriftDatabase(tables: [ArObjects])
class AppDatabase extends _$AppDatabase {
  /// [executor] 未指定時は端末内の DB ファイルを開く（テストではメモリDBを渡す）
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: DATABASE_NAME));

  static const String DATABASE_NAME = 'ar_app';

  @override
  int get schemaVersion => 1;
}
