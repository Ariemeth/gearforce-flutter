import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification sawBladeSwap = UnitModification(
    name: 'Saw Blade Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Saw Blade Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MCW (Brawl:1)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MCW (Brawl:1)');

final UnitModification vibroswordSwap = UnitModification(
    name: 'Vibrosword Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Vibrosword Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MVB (Reach:1)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MVB (Reach:1)');

final UnitModification destroyer = UnitModification(
    name: 'Destroyer Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('HAC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Destroyer Upgrade'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HAC', hasReact: true)!,
          newValue: buildWeapon('MBZ', hasReact: true)!),
      description: '-HAC, +MBZ');

final UnitModification demolisher = UnitModification(
    name: 'Demolisher Hand Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('HAC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Demolisher Hand Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HAC', hasReact: true)!,
          newValue: buildWeapon('MCW (Link, Demo:4)', hasReact: true)!),
      description: '-HAC, +MCW (Link, Demo:4)')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait(name: 'Brawl', level: 1),
          newValue: Trait(name: 'Brawl', level: 2)),
      description: '-Brawl:1, +Brawl:2');

final UnitModification heavyChainswordSwap = UnitModification(
    name: 'Heavy Chainsword Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('LVB');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Heavy Chainsword Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LVB', hasReact: true)!,
          newValue: buildWeapon('MCW (Brawl:1, Reach:1)', hasReact: true)!),
      description: '-LVB, +MCW (Brawl:1, Reach:1)');

final UnitModification maulerFistSwap = UnitModification(
    name: 'Mauler Fist Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mauler Fist Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MCW (Brawl:1, Demo:4)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MCW (Brawl:1, Demo:4)');

final UnitModification chainswordSwap = UnitModification(
    name: 'Chainsword Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Chainsword Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!,
          newValue: buildWeapon('LCW (Brawl:1, Reach:1)', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +LCW (Brawl:1, Reach:1)');

final UnitModification strike = UnitModification(
    name: 'Strike Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('HAC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Strike Upgrade'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HAC', hasReact: true)!,
          newValue: buildWeapon('MBZ', hasReact: true)!),
      description: '-HAC, +MBZ');

final UnitModification clawSwap = UnitModification(
    name: 'Claw Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Claw Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!,
          newValue: buildWeapon('MVB', hasReact: true)!),
      description: '-MCW (Reach:1, Demo:4), +MVB)');

final UnitModification hammerSwap = UnitModification(
    name: 'Hammer Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Brawl:1, Reach:1)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Hammer Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MCW (Brawl:1, Reach:1)', hasReact: true)!,
          newValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!),
      description: '-MCW (Brawl:1, Reach:1), +MCW (Reach:1, Demo:4)');

final UnitModification paratrooper = UnitModification(
    name: 'Paratrooper Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Paratrooper'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Airdrop')),
      description: '+Airdrop');

final UnitModification mountaineering = UnitModification(
    name: 'Mountaineering Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Mountaineering'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Climber')),
      description: '+Climber');

final UnitModification frogmen = UnitModification(name: 'Frogmen Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Frogmen'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Sub')),
      description: '+Sub');

final UnitModification latm = UnitModification(name: 'LATM Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LATM'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LAAM (Link)')!,
          newValue: buildWeapon('LATM (Link)')!),
      description: '-LAAM (Link), +LATM (Link)');

final UnitModification ecm = UnitModification(name: 'ECM Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with ECM'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW:5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECM')),
      description: '+ECM');
