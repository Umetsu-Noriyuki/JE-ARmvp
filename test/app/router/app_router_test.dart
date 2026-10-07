import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/app/router/app_router.dart';
import 'package:ar_app/app/router/route_names.dart';
import 'package:ar_app/features/ar_create/ar_create_pages.dart';
import 'package:ar_app/features/home/home_pages.dart';
import 'package:ar_app/features/my_ar/my_ar_pages.dart';
import 'package:ar_app/features/share_receive/share_receive_pages.dart';

import '../../helper/pump_app.dart';

void main() {
  group('appRouterProvider', () {
    test('正常系: 初期表示はホームのパスである', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);

      expect(router.routeInformationProvider.value.uri.path, RoutePaths.HOME);
    });

    testWidgets('正常系: 起動時にホーム画面が表示される', (tester) async {
      await pumpApp(tester);

      expect(find.byType(HomePage), findsOneWidget);
    });

    final routeCases = {
      RouteNames.AR_CREATE: ArCreatePage,
      RouteNames.MY_AR: MyArPage,
      RouteNames.SHARE_RECEIVE: ShareReceivePage,
    };
    for (final entry in routeCases.entries) {
      testWidgets('正常系: ${entry.key} へ遷移すると ${entry.value} が表示される', (
        tester,
      ) async {
        final container = await pumpApp(tester);

        unawaited(container.read(appRouterProvider).pushNamed(entry.key));
        await tester.pumpAndSettle();

        expect(find.byType(entry.value), findsOneWidget);
      });
    }
  });
}
