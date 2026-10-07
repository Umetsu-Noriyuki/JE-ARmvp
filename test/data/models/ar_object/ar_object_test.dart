import 'package:flutter_test/flutter_test.dart';

import 'package:ar_app/core/enums/ar_object_type.dart';
import 'package:ar_app/core/enums/share_status.dart';

import '../../../helper/ar_object_fixtures.dart';

void main() {
  final now = DateTime.utc(2026, 10, 1, 9);

  group('ArObject.type', () {
    test('正常系: content の種類を返す', () {
      expect(buildArObject().type, ArObjectType.text);
      expect(
        buildArObject(content: SAMPLE_SHAPE_CONTENT).type,
        ArObjectType.shape,
      );
    });
  });

  group('ArObject.hasLocation', () {
    test('正常系: 緯度・経度が揃っている場合は true', () {
      expect(buildArObject().hasLocation, isTrue);
    });

    test('正常系: 緯度・経度のどちらかが null の場合は false', () {
      final object = buildArObject();

      expect(object.copyWith(latitude: () => null).hasLocation, isFalse);
      expect(object.copyWith(longitude: () => null).hasLocation, isFalse);
    });
  });

  group('ArObject.effectiveShareStatus', () {
    test('正常系: 未共有の場合は未共有のまま', () {
      expect(buildArObject().effectiveShareStatus(now), ShareStatus.notShared);
    });

    test('正常系: 共有中で期限内の場合は共有中', () {
      final object = buildArObject(
        shareStatus: ShareStatus.sharing,
        expiresAt: now.add(const Duration(hours: 1)),
      );

      expect(object.effectiveShareStatus(now), ShareStatus.sharing);
    });

    test('正常系: 共有中で期限ちょうどの時刻は共有中', () {
      final object = buildArObject(
        shareStatus: ShareStatus.sharing,
        expiresAt: now,
      );

      expect(object.effectiveShareStatus(now), ShareStatus.sharing);
    });

    test('正常系: 共有中で期限を過ぎた場合は共有終了', () {
      final object = buildArObject(
        shareStatus: ShareStatus.sharing,
        expiresAt: now.subtract(const Duration(milliseconds: 1)),
      );

      expect(object.effectiveShareStatus(now), ShareStatus.ended);
    });

    test('正常系: 共有中で期限が未設定の場合は共有中のまま', () {
      final object = buildArObject(shareStatus: ShareStatus.sharing);

      expect(object.effectiveShareStatus(now), ShareStatus.sharing);
    });

    test('正常系: 共有終了の場合は期限に関わらず共有終了', () {
      final object = buildArObject(
        shareStatus: ShareStatus.ended,
        expiresAt: now.add(const Duration(hours: 1)),
      );

      expect(object.effectiveShareStatus(now), ShareStatus.ended);
    });
  });

  group('ArObject.copyWith', () {
    test('正常系: 引数なしの場合は等価なオブジェクトを返す', () {
      final object = buildArObject();
      final copied = object.copyWith();

      expect(copied, object);
      expect(copied.hashCode, object.hashCode);
    });

    test('正常系: 指定した項目のみ変更される', () {
      final object = buildArObject();
      final copied = object.copyWith(
        shareStatus: ShareStatus.sharing,
        shareCode: () => 'ABC123',
        expiresAt: () => now,
      );

      expect(copied.shareStatus, ShareStatus.sharing);
      expect(copied.shareCode, 'ABC123');
      expect(copied.expiresAt, now);
      expect(copied.objectId, object.objectId);
      expect(copied, isNot(object));
    });

    test('正常系: nullable 項目に () => null を渡すと null になる', () {
      final object = buildArObject(
        shareStatus: ShareStatus.sharing,
        expiresAt: now,
      ).copyWith(shareCode: () => 'ABC123', placeName: () => '福島駅');

      final cleared = object.copyWith(
        shareCode: () => null,
        expiresAt: () => null,
        placeName: () => null,
      );

      expect(cleared.shareCode, isNull);
      expect(cleared.expiresAt, isNull);
      expect(cleared.placeName, isNull);
    });
  });
}
