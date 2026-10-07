import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// AR 表示用の 3D モデル（GLB）を端末内に保存する
///
/// ar_flutter_plugin_plus の fileSystemAppFolderGLB は、
/// Android では絶対パス、iOS では Documents ディレクトリからの相対パスを要求する。
class ArModelFileService {
  ArModelFileService({
    Future<Directory> Function()? documentsDirectory,
    bool? isIos,
  }) : _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory,
       _isIos = isIos ?? Platform.isIOS;

  static const String MODEL_DIRECTORY_NAME = 'ar_models';

  final Future<Directory> Function() _documentsDirectory;
  final bool _isIos;

  /// [glbBytes] を [fileName] で保存し、AR ノードに指定する URI を返す
  ///
  /// [fileName] にパス区切りを含む場合は [ArgumentError] を送出する。
  Future<String> writeGlb(String fileName, Uint8List glbBytes) async {
    _validateFileName(fileName);
    final documents = await _documentsDirectory();
    final directory = Directory('${documents.path}/$MODEL_DIRECTORY_NAME');
    await directory.create(recursive: true);
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(glbBytes, flush: true);
    return _isIos ? '$MODEL_DIRECTORY_NAME/$fileName' : file.path;
  }

  void _validateFileName(String fileName) {
    final isInvalid =
        fileName.isEmpty ||
        fileName.contains('/') ||
        fileName.contains(r'\') ||
        fileName == '.' ||
        fileName == '..';
    if (isInvalid) {
      throw ArgumentError.value(fileName, 'fileName', 'invalid file name');
    }
  }
}
