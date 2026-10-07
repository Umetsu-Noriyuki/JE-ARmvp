import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vector_math/vector_math_64.dart';

import 'package:ar_app/core/enums/plane_type.dart';
import 'package:ar_app/data/providers/service_providers.dart';
import 'package:ar_app/data/services/ar_model_file_service.dart';
import 'package:ar_app/data/services/ar_texture_renderer_service.dart';
import 'package:ar_app/data/services/glb_quad_builder_service.dart';
import 'package:ar_app/features/ar_create/ar_create_providers.dart';
import 'package:ar_app/features/ar_create/ar_create_viewmodels.dart';

import '../../helper/ar_object_fixtures.dart';

class _MockTextureRenderer extends Mock implements ArTextureRendererService {}

class _MockGlbBuilder extends Mock implements GlbQuadBuilderService {}

class _MockModelFileService extends Mock implements ArModelFileService {}

Matrix4 _rotationX(double degrees) =>
    Matrix4.rotationX(degrees * math.pi / 180);

void main() {
  setUpAll(() {
    registerFallbackValue(SAMPLE_TEXT_CONTENT);
    registerFallbackValue(Uint8List(0));
  });

  group('ArPoseCalculator.planeTypeOf', () {
    test('正常系: 単位行列（法線が上向き）は水平面', () {
      expect(
        ArPoseCalculator.planeTypeOf(Matrix4.identity()),
        PlaneType.horizontal,
      );
    });

    test('正常系: 法線が下向き（天井）も水平面', () {
      expect(
        ArPoseCalculator.planeTypeOf(_rotationX(180)),
        PlaneType.horizontal,
      );
    });

    test('正常系: 法線が水平（壁）は垂直面', () {
      expect(ArPoseCalculator.planeTypeOf(_rotationX(90)), PlaneType.vertical);
    });

    test('正常系: 30度の傾きは水平面、60度の傾きは垂直面', () {
      expect(
        ArPoseCalculator.planeTypeOf(_rotationX(30)),
        PlaneType.horizontal,
      );
      expect(ArPoseCalculator.planeTypeOf(_rotationX(60)), PlaneType.vertical);
    });

    test('異常系: 法線がゼロベクトルの場合は水平面とみなす', () {
      expect(
        ArPoseCalculator.planeTypeOf(Matrix4.zero()),
        PlaneType.horizontal,
      );
    });
  });

  group('ArPoseCalculator.fromNodeTransform', () {
    test('正常系: 単位行列は原点・無回転・等倍となる', () {
      final pose = ArPoseCalculator.fromNodeTransform(
        Matrix4.identity(),
        planeType: PlaneType.horizontal,
      );

      expect([pose.positionX, pose.positionY, pose.positionZ], [0.0, 0.0, 0.0]);
      expect(pose.rotationW, closeTo(1, 1e-9));
      expect(pose.scale, closeTo(1, 1e-9));
      expect(pose.compassHeading, isNull);
    });

    test('正常系: 位置・回転・大きさに分解される', () {
      final transform = Matrix4.compose(
        Vector3(0.1, 0.2, -0.3),
        Quaternion.axisAngle(Vector3(0, 1, 0), math.pi / 2),
        Vector3.all(2),
      );

      final pose = ArPoseCalculator.fromNodeTransform(
        transform,
        planeType: PlaneType.vertical,
        compassHeading: 45,
      );

      expect(pose.positionX, closeTo(0.1, 1e-9));
      expect(pose.positionY, closeTo(0.2, 1e-9));
      expect(pose.positionZ, closeTo(-0.3, 1e-9));
      expect(pose.rotationY.abs(), closeTo(math.sqrt1_2, 1e-6));
      expect(pose.rotationW.abs(), closeTo(math.sqrt1_2, 1e-6));
      expect(pose.scale, closeTo(2, 1e-9));
      expect(pose.planeType, PlaneType.vertical);
      expect(pose.compassHeading, 45);
    });
  });

  group('ArCreateViewModel', () {
    late ProviderContainer container;
    late _MockTextureRenderer renderer;
    late _MockGlbBuilder glbBuilder;
    late _MockModelFileService fileService;

    setUp(() {
      renderer = _MockTextureRenderer();
      glbBuilder = _MockGlbBuilder();
      fileService = _MockModelFileService();
      container = ProviderContainer(
        overrides: [
          arTextureRendererServiceProvider.overrideWithValue(renderer),
          glbQuadBuilderServiceProvider.overrideWithValue(glbBuilder),
          arModelFileServiceProvider.overrideWithValue(fileService),
        ],
      );
      addTearDown(container.dispose);
      // autoDispose のため、テスト中は購読を維持する
      container.listen(arCreateViewModelProvider, (_, _) {});
    });

    ArCreateViewModel viewModel() =>
        container.read(arCreateViewModelProvider.notifier);
    ArCreateState state() => container.read(arCreateViewModelProvider);

    test('正常系: 初期状態は未配置・等倍・エラーなし', () {
      expect(state().isPlaced, isFalse);
      expect(state().nodeScale, ArCreateViewModel.DEFAULT_NODE_SCALE);
      expect(state().errorMessage, isNull);
    });

    test('正常系: preparePreviewModel は画像→GLB→ファイル保存の順に処理し URI を返す', () async {
      final png = Uint8List.fromList([1]);
      final glb = Uint8List.fromList([2]);
      when(() => renderer.renderText(any())).thenAnswer(
        (_) async => ArTexture(pngBytes: png, widthPx: 200, heightPx: 100),
      );
      when(
        () => glbBuilder.build(
          pngBytes: any(named: 'pngBytes'),
          width: any(named: 'width'),
          height: any(named: 'height'),
        ),
      ).thenReturn(glb);
      when(
        () => fileService.writeGlb(any(), any()),
      ).thenAnswer((_) async => '/docs/ar_models/preview.glb');

      final uri = await viewModel().preparePreviewModel();

      expect(uri, '/docs/ar_models/preview.glb');
      verify(
        () => renderer.renderText(ArCreateViewModel.SPIKE_TEXT_CONTENT),
      ).called(1);
      verify(
        () => glbBuilder.build(
          pngBytes: png,
          width: ArCreateViewModel.BOARD_WIDTH_METERS,
          height: ArCreateViewModel.BOARD_WIDTH_METERS * 0.5,
        ),
      ).called(1);
      verify(
        () => fileService.writeGlb(
          ArCreateViewModel.PREVIEW_MODEL_FILE_NAME,
          glb,
        ),
      ).called(1);
    });

    test('異常系: ファイル保存に失敗した場合は例外が呼び出し元に伝わる', () async {
      when(() => renderer.renderText(any())).thenAnswer(
        (_) async => ArTexture(pngBytes: Uint8List(1), widthPx: 1, heightPx: 1),
      );
      when(
        () => glbBuilder.build(
          pngBytes: any(named: 'pngBytes'),
          width: any(named: 'width'),
          height: any(named: 'height'),
        ),
      ).thenReturn(Uint8List(1));
      when(
        () => fileService.writeGlb(any(), any()),
      ).thenThrow(const FileSystemExceptionStub());

      expect(
        viewModel().preparePreviewModel(),
        throwsA(isA<FileSystemExceptionStub>()),
      );
    });

    test('正常系: onPlaced で配置情報が設定され、エラーと大きさがリセットされる', () {
      viewModel()
        ..onError('error')
        ..changeScale(2);

      viewModel().onPlaced(
        anchorTransform: _rotationX(90),
        nodeTransform: Matrix4.translationValues(0, 0.1, 0),
      );

      expect(state().isPlaced, isTrue);
      expect(state().placedPose?.planeType, PlaneType.vertical);
      expect(state().placedPose?.positionY, closeTo(0.1, 1e-9));
      expect(state().nodeScale, ArCreateViewModel.DEFAULT_NODE_SCALE);
      expect(state().errorMessage, isNull);
    });

    test('正常系: onNodeTransformed で平面の種類を保ったまま配置情報が更新される', () {
      viewModel().onPlaced(
        anchorTransform: _rotationX(90),
        nodeTransform: Matrix4.identity(),
      );

      viewModel().onNodeTransformed(Matrix4.translationValues(0.5, 0, 0));

      expect(state().placedPose?.positionX, closeTo(0.5, 1e-9));
      expect(state().placedPose?.planeType, PlaneType.vertical);
    });

    test('正常系: 未配置の場合 onNodeTransformed は何もしない', () {
      viewModel().onNodeTransformed(Matrix4.translationValues(0.5, 0, 0));

      expect(state().isPlaced, isFalse);
    });

    test('正常系: changeScale で大きさと配置情報の scale が更新される', () {
      viewModel().onPlaced(
        anchorTransform: Matrix4.identity(),
        nodeTransform: Matrix4.identity(),
      );

      viewModel().changeScale(1.5);

      expect(state().nodeScale, 1.5);
      expect(state().placedPose?.scale, 1.5);
    });

    test('正常系: 未配置でも changeScale で大きさは更新される', () {
      viewModel().changeScale(1.5);

      expect(state().nodeScale, 1.5);
      expect(state().placedPose, isNull);
    });

    test('異常系: 範囲外の大きさは最小値・最大値に丸められる', () {
      viewModel().changeScale(0);
      expect(state().nodeScale, ArCreateViewModel.MIN_NODE_SCALE);

      viewModel().changeScale(100);
      expect(state().nodeScale, ArCreateViewModel.MAX_NODE_SCALE);
    });

    test('正常系: onError でエラーメッセージが設定される', () {
      viewModel().onError('失敗しました');

      expect(state().errorMessage, '失敗しました');
    });
  });
}

/// ファイル保存失敗を表すテスト用例外
class FileSystemExceptionStub implements Exception {
  const FileSystemExceptionStub();
}
