import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification sawBladeSwap = UnitModification(
    name: 'Saw Blade Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      if (u.hasMod(maulerFistSwap.id)) {
        return false;
      }

      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: sawBladeSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Saw Blade Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MCW (Brawl:1 Demo:4)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MCW (Brawl:1, Demo:4)');

final UnitModification vibroswordSwap = UnitModification(
    name: 'Vibrosword Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: vibroswordSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)) &&
              !w.traits.any((t) => Trait.brawl(1).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Vibrosword Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MVB (Reach:1)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MVB (Reach:1)');

final UnitModification destroyer = UnitModification(
    name: 'Destroyer Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasHAC = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: destroyer.id)
          .any((w) => w.abbreviation == 'HAC');

      return hasHAC;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Destroyer Upgrade'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HAC', hasReact: true)!,
          newValue: buildWeapon('MBZ', hasReact: true)!),
      description: '-HAC, +MBZ');

final UnitModification demolisher = UnitModification(
    name: 'Demolisher Hand Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasHAC = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: demolisher.id)
          .any((w) => w.abbreviation == 'HAC');

      return hasHAC;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Demolisher Hand Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HAC', hasReact: true)!,
          newValue: buildWeapon('MCW (Link Demo:4)', hasReact: true)!),
      description: '-HAC, +MCW (Link, Demo:4)')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.brawl(1), newValue: Trait.brawl(2)),
      description: '-Brawl:1, +Brawl:2');

final UnitModification heavyChainswordSwap = UnitModification(
    name: 'Heavy Chainsword Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasLVB = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: heavyChainswordSwap.id)
          .any((w) => w.abbreviation == 'LVB');

      return hasLVB;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Heavy Chainsword Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LVB', hasReact: true)!,
          newValue: buildWeapon('MCW (Brawl:1 Reach:1)', hasReact: true)!),
      description: '-LVB, +MCW (Brawl:1, Reach:1)');

final UnitModification maulerFistSwap = UnitModification(
    name: 'Mauler Fist Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      if (u.hasMod(sawBladeSwap.id)) {
        return false;
      }

      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: maulerFistSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mauler Fist Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MCW (Brawl:1 Demo:4)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MCW (Brawl:1, Demo:4)');

final UnitModification chainswordSwap = UnitModification(
    name: 'Chainsword Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: chainswordSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Chainsword Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Brawl:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('LCW (Brawl:1 Reach:1)', hasReact: true)!),
      description: '-MCW (Brawl:1, Demo:4), +LCW (Brawl:1, Reach:1)');

final UnitModification stonemasonChainswordSwap = UnitModification(
    name: 'Chainsword Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: stonemasonChainswordSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)) &&
              !w.traits.any((t) => Trait.brawl(1).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Chainsword Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('LCW (Brawl:1 Reach:1)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +LCW (Brawl:1, Reach:1)');

final UnitModification strike = UnitModification(
    name: 'Strike Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasHAC = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: strike.id)
          .any((w) => w.abbreviation == 'HAC');

      return hasHAC;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Strike Upgrade'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HAC', hasReact: true)!,
          newValue: buildWeapon('MBZ', hasReact: true)!),
      description: '-HAC, +MBZ');

final UnitModification clawSwap = UnitModification(
    name: 'Claw Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: clawSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Claw Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Brawl:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MVB', hasReact: true)!),
      description: '-MCW (Brawl:1, Demo:4), +MVB)');

final UnitModification valenceClawSwap = UnitModification(
    name: 'Claw Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: valenceClawSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)) &&
              !w.traits.any((t) => Trait.brawl(1).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Claw Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1 Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MVB', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MVB)');

final UnitModification hammerSwap = UnitModification(
    name: 'Hammer Swap',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMCW = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: hammerSwap.id)
          .any((w) =>
              w.abbreviation == 'MCW' &&
              w.traits.any((t) => Trait.demo(4).isSameType(t)));

      return hasMCW;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Hammer Swap'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Brawl:1 Reach:1)', hasReact: true)!,
          newValue: buildWeapon('MCW (Reach:1 Demo:4)', hasReact: true)!),
      description: '-MCW (Brawl:1, Reach:1), +MCW (Reach:1, Demo:4)');

