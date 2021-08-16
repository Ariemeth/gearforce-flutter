import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

final Modification command = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification mobilityPack6 = Modification(name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddToList(Trait(name: 'Jetpack', level: 6, isAux: true)),
      description: '+Jetpack:6 (Aux)');

final Modification stealth = Modification(name: 'Stealth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Special Forces'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.roles, createAddToList('SO'), description: '+SO')
  ..addMod(UnitAttribute.traits,
      createAddToList(Trait(name: 'Stealth', isAux: true)),
      description: '+Stealth (Aux)');

final Modification mobilityPack5 = Modification(name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Airdrop')),
      description: '+Airdrop')
  ..addMod(UnitAttribute.traits,
      createAddToList(Trait(name: 'Jetpack', level: 5, isAux: true)),
      description: '+Jetpack:5 (Aux)');

final Modification mrl = Modification(name: 'MRL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with MRL'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'LLC', newValue: 'MRL'),
      description: '-LLC, +MRL');

final Modification flailCrew = Modification(name: 'FLAIL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with FLAIL Crew'))
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ANN')),
      description: '+ANN');

final Modification command2 = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ECM')),
      description: '+ECM');

final Modification jan = Modification(name: 'Jan Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Jan'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms');

final Modification lpz = Modification(name: 'LPZ Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LPZ'))
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('LPZ'),
      description: '+LPZ');

final Modification tankHunter = Modification(name: 'Tank Hunter Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tank Hunter'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'MRP (Link)', newValue: 'LATM (Link)'),
      description: '-MRP (Link), +LATM (Link)');
