import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ar_app/app/router/route_names.dart';
import 'package:ar_app/core/constants/app_constants.dart';

/// ホーム画面（ARを作成 / マイAR / 共有コード入力 への入口）
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.APP_TITLE)),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.DEFAULT_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMenuButton(
              context,
              icon: Icons.add_a_photo,
              label: 'ARを作成',
              routeName: RouteNames.AR_CREATE,
            ),
            _buildMenuButton(
              context,
              icon: Icons.list_alt,
              label: 'マイAR',
              routeName: RouteNames.MY_AR,
            ),
            _buildMenuButton(
              context,
              icon: Icons.qr_code,
              label: '共有コード入力',
              routeName: RouteNames.SHARE_RECEIVE,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String routeName,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.DEFAULT_PADDING),
      child: FilledButton.icon(
        onPressed: () => context.pushNamed(routeName),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
