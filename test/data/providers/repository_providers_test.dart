import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/providers/database_providers.dart';
import 'package:ar_app/data/providers/repository_providers.dart';
import 'package:ar_app/data/repositories/ar_object_repository.dart';

import '../../helper/ar_object_fixtures.dart';

void main() {
  group('arObjectRepositoryProvider', () {
    test('正常系: 差し替えた DB を使う ArObjectRepository を生成する', () async {
      final database = createInMemoryDatabase();
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);

      final repository = container.read(arObjectRepositoryProvider);
      await repository.insert(buildArObject());

      expect(repository, isA<ArObjectRepository>());
      expect(await database.select(database.arObjects).get(), hasLength(1));
    });
  });
}
