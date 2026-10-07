import 'package:flutter/material.dart';

/// 共有AR取得画面（後続ステップで実装する仮画面）
class ShareReceivePage extends StatelessWidget {
  const ShareReceivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('共有コード入力')),
      body: const Center(child: Text('準備中')),
    );
  }
}
