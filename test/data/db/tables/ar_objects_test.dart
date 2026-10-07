import 'package:flutter_test/flutter_test.dart';

import '../../../helper/ar_object_fixtures.dart';

void main() {
  group('ArObjects テーブル', () {
    test('正常系: テーブル名は ar_objects である', () {
      final database = createInMemoryDatabase();

      expect(database.arObjects.actualTableName, 'ar_objects');
    });

    test('正常系: 主キーは objectId である', () {
      final database = createInMemoryDatabase();

      expect(database.arObjects.primaryKey.map((column) => column.name), [
        'object_id',
      ]);
    });

    test('正常系: 任意項目の列は nullable、必須項目の列は非 nullable', () {
      final database = createInMemoryDatabase();
      final columns = {
        for (final column in database.arObjects.$columns)
          column.name: column.$nullable,
      };

      expect(columns, {
        'object_id': false,
        'owner_id': true,
        'origin': false,
        'object_type': false,
        'content': false,
        'pose': false,
        'latitude': true,
        'longitude': true,
        'place_name': true,
        'thumbnail_path': true,
        'created_at': false,
        'share_status': false,
        'share_code': true,
        'expires_at': true,
      });
    });

    test('正常系: created_at にインデックスが作成されている', () async {
      final database = createInMemoryDatabase();

      final rows = await database
          .customSelect(
            "SELECT sql FROM sqlite_master WHERE type = 'index' "
            "AND name = 'ar_objects_created_at'",
          )
          .get();

      expect(rows.single.read<String>('sql'), contains('(created_at)'));
    });
  });
}
