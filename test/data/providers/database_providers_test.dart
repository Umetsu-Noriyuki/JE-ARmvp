import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/db/app_database.dart';
import 'package:ar_app/data/providers/database_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // driftDatabase() が DB ファイルの保存先を path_provider から取得するため、
  // 一時ディレクトリを返すようにモックする
  setUp(() {
    final tempDirectory = Directory.systemTemp.createTempSync('ar_app_db_');
    addTearDown(() => tempDirectory.deleteSync(recursive: true));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => tempDirectory.path,
        );
  });

  group('appDatabaseProvider', () {
    // onDispose では close 完了を待てないため、一時ディレクトリ削除前に
    // テスト側で close 完了を待つ（close は冪等。tearDown は登録の逆順に実行される）
    test('正常系: AppDatabase を生成し、同一コンテナ内では同じインスタンスを返す', () {
      final container = ProviderContainer();
      final database = container.read(appDatabaseProvider);
      addTearDown(database.close);
      addTearDown(container.dispose);

      expect(database, isA<AppDatabase>());
      expect(container.read(appDatabaseProvider), same(database));
    });

    test('正常系: コンテナ破棄時に例外なく DB を閉じる', () {
      final container = ProviderContainer();
      final database = container.read(appDatabaseProvider);
      addTearDown(database.close);

      expect(container.dispose, returnsNormally);
    });
  });
}
