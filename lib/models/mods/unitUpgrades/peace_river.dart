import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final Modification chieftain = Modification(name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms');

final Modification chieftainIV = Modification(name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp');

final Modification jetpack = Modification(name: 'Jetpack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Jetpack'))
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Jetpack', level: 6)),
      description: '+Jetpack:6');

final Modification meleeSpecialist = Modification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LVB', hasReact: true)!,
          newValue: buildWeapon('MVB', hasReact: true)!),
      description: '-LVB, +MVB')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait(name: 'Brawl', level: 1),
          newValue: Trait(name: 'Brawl', level: 2)),
      description: '-Brawl:1, +Brawl:2');

final Modification meleeSpecialist1 = Modification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(UnitAttribute.react_weapons,
      createAddWeaponToList(buildWeapon('MVB', hasReact: true)!),
      description: '+MVB')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait(name: 'Brawl', level: 1),
          newValue: Trait(name: 'Brawl', level: 2)),
      description: '-Brawl:1, +Brawl:2');

final Modification greyhoundChieftain = Modification(name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECCM')),
      description: '+ECCM');

final Modification skirmisherChieftain = Modification(name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'SatUp', isAux: true)),
      description: '+SatUp (Aux)')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification skirmisherTag = Modification(name: 'Tag Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Tag'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'TD')),
      description: '+TD')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification specialForces = Modification(name: 'Special Forces Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Special Forces'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
      description: '+SO')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Stealth', isAux: true)),
      description: '+Stealth (Aux)');

final Modification shinobiMeleeSpecialist = Modification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'melee specialist'))
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Brawl', level: 2)),
      description: '+Brawl:2');

final Modification shinobiChieftain = Modification(name: 'Chieftain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Chieftain'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECCM')),
      description: '+ECCM')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'SatUp', isAux: true)),
      description: '+SatUp (Aux)');

final Modification crusaderV = Modification(name: 'Crusader V Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Crusader V'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createMultiReplaceWeaponsInList(
        oldItems: [buildWeapon('MRP (Link)')!, buildWeapon('LFM')!],
        newItems: [buildWeapon('MRP')!, buildWeapon('MFM')!],
      ),
      description: '-MRP (Link), -LFM, +MRP, +MFM')
  ..addMod(UnitAttribute.traits,
      createRemoveFromList(Trait(name: 'Vuln', type: 'Haywire')),
      description: '-Vuln:Haywire');

final Modification cataphractLord = Modification(name: 'Lord Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Lord'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECCM')),
      description: '+ECCM');

final Modification tankHunter = Modification(name: 'Tank Hunter Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tank Hunter'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HRP (Link)')!,
          newValue: buildWeapon('MTG (Link)')!),
      description: '-HRP (Link), +MTG (Link)');

final Modification uhlanLord = Modification(name: 'Lord Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Lord'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECM', isAux: true)),
      description: '+ECM (Aux)')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification alphaDog = Modification(name: 'Alpha Dog Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Alpha Dog'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECCM')),
      description: '+ECCM')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait(name: 'ECM'), newValue: Trait(name: 'ECM+')),
      description: '-ECM, +ECM+');

final Modification arbalest = Modification(name: 'Arbalest Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arbalest'))
  ..addMod(UnitAttribute.react_weapons,
      createRemoveWeaponFromList(buildWeapon('MRC (T AA)')!),
      description: '-MRC (T, AA)')
  ..addMod(UnitAttribute.mounted_weapons,
      createAddWeaponToList(buildWeapon('2 X HAAM (T)')!),
      description: '+2 X HAAM (T)');

final Modification herdLord = Modification(name: 'Herd Lord Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Herd Lord'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait(name: 'SP', level: 1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp');

final Modification missile = Modification(name: 'Missile Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Missile'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRP (Link)')!,
          newValue: buildWeapon('LATM (Link)')!),
      description: '-MRP (Link), +LATM (Link)');
