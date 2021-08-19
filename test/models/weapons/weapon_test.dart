import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a valid weapon', () {
    const weaponAbbreviation = 'AC';
    const weaponName = 'Autocannon';
    const weaponDamage = 1;
    const mode = weaponModes.Direct;
    const range = Range(12, 36, 72);

    const w = Weapon(
      abbreviation: weaponAbbreviation,
      name: weaponName,
      modes: [mode],
      range: range,
      damage: weaponDamage,
    );
    expect(w.abbreviation, equals(weaponAbbreviation),
        reason: 'check weapon abbreviation');
    expect(w.name, equals(weaponName), reason: 'check weapon name');
    expect(w.modes, equals([mode]), reason: 'check weapon mode');
    expect(w.damage, equals(weaponDamage), reason: 'check weapon damage');
    expect(w.hasReact, isFalse, reason: 'check hasReact');
    expect(w.traits, isEmpty, reason: 'check traits');
    expect(w.optionalTraits, isEmpty, reason: 'check optional traits');
  });

  test('test creating a weapon with react', () {
    const weaponAbbreviation = 'AC';
    const weaponName = 'Autocannon';
    const weaponDamage = 1;
    const mode = weaponModes.Direct;
    const range = Range(12, 36, 72);

    const w = Weapon(
      abbreviation: weaponAbbreviation,
      name: weaponName,
      modes: [mode],
      range: range,
      damage: weaponDamage,
      hasReact: true,
    );
    expect(w.abbreviation, equals(weaponAbbreviation),
        reason: 'check weapon abbreviation');
    expect(w.name, equals(weaponName), reason: 'check weapon name');
    expect(w.modes, equals([mode]), reason: 'check weapon mode');
    expect(w.damage, equals(weaponDamage), reason: 'check weapon damage');
    expect(w.hasReact, isTrue, reason: 'check hasReact');
    expect(w.traits, isEmpty, reason: 'check traits');
    expect(w.optionalTraits, isEmpty, reason: 'check optional traits');
  });

  test('test creating a weapon with 1 trait', () {
    const weaponAbbreviation = 'AC';
    const weaponName = 'Autocannon';
    const mode = weaponModes.Direct;
    const weaponDamage = 1;
    const trait = Trait(name: 'AE', level: 1);
    const range = Range(12, 36, 72);

    const w = Weapon(
      abbreviation: weaponAbbreviation,
      name: weaponName,
      modes: [mode],
      range: range,
      damage: weaponDamage,
      traits: [trait],
    );
    expect(w.abbreviation, equals(weaponAbbreviation),
        reason: 'check weapon abbreviation');
    expect(w.name, equals(weaponName), reason: 'check weapon name');
    expect(w.modes, equals([mode]), reason: 'check weapon mode');
    expect(w.damage, equals(weaponDamage), reason: 'check weapon damage');
    expect(w.hasReact, isFalse, reason: 'check hasReact');
    expect(w.traits, hasLength(1), reason: 'check traits size');
    expect(w.traits.first, equals(trait), reason: 'ensure trait was added');
    expect(w.optionalTraits, isEmpty, reason: 'check optional traits');
  });

  test('test creating a weapon with 1 trait and react', () {
    const weaponAbbreviation = 'AC';
    const weaponName = 'Autocannon';
    const mode = weaponModes.Direct;
    const weaponDamage = 1;
    const trait = Trait(name: 'AE', level: 1);
    const range = Range(12, 36, 72);

    const w = Weapon(
      abbreviation: weaponAbbreviation,
      name: weaponName,
      range: range,
      modes: [mode],
      damage: weaponDamage,
      hasReact: true,
      traits: [trait],
    );
    expect(w.abbreviation, equals(weaponAbbreviation),
        reason: 'check weapon abbreviation');
    expect(w.name, equals(weaponName), reason: 'check weapon name');
    expect(w.modes, equals([mode]), reason: 'check weapon mode');
    expect(w.damage, equals(weaponDamage), reason: 'check weapon damage');
    expect(w.hasReact, isTrue, reason: 'check hasReact');
    expect(w.traits, hasLength(1), reason: 'check traits size');
    expect(w.traits.first, equals(trait), reason: 'ensure trait was added');
    expect(w.optionalTraits, isEmpty, reason: 'check optional traits');
  });

  test('test getting size', () {
    const weaponAbbreviation = 'LAC';
    const weaponName = 'Autocannon';
    const mode = weaponModes.Direct;
    const weaponDamage = 1;
    const trait = Trait(name: 'AE', level: 1);
    const range = Range(12, 36, 72);

    const w = Weapon(
      abbreviation: weaponAbbreviation,
      name: weaponName,
      range: range,
      modes: [mode],
      damage: weaponDamage,
      hasReact: true,
      traits: [trait],
    );
    expect(w.size, equals('L'));
  });

  test('test getting weapon code', () {
    const weaponAbbreviation = 'LAC';
    const weaponName = 'Autocannon';
    const mode = weaponModes.Direct;
    const weaponDamage = 1;
    const trait = Trait(name: 'AE', level: 1);
    const range = Range(12, 36, 72);

    const w = Weapon(
      abbreviation: weaponAbbreviation,
      name: weaponName,
      range: range,
      modes: [mode],
      damage: weaponDamage,
      hasReact: true,
      traits: [trait],
    );
    expect(w.code, equals('AC'));
  });
}
