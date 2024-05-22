import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const String _baseRuleId = 'mod::peace river';

const String crusaderVMod = '$_baseRuleId::crusaderV';

final UnitModification chieftain = UnitModification(name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms');

final UnitModification spectre = UnitModification(name: 'Spectre Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
      description: '+ECM');

final UnitModification warriorIVChieftain =
    UnitModification(name: 'Chieftain Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
          description: '+SatUp');

final UnitModification warriorIVSpectre =
    UnitModification(name: 'Spectre Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
          description: '+ECM')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(Trait.Sensors(24, isAux: true)),
          description: '+Sensors:24 (Aux)');

final UnitModification jetpack = UnitModification(name: 'Jetpack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Jetpack'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Jetpack(6)),
      description: '+Jetpack:6');

final UnitModification warriorIVSpecialForces = UnitModification(
    name: 'Special Forces Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Special Forces'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
      description: '+SO')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.Stealth(isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification meleeSpecialist = UnitModification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LVB', hasReact: true)!,
          newValue: buildWeapon('MVB', hasReact: true)!),
      description: '-LVB, +MVB')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.Brawl(1), newValue: Trait.Brawl(2)),
      description: '-Brawl:1, +Brawl:2');

final UnitModification meleeSpecialist1 = UnitModification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MVB', hasReact: true)!),
      description: '+MVB')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.Brawl(1), newValue: Trait.Brawl(2)),
      description: '-Brawl:1, +Brawl:2');

final UnitModification shield = UnitModification(name: 'Shield Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Shield'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Shield()),
      description: '+Shield');

final UnitModification pitBullSpectre =
    UnitModification(name: 'Spectre Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
      ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
          description: '+ECM')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(Trait.Sensors(24, isAux: true)),
          description: '+Sensors:24 (Aux)');

final UnitModification greyhoundChieftain =
    UnitModification(name: 'Chieftain Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
      ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
      ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.SP(1)),
          description: '+SP:+1')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
          description: '+ECCM');

final UnitModification skirmisherChieftain = UnitModification(
    name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp(isAux: true)),
      description: '+SatUp (Aux)')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification skirmisherTag = UnitModification(name: 'Tag Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Tag'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.TD()),
      description: '+TD')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification SkirmisherSpecialForces = UnitModification(
    name: 'Special Forces Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Special Forces'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
      description: '+SO')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.Stealth(isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification shinobiMeleeSpecialist = UnitModification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.Brawl(2)),
      description: '+Brawl:2')
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LVB', hasReact: true)!,
          newValue: buildWeapon('LVB (Precise)', hasReact: true)!),
      description: '-LVB, +LVB (Precise)');

final UnitModification shinobiChieftain =
    UnitModification(name: 'Chieftain Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
          description: '+ECCM')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
          description: '+SatUp');

final UnitModification shinobiSpectre =
    UnitModification(name: 'Spectre Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
      ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECMPlus()),
          description: '+ECM+')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(Trait.Sensors(24, isAux: true)),
          description: '+Sensors:24 (Aux)');

final UnitModification spartanSpectre =
    UnitModification(name: 'Spectre Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
          description: '+ECM')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(Trait.Sensors(24, isAux: true)),
          description: '+Sensors:24 (Aux)');

final UnitModification crusaderV = UnitModification(
  name: 'Crusader V Upgrade',
  id: crusaderVMod,
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createReplaceStringMod(old: 'IV', change: 'V'))
  ..addMod(
      UnitAttribute.weapons,
      createMultiReplaceWeaponsInList(
        oldItems: [buildWeapon('MRP (Link)')!, buildWeapon('LFM')!],
        newItems: [buildWeapon('MRP')!, buildWeapon('MFM')!],
      ),
      description: '-MRP (Link), -LFM, +MRP, +MFM')
  ..addMod(UnitAttribute.traits, createRemoveTraitFromList(Trait.VulnH()),
      description: '-Vuln:Haywire');

final UnitModification cataphractSarisa =
    UnitModification(name: 'Sarisa Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sarisa'))
      ..addMod(
          UnitAttribute.weapons,
          createMultiReplaceWeaponsInList(
            oldItems: [buildWeapon('MFM')!],
            newItems: [buildWeapon('LATM (Precise)')!],
          ),
          description: '-MFM, +LATM (Precise)');

final UnitModification cataphractLord = UnitModification(name: 'Lord Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Lord'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.SP(1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
      description: '+ECCM');

final UnitModification tankHunter =
    UnitModification(name: 'Tank Hunter Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tank Hunter'))
      ..addMod(
          UnitAttribute.weapons,
          createReplaceWeaponInList(
              oldValue: buildWeapon('HRP (Link)')!,
              newValue: buildWeapon('MTG (Link)')!),
          description: '-HRP (Link), +MTG (Link)');

final UnitModification uhlanLord = UnitModification(name: 'Lord Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Lord'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.SP(1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
      description: '+ECCM');

final UnitModification hyeneIISpectre =
    UnitModification(name: 'Spectre Dog Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Spectre Dog'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECMPlus()),
          description: '+ECM+');

final UnitModification alphaDog = UnitModification(name: 'Alpha Dog Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Alpha Dog'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.SP(1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
      description: '+ECCM')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp');

final UnitModification arbalest = UnitModification(name: 'Arbalest Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arbalest'))
  ..addMod(UnitAttribute.weapons,
      createRemoveWeaponFromList(buildWeapon('MRC (T AA)', hasReact: true)!),
      description: '-MRC (T AA)')
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('2 X HAR (T)', hasReact: false)!),
      description: '+2 x HARs (T)');

final UnitModification herdLord = UnitModification(
    name: 'Herd Lord Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('xyston');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Herd Lord'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.SP(1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp');

final UnitModification missile = UnitModification(name: 'Missile Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Missile'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRP (Link)')!,
          newValue: buildWeapon('LATM (Link)')!),
      description: '-MRP (Link), +LATM (Link)');
