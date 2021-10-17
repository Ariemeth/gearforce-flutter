import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification command = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification mobilityPack6 = UnitModification(
    name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Jetpack', level: 6, isAux: true)),
      description: '+Jetpack:6 (Aux)');

final UnitModification stealth = UnitModification(name: 'Stealth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Special Forces'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
      description: '+SO')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Stealth', isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification mobilityPack5 = UnitModification(
    name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Jetpack', level: 5, isAux: true)),
      description: '+Jetpack:5 (Aux)');

final UnitModification mrl = UnitModification(name: 'MRL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with MRL'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LLC', hasReact: true)!,
          newValue: buildWeapon('MRL', hasReact: true)!),
      description: '-LLC, +MRL');

final UnitModification flailCrew = UnitModification(name: 'FLAIL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with FLAIL Crew'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ANN')),
      description: '+ANN');

final UnitModification command2 = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECM')),
      description: '+ECM');

final UnitModification jan = UnitModification(name: 'Jan Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Jan'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms');

final UnitModification lpz = UnitModification(name: 'LPZ Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LPZ'))
  ..addMod(
      UnitAttribute.mounted_weapons, createAddWeaponToList(buildWeapon('LPZ')!),
      description: '+LPZ');

final UnitModification tankHunter =
    UnitModification(name: 'Tank Hunter Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tank Hunter'))
      ..addMod(
          UnitAttribute.mounted_weapons,
          createReplaceWeaponInList(
              oldValue: buildWeapon('MRP (Link)')!,
              newValue: buildWeapon('LATM (Link)')!),
          description: '-MRP (Link), +LATM (Link)');
