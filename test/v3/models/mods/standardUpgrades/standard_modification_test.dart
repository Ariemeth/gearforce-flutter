import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:test/test.dart';

void main() {
  final settings = Settings();
  final data = DataV3()..load(settings);
  final RuleSet rs = DefaultRuleSet(data, settings: settings);
  test('test Anti-Air Swap requirement check for weapon type', () {
    final w1 = buildWeapon('LATM', hasReact: true)!;
    final w2 = buildWeapon('MRP', hasReact: true)!;
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w1, w2])));
    var u = cg.primary.allUnits()[0];

    final mod = StandardModification.antiAirSwap(u, cg);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test Anti-Air requirement check for weapon type, weapon not found', () {
    final w1 = buildWeapon('LFC', hasReact: true)!;
    final w2 = buildWeapon('MRP', hasReact: true)!;
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w1, w2])));
    var u = cg.primary.allUnits()[0];

    final mod = StandardModification.antiAirTrait(u, cg);
    expect(mod.requirementCheck(rs, null, cg, u), equals(false));
  });

  test('test Anti-Air requirement check with 1 in group already', () {
    final w1 = buildWeapon('LATM', hasReact: true)!;
    final w2 = buildWeapon('MRP', hasReact: true)!;
    final w3 = buildWeapon('MAC', hasReact: true)!;
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w1, w2])))
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w1])))
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w3])));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.antiAirTrait(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test Anti-Air requirement check with 2 in group already', () {
    final w1 = buildWeapon('LATM')!;
    final w2 = buildWeapon('MRP')!;
    final w3 = buildWeapon('MAC', hasReact: true)!;
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w1, w2])))
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w1])))
      ..primary.addUnit(Unit(core: UnitCore.test(weapons: [w3])));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.antiAirTrait(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    cg.primary.allUnits()[1].addUnitMod(mod);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test handGrenade (LHG) requirement check with 2 in group already', () {
    var cg = CombatGroup('test1');
    final settings = Settings();

    final roster = UnitRoster(data, settings)..addCG(cg);
    final faction = roster.factionNotifier.value.factionType;
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeLHG(u, cg, roster);
    cg.primary.allUnits()[0].addUnitMod(mod);
    cg.primary.allUnits()[1].addUnitMod(mod);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test handGrenade (LHG) requirement check with 1 in group already', () {
    final settings = Settings();
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])));
    final roster = UnitRoster(data, settings)..addCG(cg);

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeLHG(u, cg, roster);
    cg.primary.allUnits()[0].addUnitMod(mod);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test handGrenade (LHG) requirement check with 1 MHG already added', () {
    var cg = CombatGroup('test1');
    final settings = Settings();

    final roster = UnitRoster(data, settings)..addCG(cg);
    final faction = roster.factionNotifier.value.factionType;
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));

    final u = cg.primary.allUnits().last;
    u.addUnitMod(StandardModification.handGrenadeMHG(u, cg));

    final u2 = cg.primary.allUnits().first;
    final mod = StandardModification.handGrenadeLHG(u2, cg, roster);

    expect(mod.requirementCheck(rs, null, cg, u2), equals(true));
  });
  test(
      'test handGrenade (LHG) requirement check with 1 MHG already added to other group',
      () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..secondary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..secondary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])));
    final settings = Settings();
    final roster = UnitRoster(data, settings)..addCG(cg);

    var u = cg.primary.allUnits().last;

    cg.secondary.allUnits()[0].addUnitMod(
        StandardModification.handGrenadeMHG(cg.secondary.allUnits()[0], cg));
    final mod = StandardModification.handGrenadeLHG(u, cg, roster);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test handGrenade (LHG) cost with 2 mods', () {
    var cg = CombatGroup('test1');
    final settings = Settings();

    final roster = UnitRoster(data, settings)..addCG(cg);
    final faction = roster.factionNotifier.value.factionType;
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));

    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));

    var u = cg.primary.allUnits().first;
    u.addUnitMod(StandardModification.handGrenadeLHG(u, cg, roster));
    var u2 = cg.primary.allUnits().last;
    u2.addUnitMod(StandardModification.handGrenadeLHG(u2, cg, roster));
    expect(cg.totalTV(),
        equals(const UnitCore.test().tv * cg.numberOfUnits() + 1));
  });

  test('test handGrenade (MHG) requirement check with 2 in group already', () {
    var cg = CombatGroup('test1');
    final settings = Settings();

    final roster = UnitRoster(data, settings)..addCG(cg);
    final faction = roster.factionNotifier.value.factionType;

    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      name: 'test3',
      traits: [Trait.hands()],
      faction: faction,
    )));

    cg.primary.allUnits()[0].addUnitMod(
        StandardModification.handGrenadeMHG(cg.primary.allUnits()[0], cg));
    cg.primary.allUnits()[1].addUnitMod(
        StandardModification.handGrenadeMHG(cg.primary.allUnits()[1], cg));
    final u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeLHG(u, cg, roster);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test handGrenade (MHG) requirement check with 1 in group already', () {
    var cg = CombatGroup('test1');
    final settings = Settings();

    final roster = UnitRoster(data, settings)..addCG(cg);
    final faction = roster.factionNotifier.value.factionType;

    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      name: 'test3',
      traits: [Trait.hands()],
      faction: faction,
    )));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(u, cg);
    cg.primary.allUnits()[0].addUnitMod(mod);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });

  test('test handGrenade (MHG) requirement check with 1 LHG already added', () {
    var cg = CombatGroup('test1');
    final settings = Settings();

    final roster = UnitRoster(data, settings)..addCG(cg);
    final faction = roster.factionNotifier.value.factionType;

    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      traits: [Trait.hands()],
      faction: faction,
    )));
    cg.primary.addUnit(Unit(
        core: UnitCore.test(
      name: 'test3',
      traits: [Trait.hands()],
      faction: faction,
    )));

    cg.primary.allUnits().first.addUnitMod(StandardModification.handGrenadeLHG(
        cg.primary.allUnits().first, cg, roster));
    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(u, cg);
    expect(mod.requirementCheck(rs, null, cg, u), equals(true));
  });
  test(
      'test handGrenade (MHG) requirement check with 1 MHG already added to other group',
      () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..secondary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..secondary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])));

    final first = cg.primary.allUnits().first;
    first.addUnitMod(StandardModification.handGrenadeMHG(first, cg));
    final last = cg.secondary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(last, cg);
    expect(mod.requirementCheck(rs, null, cg, last), equals(true));
  });
  test('test handGrenade (MHG) cost with only 1 mod', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])));

    var u = cg.primary.allUnits().last;
    final mod = StandardModification.handGrenadeMHG(u, cg);
    u.addUnitMod(mod);
    expect(cg.totalTV(), equals(const UnitCore.test().tv * 3 + 1));
  });

  test('test handGrenade (MHG) cost with 2 mods', () {
    var cg = CombatGroup('test1')
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])))
      ..primary.addUnit(Unit(core: UnitCore.test(traits: [Trait.hands()])));

    final u = cg.primary.allUnits().last;
    u.addUnitMod(StandardModification.handGrenadeMHG(u, cg));
    final u2 = cg.primary.allUnits().first;
    u2.addUnitMod(StandardModification.handGrenadeMHG(u, cg));
    expect(cg.totalTV(), equals(const UnitCore.test().tv * 3 + 2));
  });
}
