import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a unit with a test unit', () {
    const testCore = UnitCore.test();
    final testUnit = Unit(core: testCore);

    expect(
      testUnit.attribute(UnitAttribute.name),
      equals(testCore.name),
      reason: 'compare name',
    );
    expect(
      testUnit.attribute(UnitAttribute.ew),
      equals(testCore.ew),
      reason: 'compare ew',
    );
  });

  test('test attribute function with no mods', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc);

    expect(
      tu.attribute(UnitAttribute.name),
      equals(uc.name),
      reason: 'Name check',
    );
    expect(
      tu.attribute(UnitAttribute.tv),
      equals(uc.tv),
      reason: 'TV check',
    );
    expect(
      tu.attribute(UnitAttribute.roles),
      equals(uc.role),
      reason: 'Role check',
    );
    expect(
      tu.attribute(UnitAttribute.movement),
      equals(uc.movement),
      reason: 'Movement type check',
    );
    expect(
      tu.attribute(UnitAttribute.armor),
      equals(uc.armor),
      reason: 'Armor check',
    );
    expect(
      tu.attribute(UnitAttribute.hull),
      equals(uc.hull),
      reason: 'Hull check',
    );
    expect(
      tu.attribute(UnitAttribute.structure),
      equals(uc.structure),
      reason: 'Structure check',
    );
    expect(
      tu.attribute(UnitAttribute.actions),
      equals(uc.actions),
      reason: 'Actions check',
    );
    expect(
      tu.attribute(UnitAttribute.gunnery),
      equals(uc.gunnery),
      reason: 'Gunnery check',
    );
    expect(
      tu.attribute(UnitAttribute.piloting),
      equals(uc.piloting),
      reason: 'Piloting check',
    );
    expect(
      tu.attribute(UnitAttribute.ew),
      equals(uc.ew),
      reason: 'EW check',
    );
    expect(
      tu.attribute(UnitAttribute.react_weapons),
      equals(uc.reactWeapons),
      reason: 'React Weapons check',
    );
    expect(
      tu.attribute(UnitAttribute.mounted_weapons),
      equals(uc.mountedWeapons),
      reason: 'Mounted Weapons check',
    );
    expect(
      tu.attribute(UnitAttribute.traits),
      equals(uc.traits),
      reason: 'Traits check',
    );
    expect(
      tu.attribute(UnitAttribute.type),
      equals(uc.type),
      reason: 'Unit type check',
    );
    expect(
      tu.attribute(UnitAttribute.height),
      equals(uc.height),
      reason: 'Height check',
    );
  });

  test('test add 1 mod', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        Modification(
          name: 'add postfix to name',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      );

    expect(tu.numUnitMods(), equals(1), reason: 'mod length check');
  });

  test('test add 1 mod remove 1 mod', () {
    const uc = UnitCore.test();
    final testMod = Modification(
      name: 'add postfix to name',
      requirementCheck: (UnitCore uc) => false,
    )..addMod(
        UnitAttribute.name, (dynamic value) => '${(value as String)} upgrade');
    final tu = Unit(core: uc)..addUnitMod(testMod);

    expect(tu.numUnitMods(), equals(1), reason: 'ensure mod added');
    tu.removeUnitMod(testMod.name);
    expect(tu.numUnitMods(), equals(0), reason: 'check mod removed');
  });

  test('test add 2 mod', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        Modification(
          name: 'add postfix to name',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      )
      ..addUnitMod(
        Modification(
          name: 'add 1 to tv',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1),
      );

    expect(tu.numUnitMods(), equals(2), reason: 'mod length check');
  });

  test('test clearing 1 mod', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        Modification(
          name: 'add postfix to name',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      );
    expect(tu.numUnitMods(), equals(1), reason: 'ensure 1 mod present');
    tu.clearUnitMods();
    expect(tu.numUnitMods(), equals(0), reason: 'ensure 0 mods found');
  });

  test('test attribute function with 1 mod affecting 1 attributes', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        Modification(
          name: 'add postfix to name',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      );

    expect(
      tu.attribute(UnitAttribute.name),
      equals('${uc.name} upgrade'),
      reason: 'name check',
    );
  });

  test('test attribute function with 1 mod affecting 2 attributes', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        Modification(
          name: 'increase tv and gunnery by 1',
          requirementCheck: (UnitCore uc) => false,
        )
          ..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1)
          ..addMod(
              UnitAttribute.gunnery, (dynamic value) => (value as int) - 1),
      );

    expect(tu.attribute(UnitAttribute.tv), equals(uc.tv + 1),
        reason: 'TV check');

    expect(
      tu.attribute(UnitAttribute.gunnery),
      equals(uc.gunnery! - 1),
      reason: 'Gunnery check',
    );
  });

  test('test add 2 mods with same change', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        Modification(
          name: 'add 1 to tv',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1),
      )
      ..addUnitMod(
        Modification(
          name: 'add 1 to tv',
          requirementCheck: (UnitCore uc) => false,
        )..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1),
      );

    expect(
      tu.attribute(UnitAttribute.tv),
      equals(uc.tv + 2),
      reason: 'tv should increase by 2',
    );
  });
}
