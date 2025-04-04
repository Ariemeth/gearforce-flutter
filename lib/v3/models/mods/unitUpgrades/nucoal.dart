import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification cv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification cuirassierCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification fragCannon = UnitModification(
    name: 'Frag Cannon Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMRF = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: fragCannon.id)
          .any((w) => w.abbreviation == 'MRF');

      return hasMRF;
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
      final hasMRF = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: rapidFireBazooka.id)
          .any((w) => w.abbreviation == 'MRF');

      return hasMRF;
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
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp');

final UnitModification mfmBoa = UnitModification(
    name: 'MFM Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasLGM = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: mfmBoa.id)
          .any((w) => w.abbreviation == 'LGM');

      return hasLGM;
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
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification voltigeurABM = UnitModification(
    name: 'ABM Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasMATM = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: voltigeurABM.id)
          .any((w) => w.abbreviation == 'MATM');

      return hasMATM;
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
      final hasMATM = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: voltigeurAM.id)
          .any((w) => w.abbreviation == 'MATM');

      return hasMATM;
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
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm()),
      description: '+ECCM');

final UnitModification sampsonCv = UnitModification(
    name: 'CV Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('medical');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification squad = UnitModification(name: 'Squad')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createReplaceStringMod(old: 'Team', change: 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(3), description: 'H/S: 3/3')
  ..addMod(UnitAttribute.structure, createSetIntMod(3));

final UnitModification koreshi = UnitModification(name: 'Koreshi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Koreshi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.vet()),
      description: '+Vet');
