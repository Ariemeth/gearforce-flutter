import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';
import 'package:test/test.dart';

void main() {
  test('test createSimpleIntMod adds 1', () {
    final mod = createSimpleIntMod(1);
    expect(mod(5), equals(5 + 1));
  });

  test('test createSimpleIntMod subtracts 1', () {
    final mod = createSimpleIntMod(-1);
    expect(mod(5), equals(5 - 1));
  });

  test('test createSimpleIntMod returns value when 0 is the change', () {
    final mod = createSimpleIntMod(0);
    expect(mod(5), equals(5));
  });

  test('test createSimpleStringMod mod adds prefix to value', () {
    const String prefix = 'test';
    final mod = createSimpleStringMod(true, prefix);
    const testName = 'test mod';
    expect(mod(testName), equals('$prefix $testName'));
  });

  test('test createSimpleStringMod mod adds postfix to value', () {
    const String postfix = 'test';
    final mod = createSimpleStringMod(false, postfix);
    const testName = 'test mod';
    expect(mod(testName), equals('$testName $postfix'));
  });

  test('test createSetIntMod mod sets a value', () {
    final mod = createSetIntMod(0);
    expect(mod(5), equals(0));
  });

  test('test createAddToList mod adds Comms to list', () {
    final trait = Trait.Comms();
    final mod = createAddTraitToList(trait);
    final List<Trait> traits = [const Trait(name: 'something')];
    expect(mod(traits), contains(trait));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(2));
  });

  test('test createAddToList mod adds Comms to list with existing +', () {
    final trait = Trait.Comms();
    final mod = createAddTraitToList(trait);
    final List<Trait> traits = [const Trait(name: 'Comms+')];
    expect(mod(traits), contains(trait));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(2),
        reason: 'new list should contain 2 items');
  });

  test('test createAddToList mod does not duplicate Comms', () {
    final trait = Trait.Comms();
    final mod = createAddTraitToList(trait);
    final List<Trait> traits = [trait];
    expect(mod(traits), contains(trait));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test('test createReplaceInList mod adds Brawl:2 to list removes Brawl:1', () {
    final traitOld = Trait.Brawl(1);
    final traitNew = Trait.Brawl(2);
    final mod =
        createReplaceTraitInList(oldValue: traitOld, newValue: traitNew);
    final List<Trait> traits = [traitOld];
    expect(mod(traits), contains(traitNew));
    expect(mod(traits), isNot(contains(traitOld)));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test(
      'test createReplaceInList mod adds Brawl:2 to list removes Brawl:1 when Brawl:1 dne',
      () {
    final traitOld = Trait.Brawl(1);
    final traitNew = Trait.Brawl(2);
    final mod =
        createReplaceTraitInList(oldValue: traitOld, newValue: traitNew);
    final List<Trait> traits = [];
    expect(mod(traits), contains(traitNew),
        reason: 'new list should contain the new trait');
    expect(mod(traits), isNot(contains(traitOld)),
        reason: 'old trait should not still be in the new list');
    expect(traits, hasLength(0),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test('test createMultiReplaceWeaponsInList mod add 1 remove 2', () {
    final weaponOld1 = buildWeapon('LATM')!;
    final weaponOld2 = buildWeapon('MATM')!;
    final weaponNew = buildWeapon('MRL (T Link)')!;
    final mod = createMultiReplaceWeaponsInList(
        oldItems: [weaponOld1, weaponOld2], newItems: [weaponNew]);
    final List<Weapon> weapons = [weaponOld1, weaponOld2];
    expect(mod(weapons), contains(weaponNew));
    expect(mod(weapons), isNot(contains(weaponOld1)));
    expect(mod(weapons), isNot(contains(weaponOld2)));
    expect(weapons, hasLength(2),
        reason: 'original list should not have changed in length');
    expect(mod(weapons), hasLength(1));
  });

  test(
      'test createMultiReplaceWeaponsInList mod add 1 remove 2 where 1 previous dne',
      () {
    final weaponOld1 = buildWeapon('LATM')!;
    final weaponOld2 = buildWeapon('MATM')!;
    final weaponNew = buildWeapon('MRL (T Link)')!;
    final mod = createMultiReplaceWeaponsInList(
        oldItems: [weaponOld1, weaponOld2], newItems: [weaponNew]);
    final List<Weapon> weapons = [weaponOld2];
    expect(mod(weapons), contains(weaponNew));
    expect(mod(weapons), isNot(contains(weaponOld1)));
    expect(mod(weapons), isNot(contains(weaponOld2)));
    expect(weapons, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(weapons), hasLength(1));
  });

  test('test createMultiReplaceWeaponsInList mod add 2 remove 1', () {
    final weaponNew1 = buildWeapon('LATM')!;
    final weaponNew2 = buildWeapon('MATM')!;
    final weaponOld1 = buildWeapon('MRL (T Link)')!;
    final weaponOld2 = buildWeapon('MRL (T Link)')!;
    final mod = createMultiReplaceWeaponsInList(
        oldItems: [weaponOld1], newItems: [weaponNew1, weaponNew2]);
    final List<Weapon> weapons = [weaponOld2];
    expect(mod(weapons), contains(weaponNew1));
    expect(mod(weapons), contains(weaponNew2));
    expect(mod(weapons), isNot(contains(weaponOld1)));
    expect(weapons, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(weapons), hasLength(2));
  });

  test('test createMultiReplaceInList mod add 1 remove 1', () {
    final weaponNew = buildWeapon('LATM')!;
    final weaponOld = buildWeapon('MRL (T Link)')!;
    final mod = createMultiReplaceWeaponsInList(
        oldItems: [weaponOld], newItems: [weaponNew]);
    final List<Weapon> weapons = [weaponOld];
    expect(mod(weapons), contains(weaponNew));
    expect(mod(weapons), isNot(contains(weaponOld)));
    expect(weapons, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(weapons), hasLength(1));
  });

  test(
      'test createMultiReplaceInList mod add 1 remove 2 with the add already existing',
      () {
    final weaponOld1 = buildWeapon('LATM')!;
    final weaponOld2 = buildWeapon('MATM')!;
    final weaponNew = buildWeapon('MRL (T Link)')!;
    final mod = createMultiReplaceWeaponsInList(
        oldItems: [weaponOld1, weaponOld2], newItems: [weaponNew]);
    final List<Weapon> weapons = [weaponOld1, weaponOld2, weaponNew];
    expect(mod(weapons), contains(weaponNew));
    expect(mod(weapons), isNot(contains(weaponOld1)));
    expect(mod(weapons), isNot(contains(weaponOld2)));
    expect(weapons, hasLength(3),
        reason: 'original list should not have changed in length');
    expect(mod(weapons), hasLength(1));
  });
}
