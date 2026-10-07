import 'package:flutter/material.dart';

/// アプリ全体の TextStyle 定義（Title / Heading / Body / Caption）
abstract final class AppTextStyles {
  static const TextStyle TITLE = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle HEADING = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle BODY = TextStyle(fontSize: 16);

  static const TextStyle CAPTION = TextStyle(fontSize: 12);
}
