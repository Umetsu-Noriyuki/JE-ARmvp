import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ar_app/features/ar_create/ar_create_viewmodels.dart';

final arCreateViewModelProvider =
    NotifierProvider.autoDispose<ArCreateViewModel, ArCreateState>(
      ArCreateViewModel.new,
    );

/// AR（ARCore / ARKit）を利用できるプラットフォームか
final isArSupportedPlatformProvider = Provider<bool>(
  (ref) => !kIsWeb && (Platform.isAndroid || Platform.isIOS),
);