final UnitModification paratrooper = UnitModification(
  name: 'Paratrooper Upgrade',
  requirementCheck: (rs, roster, cg, unit) {
    return !unit.hasMod('Mountaineering Upgrade') &&
        !unit.hasMod('Frogmen Upgrade');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Paratrooper'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(
      UnitAttribute.roles, createAddRoleToList(const Role(name: RoleType.so)),
      description: '+SO')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.airdrop()),
      description: '+Airdrop');

final UnitModification mountaineering = UnitModification(
  name: 'Mountaineering Upgrade',
  requirementCheck: (rs, roster, cg, unit) {
    return !unit.hasMod('Paratrooper Upgrade') &&
        !unit.hasMod('Frogmen Upgrade');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Mountaineering'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(
      UnitAttribute.roles, createAddRoleToList(const Role(name: RoleType.so)),
      description: '+SO')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.climber()),
      description: '+Climber');

final UnitModification frogmen = UnitModification(
  name: 'Frogmen Upgrade',
  requirementCheck: (rs, roster, cg, unit) {
    return !unit.hasMod('Mountaineering Upgrade') &&
        !unit.hasMod('Paratrooper Upgrade');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Frogmen'))
  ..addMod(
      UnitAttribute.roles, createAddRoleToList(const Role(name: RoleType.so)),
      description: '+SO')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.sub()),
      description: '+Sub');

final UnitModification latm = UnitModification(name: 'LATM Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LATM'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LAAM (Link)')!,
          newValue: buildWeapon('LATM (Link)')!),
      description: '-LAAM (Link), +LATM (Link)');

final UnitModification ecm = UnitModification(name: 'ECM Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with ECM'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW:5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ecm()),
      description: '+ECM');

final UnitModification azat = UnitModification(name: 'Azat Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Azat'))
  ..addMod(UnitAttribute.armor, createSetIntMod(4), description: 'Arm:4')
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU:3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MIL (Burst:2)', hasReact: true)!),
      description: '+MIL (Burst:2)')
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MICW (AP:1)', hasReact: true)!),
      description: '+MICW (AP:1)')
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('LAVM', hasReact: false)!),
      description: '+LAVM')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.vet()),
      description: '+Vet');

final UnitModification hmg = UnitModification(name: 'HMG Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('HMG (Auto)', hasReact: true)!),
      description: '+HMG (Auto)');

final UnitModification trooperAutomationSquad = UnitModification(
    name: 'Squad Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createReplaceStringMod(old: 'Team', change: 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(5), description: 'H/S 5/1')
  ..addMod(UnitAttribute.structure, createSetIntMod(1));

final UnitModification trooperAutomationNode = UnitModification(
    name: 'Node Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Node'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createRemoveTraitFromList(Trait.conscript()),
      description: '-Conscript');

final UnitModification achillusSquad = UnitModification(name: 'Squad Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createReplaceStringMod(old: 'Team', change: 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2));

final UnitModification arminiusParatrooper = UnitModification(
    name: 'Paratrooper Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Paratrooper'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(
      UnitAttribute.roles, createAddRoleToList(const Role(name: RoleType.so)),
      description: '+SO')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.airdrop()),
      description: '+Airdrop');

final UnitModification arminiusSquad = UnitModification(name: 'Squad Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createReplaceStringMod(old: 'Team', change: 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2));

final UnitModification sandSpiderComms = UnitModification(name: 'Comms Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Comms'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createRemoveTraitFromList(Trait.satUp()),
      description: '+SatUp');

final UnitModification sandSpiderAmphib =
    UnitModification(name: 'Amphib Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Amphib'))
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.amphib()),
          description: '+Amphib');

final UnitModification sandSpiderStealth = UnitModification(
    name: 'Stealth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Stealth'))
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.stealth(isAux: true)),
      description: '+Amphib (Aux)');
