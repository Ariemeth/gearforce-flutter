import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

final Modification sawBladeSwap = Modification(
    name: 'Saw Blade Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Saw Blade Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
          oldValue: 'MCW (Reach:1, Demo:4)', newValue: 'MCW (Brawl:1)'),
      description: '-MCW (Reach:1, Demo:4), +MCW (Brawl:1)');

final Modification vibroswordSwap = Modification(
    name: 'Vibrosword Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Vibrosword Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
          oldValue: 'MCW (Reach:1, Demo:4)', newValue: 'MVB (Reach:1)'),
      description: '-MCW (Reach:1, Demo:4), +MVB (Reach:1)');

final Modification destroyer = Modification(
    name: 'Destroyer Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('HAC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Destroyer Upgrade'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'HAC', newValue: 'MBZ'),
      description: '-HAC, +MBZ');

final Modification demolisher = Modification(
    name: 'Demolisher Hand Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('HAC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Demolisher Hand Swap'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'HAC', newValue: 'MCW (Link, Demo:4)'),
      description: '-HAC, +MCW (Link, Demo:4)')
  ..addMod(
      UnitAttribute.traits,
      createReplaceInList(
          oldValue: Trait(name: 'Brawl', level: 1),
          newValue: Trait(name: 'Brawl', level: 2)),
      description: '-Brawl:1, +Brawl:2');

final Modification heavyChainswordSwap = Modification(
    name: 'Heavy Chainsword Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('LVB');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name,
      createSimpleStringMod(false, 'with Heavy Chainsword Swap'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'LVB', newValue: 'MCW (Brawl:1, Reach:1)'),
      description: '-LVB, +MCW (Brawl:1, Reach:1)');

final Modification maulerFistSwap = Modification(
    name: 'Mauler Fist Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mauler Fist Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
          oldValue: 'MCW (Reach:1, Demo:4)', newValue: 'MCW (Brawl:1, Demo:4)'),
      description: '-MCW (Reach:1, Demo:4), +MCW (Brawl:1, Demo:4)');

final Modification chainswordSwap = Modification(
    name: 'Chainsword Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Chainsword Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
          oldValue: 'MCW (Reach:1, Demo:4)',
          newValue: 'LCW (Brawl:1, Reach:1)'),
      description: '-MCW (Reach:1, Demo:4), +LCW (Brawl:1, Reach:1)');

final Modification strike = Modification(
    name: 'Strike Upgrade',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('HAC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Strike Upgrade'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'HAC', newValue: 'MBZ'),
      description: '-HAC, +MBZ');

final Modification clawSwap = Modification(
    name: 'Claw Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Reach:1, Demo:4)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Claw Swap'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'MCW (Reach:1, Demo:4)', newValue: 'MVB'),
      description: '-MCW (Reach:1, Demo:4), +MVB)');

final Modification hammerSwap = Modification(
    name: 'Hammer Swap',
    requirementCheck: (Unit u) {
      return u.reactWeapons.contains('MCW (Brawl:1, Reach:1)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Hammer Swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
          oldValue: 'MCW (Brawl:1, Reach:1)',
          newValue: 'MCW (Reach:1, Demo:4)'),
      description: '-MCW (Brawl:1, Reach:1), +MCW (Reach:1, Demo:4)');

final Modification paratrooper = Modification(name: 'Paratrooper Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Paratrooper'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Airdrop')),
      description: '+Airdrop');

final Modification mountaineering = Modification(name: 'Mountaineering Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Mountaineering'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Climber')),
      description: '+Climber');

final Modification frogmen = Modification(name: 'Frogmen Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Frogmen'))
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI:3+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Sub')),
      description: '+Sub');

final Modification latm = Modification(name: 'LATM Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LATM'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'LAAM (Link)', newValue: 'LATM (Link)'),
      description: '-LAAM (Link), +LATM (Link)');

final Modification ecm = Modification(name: 'ECM Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with ECM'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW:5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ECM')),
      description: '+ECM');
