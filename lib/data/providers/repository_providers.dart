import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ar_app/data/providers/database_providers.dart';
import 'package:ar_app/data/repositories/ar_object_repository.dart';

final arObjectRepositoryProvider = Provider<ArObjectRepository>((ref) {
  return ArObjectRepository(ref.watch(appDatabaseProvider));
});
