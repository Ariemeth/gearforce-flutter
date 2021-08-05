import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('test Anti-Air requirement check for weapon type', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(reactWeapons: ['LATM,MRP']));
    var u = cg.primary.allUnits()[0];

    final mod = StandardModification.antiAir(u, cg);
    expect(mod.requirementCheck(), equals(true));
  });

  test('test Anti-Air requirement check for weapon type, weapon not found', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(reactWeapons: ['LFC,MRP']));
    var u = cg.primary.allUnits()[0];

    final mod = StandardModification.antiAir(u, cg);
    expect(mod.requirementCheck(), equals(false));
  });

  test('test Anti-Air requirement check with 1 in group already', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(reactWeapons: ['LATM,MRP']))
      ..primary.addUnit(UnitCore.test(reactWeapons: ['LATM']))
      ..primary.addUnit(UnitCore.test(reactWeapons: ['MAC']));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.antiAir(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    expect(mod.requirementCheck(), equals(true));
  });

  test('test Anti-Air requirement check with 2 in group already', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(reactWeapons: ['LATM,MRP']))
      ..primary.addUnit(UnitCore.test(reactWeapons: ['LATM']))
      ..primary.addUnit(UnitCore.test(reactWeapons: ['MAC']));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.antiAir(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    cg.primary.allUnits()[1].addUnitMod(mod);
    expect(mod.requirementCheck(), equals(false));
  });

  test('test handGrenade (LHG) requirement check with 2 in group already', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeLHG(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    cg.primary.allUnits()[1].addUnitMod(mod);
    expect(mod.requirementCheck(), equals(false));
  });

  test('test handGrenade (LHG) requirement check with 1 in group already', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeLHG(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    expect(mod.requirementCheck(), equals(true));
  });

  test('test handGrenade (LHG) requirement check with 1 MHG already added', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    final u = cg.primary.allUnits().last;
    u.addUnitMod(StandardModification.handGrenadeMHG(u, cg));

    final u2 = cg.primary.allUnits().first;
    final mod = StandardModification.handGrenadeLHG(u2, cg);

    expect(mod.requirementCheck(), equals(false));
  });
  test(
      'test handGrenade (LHG) requirement check with 1 MHG already added to other group',
      () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..secondary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..secondary.addUnit(UnitCore.test(traits: const ['Hands']));

    var u = cg.primary.allUnits().last;

    cg.secondary.allUnits()[0].addUnitMod(
        StandardModification.handGrenadeMHG(cg.secondary.allUnits()[0], cg));
    final mod = StandardModification.handGrenadeLHG(u, cg);
    expect(mod.requirementCheck(), equals(false));
  });

  test('test handGrenade (LHG) cost with 2 mods', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    var u = cg.primary.allUnits().first;
    u.addUnitMod(StandardModification.handGrenadeLHG(u, cg));
    var u2 = cg.primary.allUnits().last;
    u2.addUnitMod(StandardModification.handGrenadeLHG(u2, cg));
    expect(cg.totalTV(), equals(UnitCore.test().tv * 3 + 1));
  });

  test('test handGrenade (MHG) requirement check with 2 in group already', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    cg.primary.allUnits()[0].addUnitMod(
        StandardModification.handGrenadeMHG(cg.primary.allUnits()[0], cg));
    cg.primary.allUnits()[1].addUnitMod(
        StandardModification.handGrenadeMHG(cg.primary.allUnits()[1], cg));
    final u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeLHG(u, cg);
    expect(mod.requirementCheck(), equals(false));
  });

  test('test handGrenade (MHG) requirement check with 1 in group already', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    expect(mod.requirementCheck(), equals(true));
  });

  test('test handGrenade (MHG) requirement check with 1 LHG already added', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    cg.primary.allUnits().first.addUnitMod(
        StandardModification.handGrenadeLHG(cg.primary.allUnits().first, cg));
    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(u, cg);
    expect(mod.requirementCheck(), equals(false));
  });
  test(
      'test handGrenade (MHG) requirement check with 1 MHG already added to other group',
      () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..secondary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..secondary.addUnit(UnitCore.test(traits: const ['Hands']));

    final first = cg.primary.allUnits().first;
    first.addUnitMod(StandardModification.handGrenadeMHG(first, cg));
    final last = cg.secondary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(last, cg);
    expect(mod.requirementCheck(), equals(true));
  });
  test('test handGrenade (MHG) cost with only 1 mod', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(u, cg);
    u.addUnitMod(mod);
    expect(cg.totalTV(), equals(UnitCore.test().tv * 3 + 1));
  });

  test('test handGrenade (MHG) cost with 2 mods', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']))
      ..primary.addUnit(UnitCore.test(traits: const ['Hands']));

    final u = cg.primary.allUnits().last;
    u.addUnitMod(StandardModification.handGrenadeMHG(u, cg));
    final u2 = cg.primary.allUnits().first;
    u2.addUnitMod(StandardModification.handGrenadeMHG(u, cg));
    expect(cg.totalTV(), equals(UnitCore.test().tv * 3 + 2));
  });
}
