import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ar_app/app/router/app_router.dart';
import 'package:ar_app/app/theme/app_theme.dart';
import 'package:ar_app/core/constants/app_constants.dart';

/// アプリのルート Widget（テーマ・ルーター設定）
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: AppConstants.APP_TITLE,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
