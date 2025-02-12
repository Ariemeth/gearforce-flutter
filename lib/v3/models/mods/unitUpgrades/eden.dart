import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification wizard = UnitModification(name: 'Wizard Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Wizard'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ecm(isAux: true)),
      description: '+ECM (Aux)')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification utopianSpecialOperations = UnitModification(
    name: 'Utopian Special Operations Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'Utopian Special Operations'))
  ..addMod(
      UnitAttribute.roles, createAddRoleToList(const Role(name: RoleType.so)),
      description: '+SO')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.airdrop()),
      description: '+Airdrop')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.stealth(isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification dominus = UnitModification(name: 'Dominus Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Dominus'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms');

final UnitModification halberd = UnitModification(name: 'Halberd Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Halberd'))
  ..addMod(
    UnitAttribute.weapons,
    createReplaceWeaponInList(
      oldValue: buildWeapon('MVB (Reach:1)')!,
      newValue: buildWeapon('HVB (Reach:2)')!,
    ),
    description: '-MVB (Reach:1), +HVB (Reach:2)',
  )
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.brawl(1), newValue: Trait.brawl(2)),
      description: '-Brawl:1, +Brawl:2');

final UnitModification doppelDominus = UnitModification(name: 'Dominus Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Dominus'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms(isAux: true)),
      description: '+Comms (Aux)')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification hydor = UnitModification(name: 'Hydor Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Hydor'))
  ..addMod(UnitAttribute.traits,
      createRemoveTraitFromList(Trait.jetpack(8, isAux: true)),
      description: '-Jetpack:8 (Aux)')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.sub()),
      description: '+Sub');

final UnitModification saker = UnitModification(name: 'Saker Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: 0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Saker'))
  ..addMod(
    UnitAttribute.weapons,
    createReplaceWeaponInList(
      oldValue: buildWeapon('HFM')!,
      newValue: buildWeapon('HGM')!,
    ),
    description: '-HFM, +HGM',
  );

final UnitModification lyddite = UnitModification(name: 'Lyddite Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV: -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Lyddite'))
  ..addMod(
    UnitAttribute.weapons,
    createReplaceWeaponInList(
      oldValue: buildWeapon('MATM (T)')!,
      newValue: buildWeapon('LAM (T)')!,
    ),
    description: '-MATM (T), +LAM (T)',
  );

final UnitModification serpentinaDominus = UnitModification(
    name: 'Dominus Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Dominus'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification team = UnitModification(name: 'Team')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Team'))
  ..addMod(UnitAttribute.hull, createSetIntMod(3), description: 'H/S: 3/3')
  ..addMod(UnitAttribute.structure, createSetIntMod(3));
