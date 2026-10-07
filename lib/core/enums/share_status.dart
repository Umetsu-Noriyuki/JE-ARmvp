/// ARオブジェクトの共有状態
enum ShareStatus {
  /// 非共有
  notShared,

  /// 共有中
  sharing,

  /// 共有終了
  ended,
}
