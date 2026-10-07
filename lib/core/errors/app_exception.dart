/// アプリ独自例外の基底クラス
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// 対象データが存在しない
final class NotFoundException extends AppException {
  const NotFoundException(super.message);
}
