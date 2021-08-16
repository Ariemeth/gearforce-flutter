import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

final Modification headHunter = Modification(name: 'Headhunter Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Headhunter'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
    UnitAttribute.traits,
    createAddToList(Trait(name: 'Comms')),
    description: '+Comms',
  );

final Modification meleeSpecialist1 = Modification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(UnitAttribute.react_weapons, createAddToList('MVB'),
      description: '+MVB')
  ..addMod(
      UnitAttribute.traits,
      createReplaceInList(
          oldValue: Trait(name: 'Brawl', level: 1),
          newValue: Trait(name: 'Brawl', level: 2)),
      description: 'Brawl:2');

final Modification thunderJaguar = Modification(name: 'Thunder Jaguar Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Thunder'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp');

final Modification seccom = Modification(name: 'Seccom Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Seccom'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ECCM')),
      description: '+ECCM');

final Modification sabertooth = Modification(name: 'Sabertooth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sabertooth'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp');

final Modification tattletale = Modification(name: 'Tattletale Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tattletale'))
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SP', level: 1)),
      description: 'SP:1');

final Modification mpCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM(Aux)');

final Modification armored = Modification(name: 'Armored Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Armored'))
  ..addMod(UnitAttribute.armor, createSetIntMod(5), description: 'Armor 5')
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('LPZ'),
      description: '+LPZ');

final Modification thunderGrizzly =
    Modification(name: 'Thunder Grizzly Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Thunder'))
      ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
      ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
          description: '+SatUp');

final Modification koalaCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ECCM')),
      description: '+ECCM');

final Modification denMother = Modification(name: 'Den Mother Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Den Mother'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp');

final Modification rotaryLaser = Modification(name: 'Rotary Laser Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Rotary Laser'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createMultiReplaceInList(
        oldItems: ['LATM', 'MATM'],
        newItems: ['MRL (T,Link)'],
      ),
      description: '-LATM, -MATM, +MRL (T,Link)');

final Modification scimitarCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ECCM')),
      description: '+ECCM');

final Modification sledgehammer = Modification(name: 'Sledgehammer Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sledgehammer'))
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('2 X MAR'),
      description: '+2 x MAR');

final Modification aegis = Modification(name: 'Aegis Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Aegis'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
        oldValue: '2 X MMG (Auto)',
        newValue: 'HAPGL (Auto)',
      ),
      description: '-2 x MMG (Auto), +HAPGL (Auto)');

final Modification bastion = Modification(name: 'Bastion Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Bastion'))
  ..addMod(UnitAttribute.traits,
      createAddToList(Trait(name: 'Transport', type: 'Squads', level: 2)),
      description: '+Transport: 2 Squads');
