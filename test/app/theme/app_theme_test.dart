import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/app/theme/app_colors.dart';
import 'package:ar_app/app/theme/app_text_styles.dart';
import 'package:ar_app/app/theme/app_theme.dart';

void main() {
  group('AppTheme.light', () {
    final theme = AppTheme.light;

    test('正常系: primary / secondary にデザイン仕様のカラーが設定される', () {
      expect(theme.colorScheme.primary, AppColors.PRIMARY_NAVY);
      expect(theme.colorScheme.secondary, AppColors.ACCENT_GOLD);
      expect(theme.colorScheme.error, AppColors.WARNING_RED);
    });

    test('正常系: 背景色にデザイン仕様の Background が設定される', () {
      expect(theme.scaffoldBackgroundColor, AppColors.BACKGROUND);
    });

    test('正常系: AppBar は Navy 背景・白文字となる', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.PRIMARY_NAVY);
      expect(theme.appBarTheme.foregroundColor, AppColors.CARD_WHITE);
      expect(theme.appBarTheme.titleTextStyle?.color, AppColors.CARD_WHITE);
    });

    test('正常系: TextTheme に定義済みの TextStyle が割り当てられる', () {
      expect(
        theme.textTheme.titleLarge?.fontSize,
        AppTextStyles.TITLE.fontSize,
      );
      expect(
        theme.textTheme.bodySmall?.fontSize,
        AppTextStyles.CAPTION.fontSize,
      );
    });
  });
}
