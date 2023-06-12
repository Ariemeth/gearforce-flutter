import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification psi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms');

final UnitModification darkJaguarPsi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(const Trait(name: 'SatUp', isAux: true)),
    description: '+SatUp (Aux)',
  );

final UnitModification phi = UnitModification(name: 'Phi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Phi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'ECCM')),
      description: '+ECCM');

final UnitModification darkMambaPsi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp');

final UnitModification xi = UnitModification(name: 'Xi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Xi'))
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('MGM')!),
      description: '+MGM');

final UnitModification omi = UnitModification(
    name: 'Omi Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.weapons
          .any((w) => w.abbreviation == 'HMG' && w.bonusString == '(Apex)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Omi'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HMG (Apex)', hasReact: true)!,
          newValue: buildWeapon('LLC', hasReact: true)!),
      description: '-HMG (Apex), +LLC');

final UnitModification zeta = UnitModification(
    name: 'Zeta Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.weapons
          .any((w) => w.abbreviation == 'HMG' && w.bonusString == '(Apex)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Zeta'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HMG (Apex)', hasReact: true)!,
          newValue: buildWeapon('LPA', hasReact: true)!),
      description: '-HMG (Apex), +LPA');

final UnitModification pur = UnitModification(
    name: 'Pur Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.weapons
          .any((w) => w.abbreviation == 'HMG' && w.bonusString == '(Apex)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV 0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Pur'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HMG (Apex)', hasReact: true)!,
          newValue: buildWeapon('MFL', hasReact: true)!),
      description: '-HMG (Apex), +MFL');

final UnitModification darkCoyotePsi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'ECCM')),
      description: '+ECCM');

final UnitModification iota = UnitModification(name: 'Iota Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Iota'))
  ..addMod(
      UnitAttribute.weapons, createRemoveWeaponFromList(buildWeapon('MRP')!),
      description: '-MRP')
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('LAPR')!),
      description: '+LAPR');

final UnitModification theta = UnitModification(name: 'Theta Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Theta'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MGM')!, newValue: buildWeapon('MATM')!),
      description: '-MGM, +MATM');

final UnitModification spectre = UnitModification(name: 'Spectra Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'ECM+')),
      description: '+ECM+');

final UnitModification darkHoplitePsi = UnitModification(
    name: 'Psi Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('kappa');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp');

final UnitModification blackwindTheta = UnitModification(name: 'Theta Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Theta'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRP (Link)')!,
          newValue: buildWeapon('LATM (Link)')!),
      description: '-MRP (Link), +LATM (Link)');
