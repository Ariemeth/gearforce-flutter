import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification cv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification cuirassierCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification fragCannon = UnitModification(
    name: 'Frag Cannon Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('LRF');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Frag Cannon'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LRF', hasReact: true)!,
          newValue: buildWeapon('MFC', hasReact: true)!),
      description: '-LRF, +MFC');

final UnitModification rapidFireBazooka = UnitModification(
    name: 'Rapid Fire Bazooka Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('LRF');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Frag Cannon'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LRF', hasReact: true)!,
          newValue: buildWeapon('MFC', hasReact: true)!),
      description: '-LRF, +LBZ(AP:1, Burst:1)');

final UnitModification espionCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp');

final UnitModification mfmBoa = UnitModification(
    name: 'MFM Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('LGM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'MFM'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LGM')!, newValue: buildWeapon('MFM')!),
      description: '-LGM, +MFM');

final UnitModification cv2 = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification voltigeurABM = UnitModification(
    name: 'ABM Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('2 X MATM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV: -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'ABM'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('2 X MATM')!,
          newValue: buildWeapon('2 X MABM')!),
      description: '-2 X MATM, +2 X MABM');

final UnitModification voltigeurAM = UnitModification(
    name: 'AM Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('2 X MATM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: 0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'AM'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('2 X MATM')!,
          newValue: buildWeapon('2 X MAM')!),
      description: '-2 X MATM, +2 X MAM');

final UnitModification voltigeurCv = UnitModification(name: 'CV Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'CV'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECCM')),
      description: '+ECCM');

final UnitModification team = UnitModification(name: 'Team')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Team'))
  ..addMod(UnitAttribute.hull, createSetIntMod(2), description: 'H/S: 2/1')
  ..addMod(UnitAttribute.structure, createSetIntMod(1));

final UnitModification koreshi = UnitModification(name: 'Koreshi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Koreshi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms');
