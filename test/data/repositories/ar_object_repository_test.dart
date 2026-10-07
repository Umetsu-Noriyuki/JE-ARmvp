import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/share_status.dart';
import 'package:ar_app/core/errors/app_exception.dart';
import 'package:ar_app/data/db/app_database.dart';
import 'package:ar_app/data/repositories/ar_object_repository.dart';

import '../../helper/ar_object_fixtures.dart';

void main() {
  late AppDatabase database;
  late ArObjectRepository repository;

  setUp(() {
    database = createInMemoryDatabase();
    repository = ArObjectRepository(database);
  });

  /// content 列に不正な JSON を持つ行を直接書き込む
  Future<void> insertBrokenRecord() async {
    await repository.insert(buildArObject(objectId: 'broken'));
    await database.customUpdate(
      "UPDATE ar_objects SET content = '{broken' WHERE object_id = 'broken'",
      updates: {database.arObjects},
    );
  }

  group('ArObjectRepository.insert / findById', () {
    test('正常系: 保存したオブジェクトを全項目そのまま取得できる', () async {
      final object = buildArObject(
        shareStatus: ShareStatus.sharing,
        expiresAt: DateTime.utc(2026, 10, 1, 10, 0, 0, 123),
      ).copyWith(shareCode: () => 'ABC123', placeName: () => '福島駅');

      await repository.insert(object);

      expect(await repository.findById(object.objectId), object);
    });

    test('正常系: 図形オブジェクトも保存・取得できる', () async {
      final object = buildArObject(content: SAMPLE_SHAPE_CONTENT);

      await repository.insert(object);

      expect(await repository.findById(object.objectId), object);
    });

    test('正常系: 存在しない ID の場合は null を返す', () async {
      expect(await repository.findById('missing'), isNull);
    });

    test('異常系: 同じ objectId を重複して保存すると例外となる', () async {
      await repository.insert(buildArObject());

      expect(
        () => repository.insert(buildArObject()),
        throwsA(isA<DuplicateException>()),
      );
    });

    test('正常系: objectType 列には content の種類が保存される', () async {
      await repository.insert(buildArObject(objectId: 'text'));
      await repository.insert(
        buildArObject(objectId: 'shape', content: SAMPLE_SHAPE_CONTENT),
      );

      final records = await database.select(database.arObjects).get();
      final types = {
        for (final record in records) record.objectId: record.objectType,
      };

      expect(types, {'text': ArObjectType.text, 'shape': ArObjectType.shape});
    });

    test('正常系: ローカル時刻で保存しても同じ時刻の UTC として取得できる', () async {
      final createdAt = DateTime(2026, 9, 30, 19, 0, 0, 123);
      final expiresAt = DateTime(2026, 10, 1, 19);

      await repository.insert(
        buildArObject(
          createdAt: createdAt,
          shareStatus: ShareStatus.sharing,
          expiresAt: expiresAt,
        ),
      );
      final object = await repository.findById('object-1');

      final row = await database
          .customSelect('SELECT created_at FROM ar_objects')
          .getSingle();

      expect(row.read<String>('created_at'), endsWith('Z'));
      expect(object?.createdAt.isUtc, isTrue);
      expect(object?.createdAt, createdAt.toUtc());
      expect(object?.expiresAt, expiresAt.toUtc());
    });

    test('異常系: 保存データが壊れている場合は DataFormatException', () async {
      await insertBrokenRecord();

      expect(
        () => repository.findById('broken'),
        throwsA(isA<DataFormatException>()),
      );
    });
  });

  group('ArObjectRepository.update', () {
    test('正常系: 既存オブジェクトを更新できる', () async {
      final object = buildArObject();
      await repository.insert(object);
      final updated = object.copyWith(
        shareStatus: ShareStatus.sharing,
        shareCode: () => 'XYZ789',
      );

      await repository.update(updated);

      expect(await repository.findById(object.objectId), updated);
    });

    test('異常系: 存在しないオブジェクトの更新は NotFoundException', () async {
      expect(
        () => repository.update(buildArObject()),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('ArObjectRepository.delete', () {
    test('正常系: 指定したオブジェクトのみ削除される', () async {
      await repository.insert(buildArObject(objectId: 'a'));
      await repository.insert(buildArObject(objectId: 'b'));

      await repository.delete('a');

      expect(await repository.findById('a'), isNull);
      expect(await repository.findById('b'), isNotNull);
    });

    test('正常系: 存在しない ID を削除しても例外にならない', () async {
      await expectLater(repository.delete('missing'), completes);
    });
  });

  group('ArObjectRepository.watchAll', () {
    test('正常系: 作成日時の新しい順で取得できる', () async {
      await repository.insert(
        buildArObject(objectId: 'old', createdAt: DateTime.utc(2026, 9, 1)),
      );
      await repository.insert(
        buildArObject(objectId: 'new', createdAt: DateTime.utc(2026, 9, 3)),
      );
      await repository.insert(
        buildArObject(objectId: 'mid', createdAt: DateTime.utc(2026, 9, 2)),
      );

      final objects = await repository.watchAll().first;

      expect(objects.map((object) => object.objectId), ['new', 'mid', 'old']);
    });

    test('正常系: ローカル時刻と UTC が混在しても作成日時の新しい順になる', () async {
      final base = DateTime.utc(2026, 9, 30, 10);
      await repository.insert(
        buildArObject(
          objectId: 'old',
          createdAt: base.subtract(const Duration(hours: 1)),
        ),
      );
      await repository.insert(
        buildArObject(
          objectId: 'new',
          createdAt: base.add(const Duration(hours: 1)).toLocal(),
        ),
      );
      await repository.insert(buildArObject(objectId: 'mid', createdAt: base));

      final objects = await repository.watchAll().first;

      expect(objects.map((object) => object.objectId), ['new', 'mid', 'old']);
    });

    test('正常系: 0件の場合は空リストを返す', () async {
      expect(await repository.watchAll().first, isEmpty);
    });

    test('正常系: 追加・削除に応じて新しい一覧が通知される', () async {
      final emitted = repository.watchAll().map(
        (objects) => objects.map((object) => object.objectId).toList(),
      );

      final expectation = expectLater(
        emitted,
        emitsInOrder([
          <String>[],
          ['a'],
          <String>[],
        ]),
      );
      await pumpEventQueue();
      await repository.insert(buildArObject(objectId: 'a'));
      await pumpEventQueue();
      await repository.delete('a');

      await expectation;
    });

    test('異常系: 返却される一覧は変更できない', () async {
      await repository.insert(buildArObject());

      final objects = await repository.watchAll().first;

      expect(() => objects.add(buildArObject()), throwsUnsupportedError);
    });

    test('異常系: 保存データが壊れている場合は DataFormatException', () async {
      await insertBrokenRecord();

      expect(repository.watchAll().first, throwsA(isA<DataFormatException>()));
    });
  });
}
