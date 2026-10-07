import 'package:flutter/material.dart';

import 'package:ar_app/app/theme/app_colors.dart';
import 'package:ar_app/app/theme/app_text_styles.dart';

/// アプリ全体の ThemeData 定義
abstract final class AppTheme {
  static final ThemeData light = _buildLight();

  static ThemeData _buildLight() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.PRIMARY_NAVY,
      primary: AppColors.PRIMARY_NAVY,
      secondary: AppColors.ACCENT_GOLD,
      surface: AppColors.CARD_WHITE,
      error: AppColors.WARNING_RED,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.BACKGROUND,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.PRIMARY_NAVY,
        foregroundColor: AppColors.CARD_WHITE,
        titleTextStyle: AppTextStyles.HEADING.copyWith(
          color: AppColors.CARD_WHITE,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.TITLE,
        titleMedium: AppTextStyles.HEADING,
        bodyMedium: AppTextStyles.BODY,
        bodySmall: AppTextStyles.CAPTION,
      ),
    );
  }
}
