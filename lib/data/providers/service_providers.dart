import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ar_app/data/services/ar_model_file_service.dart';
import 'package:ar_app/data/services/ar_texture_renderer_service.dart';
import 'package:ar_app/data/services/glb_quad_builder_service.dart';

final glbQuadBuilderServiceProvider = Provider<GlbQuadBuilderService>(
  (ref) => const GlbQuadBuilderService(),
);

final arTextureRendererServiceProvider = Provider<ArTextureRendererService>(
  (ref) => const ArTextureRendererService(),
);

final arModelFileServiceProvider = Provider<ArModelFileService>(
  (ref) => ArModelFileService(),
);
