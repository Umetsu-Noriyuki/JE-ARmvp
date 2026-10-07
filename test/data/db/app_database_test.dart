import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/db/app_database.dart';

import '../../helper/ar_object_fixtures.dart';

void main() {
  group('AppDatabase', () {
    test('正常系: スキーマバージョンは 1 である', () {
      final database = createInMemoryDatabase();

      expect(database.schemaVersion, 1);
    });

    test('正常系: DB ファイル名が定義されている', () {
      expect(AppDatabase.DATABASE_NAME, 'ar_app');
    });

    test('正常系: 作成直後に ar_objects テーブルが空で利用できる', () async {
      final database = createInMemoryDatabase();

      final records = await database.select(database.arObjects).get();

      expect(records, isEmpty);
    });
  });
}
