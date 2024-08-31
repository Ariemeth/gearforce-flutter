import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a unit with a test unit', () {
    const testCore = UnitCore.test();
    final testUnit = Unit(core: testCore);

    expect(
      testUnit.name,
      equals(testCore.name),
      reason: 'compare name',
    );
    expect(
      testUnit.ew,
      equals(testCore.ew),
      reason: 'compare ew',
    );
  });

  test('test attribute function with no mods', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc);

    expect(
      tu.name,
      equals(uc.name),
      reason: 'Name check',
    );
    expect(
      tu.tv,
      equals(uc.tv),
      reason: 'TV check',
    );
    expect(
      tu.role,
      equals(uc.role),
      reason: 'Role check',
    );
    expect(
      tu.movement,
      equals(uc.movement),
      reason: 'Movement type check',
    );
    expect(
      tu.armor,
      equals(uc.armor),
      reason: 'Armor check',
    );
    expect(
      tu.hull,
      equals(uc.hull),
      reason: 'Hull check',
    );
    expect(
      tu.structure,
      equals(uc.structure),
      reason: 'Structure check',
    );
    expect(
      tu.actions,
      equals(uc.actions),
      reason: 'Actions check',
    );
    expect(
      tu.gunnery,
      equals(uc.gunnery),
      reason: 'Gunnery check',
    );
    expect(
      tu.piloting,
      equals(uc.piloting),
      reason: 'Piloting check',
    );
    expect(
      tu.ew,
      equals(uc.ew),
      reason: 'EW check',
    );
    expect(
      tu.reactWeapons,
      equals(uc.weapons.where((w) => w.hasReact)),
      reason: 'React Weapons check',
    );
    expect(
      tu.mountedWeapons,
      equals(uc.weapons.where((w) => !w.hasReact)),
      reason: 'Mounted Weapons check',
    );
    expect(
      tu.traits,
      equals(uc.traits),
      reason: 'Traits check',
    );
    expect(
      tu.type,
      equals(uc.type),
      reason: 'Unit type check',
    );
    expect(
      tu.height,
      equals(uc.height),
      reason: 'Height check',
    );
  });

  test('test add 1 mod', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        UnitModification(
          name: 'add postfix to name',
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      );

    expect(tu.numUnitMods(), equals(1), reason: 'mod length check');
  });

  test('test add 1 mod remove 1 mod', () {
    const uc = UnitCore.test();
    final testMod = UnitModification(
      name: 'add postfix to name',
    )..addMod(
        UnitAttribute.name, (dynamic value) => '${(value as String)} upgrade');
    final tu = Unit(core: uc)..addUnitMod(testMod);

    expect(tu.numUnitMods(), equals(1), reason: 'ensure mod added');
    tu.removeUnitMod(testMod.id);
    expect(tu.numUnitMods(), equals(0), reason: 'check mod removed');
  });

  test('test add 2 mod', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        UnitModification(
          name: 'add postfix to name',
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      )
      ..addUnitMod(
        UnitModification(
          name: 'add 1 to tv',
        )..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1),
      );

    expect(tu.numUnitMods(), equals(2), reason: 'mod length check');
  });

  test('test clearing 1 mod', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        UnitModification(
          name: 'add postfix to name',
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
        UnitModification(
          name: 'add postfix to name',
        )..addMod(UnitAttribute.name,
            (dynamic value) => '${(value as String)} upgrade'),
      );

    expect(
      tu.name,
      equals('${uc.name} upgrade'),
      reason: 'name check',
    );
  });

  test('test attribute function with 1 mod affecting 2 attributes', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        UnitModification(
          name: 'increase tv and gunnery by 1',
        )
          ..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1)
          ..addMod(
              UnitAttribute.gunnery, (dynamic value) => (value as int) - 1),
      );

    expect(tu.tv, equals(uc.tv + 1), reason: 'TV check');

    expect(
      tu.gunnery,
      equals(uc.gunnery! - 1),
      reason: 'Gunnery check',
    );
  });

  test('test add 2 mods with same change', () {
    const uc = UnitCore.test();
    final tu = Unit(core: uc)
      ..addUnitMod(
        UnitModification(
          name: 'add 1 to tv',
        )..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1),
      )
      ..addUnitMod(
        UnitModification(
          name: 'add 1 to tv',
        )..addMod(UnitAttribute.tv, (dynamic value) => (value as int) + 1),
      );

    expect(
      tu.numUnitMods(),
      equals(1),
      reason: 'duplicate mods will not be added',
    );

    expect(
      tu.tv,
      equals(uc.tv + 1),
      reason: 'tv should increase by 2',
    );
  });
}
