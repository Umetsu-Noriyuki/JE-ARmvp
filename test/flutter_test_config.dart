import 'dart:async';
import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:sqlite3/open.dart';

/// 全テスト共通の前処理（flutter test が自動で読み込む）
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  _useVersionedSqliteLibraryOnLinux();
  // テストごとに DB を生成するため、多重生成の警告を抑止する
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await testMain();
}

/// 開発用 Linux/WSL では libsqlite3-dev 未導入だと `libsqlite3.so` が無いため、
/// 開けない場合のみランタイムに含まれる `libsqlite3.so.0` を読み込む
void _useVersionedSqliteLibraryOnLinux() {
  open.overrideFor(OperatingSystem.linux, () {
    try {
      return DynamicLibrary.open('libsqlite3.so');
    } on ArgumentError {
      return DynamicLibrary.open('libsqlite3.so.0');
    }
  });
}
