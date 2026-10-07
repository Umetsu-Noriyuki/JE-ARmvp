import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/ar_object_origin.dart';

void main() {
  group('ArObjectOrigin', () {
    // 値の name は DB・API に保存されるため、変更するとデータ互換性が失われる
    test('正常系: 保存値として使う name が定義どおりである', () {
      expect(ArObjectOrigin.values.map((value) => value.name), [
        'own',
        'received',
      ]);
    });
  });
}
