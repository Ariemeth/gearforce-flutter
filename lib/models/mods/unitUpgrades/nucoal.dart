import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

Modification cv = Modification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('ECCM (Aux)'),
      description: '+ECCM (Aux)');

Modification cuirassierCv = Modification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList('ECCM (Aux)'),
      description: '+ECCM (Aux)');

Modification fragCannon = Modification(
    name: 'Frag Cannon Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('LRF');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Frag Cannon'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'LRF', newValue: 'MFC'),
      description: '-LRF, +MFC');

Modification rapidFireBazooka = Modification(
    name: 'Rapid Fire Bazooka Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('LRF');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Frag Cannon'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'LRF', newValue: 'MFC'),
      description: '-LRF, +LBZ(AP:1, Burst:1)');

Modification espionCv = Modification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp');

Modification mfmBoa = Modification(
    name: 'MFM Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('LGM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'MFM'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'LGM', newValue: 'MFM'),
      description: '-LGM, +MFM');

Modification cv2 = Modification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList('ECCM (Aux)'),
      description: '+ECCM (Aux)');

Modification voltigeurABM = Modification(
    name: 'ABM Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('2 X MATM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV: -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'ABM'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: '2 X MATM', newValue: '2 X MABM'),
      description: '-2 X MATM, +2 X MABM');

Modification voltigeurAM = Modification(
    name: 'AM Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('2 X MATM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: 0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'AM'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: '2 X MATM', newValue: '2 X MAM'),
      description: '-2 X MATM, +2 X MAM');

Modification voltigeurCv = Modification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList('SatUp'),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList('ECCM'), description: '+ECCM');

Modification team = Modification(name: 'Team')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Team'))
  ..addMod(UnitAttribute.hull, createSetIntMod(2), description: 'H/S: 2/1')
  ..addMod(UnitAttribute.structure, createSetIntMod(1));

Modification koreshi = Modification(name: 'Koreshi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Koreshi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddToList('SP:+1'),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddToList('Comms'),
      description: '+Comms');
