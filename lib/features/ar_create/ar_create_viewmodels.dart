import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart';

import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/core/enums/text_horizontal_align.dart';
import 'package:ar_app/core/enums/text_vertical_align.dart';
import 'package:ar_app/core/enums/writing_direction.dart';
import 'package:ar_app/data/models/ar_object/ar_object_content.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';
import 'package:ar_app/data/providers/service_providers.dart';

/// AR作成画面の状態
class ArCreateState {
  const ArCreateState({
    this.placedPose,
    this.nodeScale = ArCreateViewModel.DEFAULT_NODE_SCALE,
    this.errorMessage,
  });

  /// 配置済みオブジェクトの配置情報。未配置の場合は null
  final ArPose? placedPose;

  /// 配置済みオブジェクトの大きさ（等倍 = 1.0）
  final double nodeScale;
  final String? errorMessage;

  bool get isPlaced => placedPose != null;

  ArCreateState copyWith({
    ArPose? Function()? placedPose,
    double? nodeScale,
    String? Function()? errorMessage,
  }) {
    return ArCreateState(
      placedPose: placedPose != null ? placedPose() : this.placedPose,
      nodeScale: nodeScale ?? this.nodeScale,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

/// AR作成画面の ViewModel
///
/// Step 3（技術スパイク）では固定の文字オブジェクトを配置し、
/// 配置結果を [ArPose] に変換できることを検証する。
class ArCreateViewModel extends Notifier<ArCreateState> {
  static const double DEFAULT_NODE_SCALE = 1.0;
  static const double MIN_NODE_SCALE = 0.2;
  static const double MAX_NODE_SCALE = 3.0;

  /// 板の幅（メートル）。高さは画像の縦横比から決める
  static const double BOARD_WIDTH_METERS = 0.5;
  static const String PREVIEW_MODEL_FILE_NAME = 'preview.glb';

  static const TextContent SPIKE_TEXT_CONTENT = TextContent(
    text: 'ここに集合！',
    fontSize: 32,
    textColorArgb: 0xFFFFFFFF,
    backgroundColorArgb: 0xFF0B1F44,
    horizontalAlign: TextHorizontalAlign.center,
    verticalAlign: TextVerticalAlign.center,
    writingDirection: WritingDirection.horizontal,
  );

  @override
  ArCreateState build() => const ArCreateState();

  /// 配置するオブジェクトの GLB を生成・保存し、ノードに指定する URI を返す
  Future<String> preparePreviewModel() async {
    final texture = await ref
        .read(arTextureRendererServiceProvider)
        .renderText(SPIKE_TEXT_CONTENT);
    final glbBytes = ref
        .read(glbQuadBuilderServiceProvider)
        .build(
          pngBytes: texture.pngBytes,
          width: BOARD_WIDTH_METERS,
          height: BOARD_WIDTH_METERS * texture.heightPerWidth,
        );
    return ref
        .read(arModelFileServiceProvider)
        .writeGlb(PREVIEW_MODEL_FILE_NAME, glbBytes);
  }

  /// 平面アンカーにオブジェクトを配置した
  void onPlaced({
    required Matrix4 anchorTransform,
    required Matrix4 nodeTransform,
  }) {
    final planeType = ArPoseCalculator.planeTypeOf(anchorTransform);
    state = state.copyWith(
      placedPose: () => ArPoseCalculator.fromNodeTransform(
        nodeTransform,
        planeType: planeType,
      ),
      nodeScale: DEFAULT_NODE_SCALE,
      errorMessage: () => null,
    );
  }

  /// ジェスチャでオブジェクトが移動・回転された
  void onNodeTransformed(Matrix4 nodeTransform) {
    final pose = state.placedPose;
    if (pose == null) return;
    state = state.copyWith(
      placedPose: () => ArPoseCalculator.fromNodeTransform(
        nodeTransform,
        planeType: pose.planeType,
      ),
    );
  }

  /// オブジェクトの大きさを変更する（範囲外の値は丸める）
  void changeScale(double scale) {
    final clamped = scale.clamp(MIN_NODE_SCALE, MAX_NODE_SCALE).toDouble();
    final pose = state.placedPose;
    state = state.copyWith(
      nodeScale: clamped,
      placedPose: pose == null ? null : () => pose.copyWith(scale: clamped),
    );
  }

  void onError(String message) {
    state = state.copyWith(errorMessage: () => message);
  }
}

/// AR の変換行列から [ArPose] を算出する
abstract final class ArPoseCalculator {
  /// 平面の法線と鉛直方向のなす角がこの角度の余弦以上なら水平面とみなす（45度）
  static const double HORIZONTAL_COSINE_THRESHOLD = 0.7071;

  /// 平面アンカーの Y 軸（法線）の向きから平面の種類を判定する
  static PlaneType planeTypeOf(Matrix4 anchorTransform) {
    final normal = anchorTransform.getColumn(1).xyz;
    if (normal.length2 == 0) return PlaneType.horizontal;
    final cosine = normal.normalized().dot(Vector3(0, 1, 0)).abs();
    return cosine >= HORIZONTAL_COSINE_THRESHOLD
        ? PlaneType.horizontal
        : PlaneType.vertical;
  }

  /// アンカーに対するノードの変換行列を位置・回転・大きさに分解する
  static ArPose fromNodeTransform(
    Matrix4 nodeTransform, {
    required PlaneType planeType,
    double? compassHeading,
  }) {
    final translation = Vector3.zero();
    final rotation = Quaternion.identity();
    final scale = Vector3.zero();
    nodeTransform.decompose(translation, rotation, scale);
    return ArPose(
      positionX: translation.x,
      positionY: translation.y,
      positionZ: translation.z,
      rotationX: rotation.x,
      rotationY: rotation.y,
      rotationZ: rotation.z,
      rotationW: rotation.w,
      scale: scale.x,
      planeType: planeType,
      compassHeading: compassHeading,
    );
  }
}
