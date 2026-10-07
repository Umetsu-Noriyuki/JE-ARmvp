import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/share_status.dart';

void main() {
  group('ShareStatus', () {
    // 値の name は DB・API に保存されるため、変更するとデータ互換性が失われる
    test('正常系: 保存値として使う name が定義どおりである', () {
      expect(ShareStatus.values.map((value) => value.name), [
        'notShared',
        'sharing',
        'ended',
      ]);
    });
  });
}
