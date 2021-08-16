import 'package:gearforce/models/weapons/range.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a standard range', () {
    const minRange = 6;
    const shortRange = 18;
    const longRange = 36;

    const r = Range(
      min: minRange,
      short: shortRange,
      long: longRange,
    );
    expect(r.min, equals(minRange), reason: 'check min range');
    expect(r.short, equals(shortRange), reason: 'check short range');
    expect(r.long, equals(longRange), reason: 'check long range');
    expect(r.hasReach, isFalse, reason: 'check canIncrease');
    expect(r.isProximity, isFalse, reason: 'check isProximity');
  });

  test('test creating a melee range with reach', () {
    const minRange = 0;
    const shortRange = null;
    const longRange = null;
    const hasReach = true;

    const r = Range(
      min: minRange,
      short: shortRange,
      long: longRange,
      hasReach: hasReach,
    );
    expect(r.min, equals(minRange), reason: 'check min range');
    expect(r.short, equals(shortRange), reason: 'check short range');
    expect(r.long, equals(longRange), reason: 'check long range');
    expect(r.hasReach, isTrue, reason: 'check hasReach');
    expect(r.isProximity, isFalse, reason: 'check isProximity');
  });

  test('test toString of a standard range', () {
    const minRange = 6;
    const shortRange = 18;
    const longRange = 36;
    const canIncrease = false;
    const toString = '$minRange-$shortRange/$longRange';

    const r = Range(
      min: minRange,
      short: shortRange,
      long: longRange,
      hasReach: canIncrease,
    );
    expect(r.toString(), equals(toString));
  });

  test('test toString of a melee range that can be increased', () {
    const minRange = 0;
    const shortRange = null;
    const longRange = null;
    const hasReach = true;
    const canIncrease = true;
    const toString = 'Reach $minRange+';

    const r = Range(
      min: minRange,
      short: shortRange,
      long: longRange,
      hasReach: hasReach,
      increasableReach: canIncrease,
    );
    expect(r.toString(), equals(toString));
  });

  test('test toString of a melee range that can not be increased', () {
    const minRange = 0;
    const shortRange = null;
    const longRange = null;
    const hasReach = true;
    const canIncrease = false;
    const toString = 'Reach $minRange';

    const r = Range(
      min: minRange,
      short: shortRange,
      long: longRange,
      hasReach: hasReach,
      increasableReach: canIncrease,
    );
    expect(r.toString(), equals(toString));
  });

  test('test toString of a proximity range', () {
    const minRange = 3;
    const shortRange = null;
    const longRange = null;
    const canIncrease = false;
    const isProximity = true;
    const toString = 'Radius $minRange';

    const r = Range(
      min: minRange,
      short: shortRange,
      long: longRange,
      hasReach: canIncrease,
      isProximity: isProximity,
    );
    expect(r.toString(), equals(toString));
  });
}
