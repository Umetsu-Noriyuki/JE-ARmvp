import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ar_app/core/constants/app_constants.dart';
import 'package:ar_app/features/ar_create/ar_create_providers.dart';
import 'package:ar_app/features/ar_create/ar_create_viewmodels.dart';
import 'package:ar_app/features/ar_create/widgets/ar_pose_panel.dart';
import 'package:ar_app/features/ar_create/widgets/ar_scene_view.dart';

/// AR作成画面
///
/// Step 3（技術スパイク）: 平面をタップして固定の文字オブジェクトを配置し、
/// 大きさの変更と配置情報（ArPose）の取得を確認する。
class ArCreatePage extends ConsumerWidget {
  const ArCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArSupported = ref.watch(isArSupportedPlatformProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('ARを作成')),
      body: Column(
        children: [
          Expanded(
            child: isArSupported
                ? _buildArScene(ref)
                : const Center(child: Text('この端末ではARを利用できません')),
          ),
          const _ArControlPanel(),
        ],
      ),
    );
  }

  Widget _buildArScene(WidgetRef ref) {
    final viewModel = ref.read(arCreateViewModelProvider.notifier);
    final nodeScale = ref.watch(
      arCreateViewModelProvider.select((state) => state.nodeScale),
    );
    return ArSceneView(
      prepareModelUri: viewModel.preparePreviewModel,
      nodeScale: nodeScale,
      onPlaced: (anchorTransform, nodeTransform) => viewModel.onPlaced(
        anchorTransform: anchorTransform,
        nodeTransform: nodeTransform,
      ),
      onNodeTransformed: viewModel.onNodeTransformed,
      onError: viewModel.onError,
    );
  }
}

/// 操作説明・エラー・大きさ変更・配置情報を表示する下部パネル
class _ArControlPanel extends ConsumerWidget {
  const _ArControlPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arCreateViewModelProvider);
    final pose = state.placedPose;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.DEFAULT_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(state.isPlaced ? 'ドラッグで移動、2本指で回転できます' : '検出された平面をタップして配置'),
            if (state.errorMessage case final message?)
              Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (pose != null) ...[
              _buildScaleSlider(ref, state.nodeScale),
              ArPosePanel(pose: pose),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScaleSlider(WidgetRef ref, double nodeScale) {
    return Row(
      children: [
        const Text('大きさ'),
        Expanded(
          child: Slider(
            value: nodeScale,
            min: ArCreateViewModel.MIN_NODE_SCALE,
            max: ArCreateViewModel.MAX_NODE_SCALE,
            onChanged: ref.read(arCreateViewModelProvider.notifier).changeScale,
          ),
        ),
      ],
    );
  }
}
