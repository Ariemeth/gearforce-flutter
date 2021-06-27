import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

List<Modification> getUnitMods(String frameName) {
  switch (frameName.toLowerCase()) {
    case 'hunter':
      return [headHunter];
    case 'stripped-down hunter':
      return [headHunter];
    case 'para hunter':
      return [headHunter];
    case 'hunter xmg':
      return [meleeSpecialist1];
    case 'jaguar':
      return [thunderJaguar, seccom];
    case 'tiger':
      return [sabertooth];
    case 'weasel':
      return [tattletale];
    case 'mp gears':
      return [mpCommand];
    case 'lynx':
      return [armored];
    case 'grizzly':
      return [thunderGrizzly];
    case 'koala':
      return [koalaCommand];
    case 'bear':
      return [denMother];
    case 'scimitar':
      return [rotaryLaser, scimitarCommand];
    case 'mammoth':
      return [sledgehammer, aegis];
  }
  return [];
}

Modification headHunter = Modification(name: 'Headhunter Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Headhunter'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'));

Modification meleeSpecialist1 = Modification(name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(UnitAttribute.react_weapons, createAddToList('MVB'))
  ..addMod(UnitAttribute.traits,
      createReplaceInList(oldValue: 'Brawl:1', newValue: 'Brawl:2'));

Modification thunderJaguar = Modification(name: 'Thunder Jaguar Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Thunder'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'));

Modification seccom = Modification(name: 'Seccom Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Seccom'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4))
  ..addMod(UnitAttribute.traits, createAddToList('ECCM'));

Modification sabertooth = Modification(name: 'Sabertooth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sabertooth'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'));

Modification tattletale = Modification(name: 'Tattletale Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tattletale'))
  ..addMod(UnitAttribute.traits, createAddToList('SP:1'));

Modification mpCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('ECCM(Aux)'));

Modification armored = Modification(name: 'Armored Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Armored'))
  ..addMod(UnitAttribute.armor, createSetIntMod(5))
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('LPZ'));

Modification thunderGrizzly = Modification(name: 'Thunder Grizzly Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Thunder'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'));

Modification koalaCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'))
  ..addMod(UnitAttribute.traits, createAddToList('ECCM'));

Modification denMother = Modification(name: 'Den Mother Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Den Mother'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'));

Modification rotaryLaser = Modification(name: 'Rotary Laser Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2))
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Rotary Laser'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createMultiReplaceInList(
        oldItems: ['LATM', 'MATM'],
        newItems: ['MRL (T,Link)'],
      ));

Modification scimitarCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4))
  ..addMod(UnitAttribute.traits, createAddToList('Comms'))
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'))
  ..addMod(UnitAttribute.traits, createAddToList('ECCM'));

Modification sledgehammer = Modification(name: 'Sledgehammer Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sledgehammer'))
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('2 X MAR'));

Modification aegis = Modification(name: 'Aegis Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Aegis'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
        oldValue: '2 X MMG (Auto)',
        newValue: 'HAPGL (Auto)',
      ));

Modification bastion = Modification(name: 'Bastion Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1))
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Bastion'))
  ..addMod(UnitAttribute.traits, createAddToList('Transport: 2 Squads'));
