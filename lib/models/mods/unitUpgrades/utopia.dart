import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification antiTank = UnitModification(name: 'Anti-Tank Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Anti-Tank'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRP')!, newValue: buildWeapon('LATM')!),
      description: '-MRP, +LATM');

final UnitModification vtol = UnitModification(name: 'VTOL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'VTOL'))
  ..addMod(UnitAttribute.movement,
      createSetMovementMod(Movement(type: 'W/H', rate: 10)),
      description: 'MR: W/H:10')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'VTOL')),
      description: '+VTOL');

final UnitModification rocket = UnitModification(name: 'Rocket Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Rockets'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LRP')!, newValue: buildWeapon('MRP')!),
      description: '-LRP, +MRP');

final UnitModification nlil = UnitModification(name: 'N-LIL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with N-LIL'))
  ..addMod(UnitAttribute.movement,
      createSetMovementMod(Movement(type: 'H', rate: 10)),
      description: 'MR: H:10')
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S: 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2))
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'VTOL')),
      description: '+VTOL');

final UnitModification rocket2 = UnitModification(name: 'Rocket Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Rockets'))
  ..addMod(UnitAttribute.mounted_weapons,
      createAddWeaponToList(buildWeapon('LRP', hasReact: true)!),
      description: '+LRP');

final UnitModification sniper = UnitModification(name: 'Sniper Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sniper'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HRC')!, newValue: buildWeapon('MLC')!),
      description: '-HRC, +MLC');

final UnitModification specialOperations = UnitModification(
    name: 'Special Operations Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'Special Operations'))
  ..addMod(UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
      description: '+SO')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'Stealth', isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification pazu = UnitModification(name: 'Pazu Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Node'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'SatUp')),
      description: '+SatUp');

final UnitModification gilgameshEngineering = UnitModification(
    name: 'Engineering Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Engineering'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('2 x MRC (B)')!,
          newValue: buildWeapon('HCW (B Link Reach:3)')!),
      description: '-2 x MRC (B), +HCW (B Link Reach:3)')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(const Trait(name: 'Repair')),
      description: '+Repair')
  ..addMod(
      UnitAttribute.traits,
      createAddTraitToList(const Trait(
          name: 'Transport', level: 4, type: 'N-KIDU or 1 Armiger')),
      description: '+Transport: 4 N-KIDU or 1 Armiger');
