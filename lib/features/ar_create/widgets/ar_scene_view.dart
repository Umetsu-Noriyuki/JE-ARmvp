import 'dart:async';
import 'dart:io';

import 'package:ar_flutter_plugin_plus/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_plus/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_plus/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_plus/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_plus/models/ar_node.dart';
import 'package:ar_flutter_plugin_plus/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// ARカメラ映像を表示し、タップした平面にオブジェクトを1つ配置する
///
/// ar_flutter_plugin_plus をラップし、配置・変形の結果を変換行列で通知する。
/// 新たに平面をタップすると、配置済みのオブジェクトを置き換える。
class ArSceneView extends StatefulWidget {
  const ArSceneView({
    super.key,
    required this.prepareModelUri,
    required this.nodeScale,
    required this.onPlaced,
    required this.onNodeTransformed,
    required this.onError,
  });

  /// 配置する GLB を用意し、ノードに指定する URI を返す
  final Future<String> Function() prepareModelUri;

  /// 配置済みオブジェクトの大きさ（等倍 = 1.0）
  final double nodeScale;
  final void Function(Matrix4 anchorTransform, Matrix4 nodeTransform) onPlaced;
  final void Function(Matrix4 nodeTransform) onNodeTransformed;
  final void Function(String message) onError;

  @override
  State<ArSceneView> createState() => _ArSceneViewState();
}

class _ArSceneViewState extends State<ArSceneView> {
  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;
  ARPlaneAnchor? _placedAnchor;
  ARNode? _placedNode;
  bool _isPlacing = false;

  @override
  void didUpdateWidget(covariant ArSceneView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final node = _placedNode;
    if (node != null && oldWidget.nodeScale != widget.nodeScale) {
      node.scale = Vector3.all(widget.nodeScale);
    }
  }

  @override
  void dispose() {
    unawaited(_sessionManager?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ARView(
      onARViewCreated: _onArViewCreated,
      planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      permissionPromptDescription: 'ARを利用するにはカメラへのアクセスを許可してください',
      permissionPromptButtonText: '許可する',
    );
  }

  void _onArViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    _sessionManager = sessionManager;
    _objectManager = objectManager;
    _anchorManager = anchorManager;
    unawaited(
      sessionManager.onInitialize(
        showPlanes: true,
        handleTaps: true,
        handlePans: true,
        handleRotation: true,
      ),
    );
    objectManager.onInitialize();
    sessionManager.onPlaneOrPointTap = _onPlaneOrPointTap;
    objectManager.onPanEnd = (_, transform) =>
        widget.onNodeTransformed(transform);
    objectManager.onRotationEnd = (_, transform) =>
        widget.onNodeTransformed(transform);
  }

  Future<void> _onPlaneOrPointTap(List<ARHitTestResult> hits) async {
    if (_isPlacing) return;
    final planeHits = hits.where(
      (hit) => hit.type == ARHitTestResultType.plane,
    );
    if (planeHits.isEmpty) {
      widget.onError('平面が検出されていません。カメラをゆっくり動かしてください');
      return;
    }
    _isPlacing = true;
    try {
      await _placeNode(planeHits.first.worldTransform);
    } on FileSystemException catch (e) {
      widget.onError('モデルファイルの保存に失敗しました: ${e.message}');
    } finally {
      _isPlacing = false;
    }
  }

  Future<void> _placeNode(Matrix4 worldTransform) async {
    final anchorManager = _anchorManager;
    final objectManager = _objectManager;
    if (anchorManager == null || objectManager == null) return;

    _removePlacedNode();
    final anchor = ARPlaneAnchor(transformation: worldTransform);
    if (await anchorManager.addAnchor(anchor) != true) {
      widget.onError('アンカーの追加に失敗しました');
      return;
    }
    _placedAnchor = anchor;

    final node = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      uri: await widget.prepareModelUri(),
      scale: Vector3.all(widget.nodeScale),
    );
    if (await objectManager.addNode(node, planeAnchor: anchor) != true) {
      widget.onError('オブジェクトの配置に失敗しました');
      return;
    }
    _placedNode = node;
    widget.onPlaced(anchor.transformation, node.transform);
  }

  void _removePlacedNode() {
    final node = _placedNode;
    final anchor = _placedAnchor;
    if (node != null) _objectManager?.removeNode(node);
    if (anchor != null) _anchorManager?.removeAnchor(anchor);
    _placedNode = null;
    _placedAnchor = null;
  }
}
