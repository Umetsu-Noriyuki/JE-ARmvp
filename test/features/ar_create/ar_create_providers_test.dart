import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/features/ar_create/ar_create_providers.dart';
import 'package:ar_app/features/ar_create/ar_create_viewmodels.dart';

void main() {
  group('isArSupportedPlatformProvider', () {
    test('正常系: テスト実行環境（デスクトップ）では false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(isArSupportedPlatformProvider), isFalse);
    });
  });

  group('arCreateViewModelProvider', () {
    test('正常系: 初期状態の ArCreateState を返す', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(arCreateViewModelProvider);

      expect(state, isA<ArCreateState>());
      expect(state.isPlaced, isFalse);
    });

    test('正常系: 購読が無くなると状態が破棄される', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        arCreateViewModelProvider,
        (_, _) {},
      );
      container.read(arCreateViewModelProvider.notifier).onError('error');

      subscription.close();
      await container.pump();

      expect(container.read(arCreateViewModelProvider).errorMessage, isNull);
    });
  });
}
