import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/data/services/ar_model_file_service.dart';

void main() {
  late Directory documents;
  final glbBytes = Uint8List.fromList([1, 2, 3, 4]);

  setUp(() {
    documents = Directory.systemTemp.createTempSync('ar_model_file_');
    addTearDown(() => documents.deleteSync(recursive: true));
  });

  ArModelFileService createService({required bool isIos}) {
    return ArModelFileService(
      documentsDirectory: () async => documents,
      isIos: isIos,
    );
  }

  File savedFile(String fileName) => File(
    '${documents.path}/${ArModelFileService.MODEL_DIRECTORY_NAME}/'
    '$fileName',
  );

  group('ArModelFileService.writeGlb', () {
    test('正常系: Android ではファイルを保存し絶対パスを返す', () async {
      final uri = await createService(
        isIos: false,
      ).writeGlb('model.glb', glbBytes);

      expect(uri, savedFile('model.glb').path);
      expect(savedFile('model.glb').readAsBytesSync(), glbBytes);
    });

    test('正常系: iOS では Documents からの相対パスを返す', () async {
      final uri = await createService(
        isIos: true,
      ).writeGlb('model.glb', glbBytes);

      expect(uri, 'ar_models/model.glb');
      expect(savedFile('model.glb').existsSync(), isTrue);
    });

    test('正常系: 同名ファイルは上書きされる', () async {
      final service = createService(isIos: false);
      await service.writeGlb('model.glb', glbBytes);

      await service.writeGlb('model.glb', Uint8List.fromList([9]));

      expect(savedFile('model.glb').readAsBytesSync(), [9]);
    });

    for (final fileName in ['', '.', '..', 'a/b.glb', r'a\b.glb']) {
      test('異常系: ファイル名「$fileName」は ArgumentError', () {
        expect(
          () => createService(isIos: false).writeGlb(fileName, glbBytes),
          throwsArgumentError,
        );
      });
    }
  });
}
