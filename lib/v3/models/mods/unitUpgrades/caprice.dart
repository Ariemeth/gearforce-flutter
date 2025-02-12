import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification command = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.sp(1)),
      description: '+SP:+1');

final UnitModification mortar = UnitModification(name: 'Mortar Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Mortar'))
  ..addMod(
      UnitAttribute.weapons, createAddWeaponToList(buildWeapon('LGM (T)')!),
      description: '+LGM (T)');

final UnitModification command2 = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms');

final UnitModification jammer = UnitModification(name: 'Jammer Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Jammer'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ecm()),
      description: '+ECM')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm()),
      description: '+ECCM')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.sensors(24), newValue: Trait.sensors(36)),
      description: '+Sensors:36');

final UnitModification command3 = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms');
