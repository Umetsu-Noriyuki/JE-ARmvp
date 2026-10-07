import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ar_app/app/router/route_names.dart';
import 'package:ar_app/features/ar_create/ar_create_pages.dart';
import 'package:ar_app/features/home/home_pages.dart';
import 'package:ar_app/features/my_ar/my_ar_pages.dart';
import 'package:ar_app/features/share_receive/share_receive_pages.dart';

/// アプリ全体のルーティング定義
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: RoutePaths.HOME,
    routes: [
      GoRoute(
        path: RoutePaths.HOME,
        name: RouteNames.HOME,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.AR_CREATE,
        name: RouteNames.AR_CREATE,
        builder: (context, state) => const ArCreatePage(),
      ),
      GoRoute(
        path: RoutePaths.MY_AR,
        name: RouteNames.MY_AR,
        builder: (context, state) => const MyArPage(),
      ),
      GoRoute(
        path: RoutePaths.SHARE_RECEIVE,
        name: RouteNames.SHARE_RECEIVE,
        builder: (context, state) => const ShareReceivePage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
