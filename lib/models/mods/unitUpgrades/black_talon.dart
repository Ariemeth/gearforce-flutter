import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

Modification psi = Modification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms');

Modification darkJaguarPsi = Modification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp (Aux)'),
      description: '+SatUp (Aux)');

Modification phi = Modification(name: 'Phi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Phi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('ECCM'), description: '+ECCM');

Modification darkMambaPsi = Modification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp');

Modification xi = Modification(name: 'Xi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Xi'))
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('MGM'),
      description: '+MGM');

Modification zeta = Modification(
    name: 'Zeta Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MRC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Zeta'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'MRC', newValue: 'LPA'),
      description: '-MRC, +LPA');

Modification pur = Modification(
    name: 'Pur Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MRC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Pur'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'MRC', newValue: 'MFL'),
      description: '-MRC, +MFL');

Modification darkCoyotePsi = Modification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('SP:+1'),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList('ECCM'), description: '+ECCM')
  ..addMod(UnitAttribute.traits,
      createReplaceInList(oldValue: 'ECM', newValue: 'ECM+'),
      description: '-ECM, +ECM+');

Modification iota = Modification(name: 'Iota Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Iota'))
  ..addMod(UnitAttribute.mounted_weapons, createRemoveFromList('MRP'),
      description: '-MRP')
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('LAPR'),
      description: '+LAPR')
  ..addMod(UnitAttribute.mounted_weapons, createAddToList('LAPGL'),
      description: '+LAPGL');

Modification theta = Modification(name: 'Theta Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Theta'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'MGM', newValue: 'MATM'),
      description: '-MGM, +MATM');

Modification darkHoplitePsi = Modification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('SP:+1'),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp');

Modification blackwindTheta = Modification(name: 'Theta Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Theta'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'MRP (Link)', newValue: 'LATM (Link)'),
      description: '-MRP (Link), +LATM (Link)');
