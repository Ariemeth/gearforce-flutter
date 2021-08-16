import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';
import 'package:test/test.dart';

final _sizes = ['L', 'M', 'H'];

void main() {
  group('test building AAMs', () {
    const code = 'AAM';
    final modes = [weaponModes.Direct, weaponModes.Indirect];
    final range = Range(min: 12, short: 36, long: 72);
    final damage = {'L': 7, 'M': 8, 'H': 9};
    final traits = [Trait(name: 'Flak'), Trait(name: 'Guided')];
    const name = 'Anti-Air Missile';

    for (var size in _sizes) {
      test('test building basic $size$code', () {
        final l = buildWeapon(code: '$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range, equals(range), reason: 'check range');
        expect(l?.traits, equals(traits), reason: 'check traits');
      });
    }
  });

  test('test building combo weapon', () {
    final l = buildWeapon(code: 'LAC/LGL');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.code, 'LAC/LGL', reason: 'check weapon code');
    expect(l?.name, isNotNull, reason: 'check that name is not null');
    expect(l?.damage, isNot(equals(-1)), reason: 'check that damage is not -1');
    expect(l?.combo, isNotNull, reason: 'combo should not be null');
    expect(l?.combo?.damage, isNot(equals(-1)),
        reason: 'combo weapons damage should not be -1');
  });

  test('test building standard BB', () {
    final modes = [weaponModes.Direct];
    final range = Range(min: 0, short: null, long: null);
    const damage = 8;
    final traits = [Trait(name: 'AE', level: 4)];
    const name = 'Bomb';

    final l = buildWeapon(code: 'BB');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.code, 'BB', reason: 'check weapon code');
    expect(l?.name, equals(name), reason: 'check name');
    expect(l?.modes, equals(modes), reason: 'check modes');
    expect(l?.damage, equals(damage), reason: 'check damage');
    expect(l?.range, equals(range), reason: 'check range');
    expect(l?.traits, equals(traits), reason: 'check traits');
  });
}
