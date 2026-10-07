import 'package:flutter/material.dart';

/// AR作成画面（後続ステップで実装する仮画面）
class ArCreatePage extends StatelessWidget {
  const ArCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ARを作成')),
      body: const Center(child: Text('準備中')),
    );
  }
}
