import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/text_vertical_align.dart';

void main() {
  group('TextVerticalAlign', () {
    // 値の name は DB・API に保存されるため、変更するとデータ互換性が失われる
    test('正常系: 保存値として使う name が定義どおりである', () {
      expect(TextVerticalAlign.values.map((value) => value.name), [
        'top',
        'center',
        'bottom',
      ]);
    });
  });
}
