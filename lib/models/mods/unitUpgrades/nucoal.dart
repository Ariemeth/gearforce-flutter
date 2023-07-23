import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification cv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification cuirassierCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification fragCannon = UnitModification(
    name: 'Frag Cannon Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.reactWeapons.any((w) => w.abbreviation == 'MRF');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Frag Cannon'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRF', hasReact: true)!,
          newValue: buildWeapon('MFC', hasReact: true)!),
      description: '-MRF, +MFC');

final UnitModification rapidFireBazooka = UnitModification(
    name: 'Rapid Fire Bazooka Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.reactWeapons.any((w) => w.abbreviation == 'MRF');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Rapid Fire Bazooka'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRF', hasReact: true)!,
          newValue: buildWeapon('LBZ (AP:1 Burst:1)', hasReact: true)!),
      description: '-MRF, +LBZ(AP:1, Burst:1)');

final UnitModification espionCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp');

final UnitModification mfmBoa = UnitModification(
    name: 'MFM Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.weapons.any((w) => w.abbreviation == 'LGM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'MFM'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LGM')!, newValue: buildWeapon('MFM')!),
      description: '-LGM, +MFM');

final UnitModification cv2 = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification voltigeurABM = UnitModification(
    name: 'ABM Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.weapons.any((w) => w.abbreviation == 'MATM' && w.numberOf == 2);
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV: -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'ABM'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('2 X MATM')!,
          newValue: buildWeapon('2 X MABM')!),
      description: '-2 x MATMs, +2 x MABMs');

final UnitModification voltigeurAM = UnitModification(
    name: 'AM Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.weapons.any((w) => w.abbreviation == 'MATM' && w.numberOf == 2);
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: 0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'AM'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('2 X MATM')!,
          newValue: buildWeapon('2 X MAM')!),
      description: '-2 x MATMs, +2 x MAMs');

final UnitModification voltigeurCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'ECCM')),
      description: '+ECCM');

final UnitModification sampsonCv = UnitModification(
    name: 'CV Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('medical');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification squad = UnitModification(name: 'Squad')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(3), description: 'H/S: 3/3')
  ..addMod(UnitAttribute.structure, createSetIntMod(3));

final UnitModification koreshi = UnitModification(name: 'Koreshi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Koreshi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Vet')),
      description: '+Vet');
