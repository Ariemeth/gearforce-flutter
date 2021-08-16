import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

final Modification antiTank = Modification(name: 'Anti-Tank Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Anti-Tank'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'MRP', newValue: 'LATM'),
      description: '-MRP, +LATM');

final Modification vtol = Modification(name: 'VTOL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'VTOL'))
  ..addMod(UnitAttribute.movement,
      createSetMovementMod(Movement(type: 'H', rate: 10)),
      description: 'MR: H:10')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'VTOL')),
      description: '+VTOL');

final Modification rocket = Modification(name: 'Rocket Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Rockets'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'LRP', newValue: 'MRP'),
      description: '-LRP, +MRP');

final Modification nlil = Modification(name: 'N-LIL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with N-LIL'))
  ..addMod(UnitAttribute.movement,
      createSetMovementMod(Movement(type: 'H', rate: 10)),
      description: 'MR: H:10')
  ..addMod(UnitAttribute.hull, createSetIntMod(3), description: 'H/S: 3/3')
  ..addMod(UnitAttribute.structure, createSetIntMod(3))
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'VTOL')),
      description: '+VTOL');

final Modification rocket2 = Modification(name: 'Rocket Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Rockets'))
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('LRP'),
      description: '+LRP');

final Modification sniper = Modification(name: 'Sniper Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sniper'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'HRC', newValue: 'MLC'),
      description: '-HRC, +MLC');

final Modification edenWizard = Modification(name: 'Eden Wizard Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Eden Wizard'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.roles, createAddToList('RC'), description: '+RC')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECM', isAux: true)),
      description: '+ECM (Aux)')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification specialOperations = Modification(
    name: 'Special Operations Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'Special Operations'))
  ..addMod(UnitAttribute.roles, createSetStringListMod(['SO']),
      description: 'SO')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddToList(Trait(name: 'Stealth', isAux: true)),
      description: '+Stealth (Aux)');

final Modification node = Modification(name: 'Node Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Node'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp');
