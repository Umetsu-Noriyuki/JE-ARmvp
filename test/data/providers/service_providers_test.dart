import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/providers/service_providers.dart';
import 'package:ar_app/data/services/ar_model_file_service.dart';
import 'package:ar_app/data/services/ar_texture_renderer_service.dart';
import 'package:ar_app/data/services/glb_quad_builder_service.dart';

void main() {
  group('service providers', () {
    test('正常系: 各サービスのインスタンスを生成する', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(glbQuadBuilderServiceProvider),
        isA<GlbQuadBuilderService>(),
      );
      expect(
        container.read(arTextureRendererServiceProvider),
        isA<ArTextureRendererService>(),
      );
      expect(
        container.read(arModelFileServiceProvider),
        isA<ArModelFileService>(),
      );
    });
  });
}
