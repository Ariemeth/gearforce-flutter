import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification command = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
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

final UnitModification mobilityPack6 = UnitModification(
    name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'Jetpack', level: 6, isAux: true)),
      description: '+Jetpack:6 (Aux)');

final UnitModification stealth = UnitModification(name: 'Stealth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Stealth'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
      description: '+SO')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'Stealth', isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification mobilityPack5 = UnitModification(
    name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'Jetpack', level: 5, isAux: true)),
      description: '+Jetpack:5 (Aux)');

final UnitModification mrl = UnitModification(name: 'MRL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with MRL'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LLC', hasReact: true)!,
          newValue: buildWeapon('MRL', hasReact: true)!),
      description: '-LLC, +MRL');

final UnitModification grelCrew = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI 3+')
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+');

final UnitModification grelCrew2 = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI 3+')
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'React+')),
      description: '+React+');

final UnitModification grelCrew3 = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI 3+')
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'React+')),
      description: '+React+');

final UnitModification grelCrew4 = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(4), description: 'PI 4+')
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+');

final UnitModification hpc64Command = UnitModification(
    name: 'Command Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('medic');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(const Trait(name: 'ECM')),
      description: '+ECM');

final UnitModification jan = UnitModification(name: 'Jan Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Jan'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms');

final UnitModification squad = UnitModification(name: 'Squad')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2));

final UnitModification team = UnitModification(name: 'Team')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Team'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2));

final UnitModification lpz = UnitModification(name: 'LPZ Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LPZ'))
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('LPZ')!),
      description: '+LPZ');

final UnitModification tankHunter =
    UnitModification(name: 'Tank Hunter Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tank Hunter'))
      ..addMod(
          UnitAttribute.weapons,
          createReplaceWeaponInList(
              oldValue: buildWeapon('MRP (Link)')!,
              newValue: buildWeapon('LATM (Link)')!),
          description: '-MRP (Link), +LATM (Link)');
