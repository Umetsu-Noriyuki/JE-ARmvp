import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/plane_type.dart';

void main() {
  group('PlaneType', () {
    // 値の name は DB・API に保存されるため、変更するとデータ互換性が失われる
    test('正常系: 保存値として使う name が定義どおりである', () {
      expect(PlaneType.values.map((value) => value.name), [
        'horizontal',
        'vertical',
      ]);
    });
  });
}
