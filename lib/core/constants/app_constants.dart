/// アプリ全体で共通利用する定数
abstract final class AppConstants {
  /// アプリ表示名
  static const String APP_TITLE = 'AR共有';

  /// 共有期限（共有開始からの時間）
  static const Duration SHARE_DURATION = Duration(hours: 24);

  /// 画面の標準余白
  static const double DEFAULT_PADDING = 16.0;
}
