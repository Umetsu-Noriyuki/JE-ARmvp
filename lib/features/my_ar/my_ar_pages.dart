import 'package:flutter/material.dart';

/// マイAR画面（後続ステップで実装する仮画面）
class MyArPage extends StatelessWidget {
  const MyArPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マイAR')),
      body: const Center(child: Text('準備中')),
    );
  }
}
