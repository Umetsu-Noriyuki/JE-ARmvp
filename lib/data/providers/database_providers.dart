import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ar_app/data/db/app_database.dart';

/// アプリのローカルDB。Provider 破棄時に接続を閉じる
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
