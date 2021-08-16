import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

final Modification command = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms');

final Modification mortarUpgrade = Modification(name: 'Mortar Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with mortar'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceInList(
        oldValue: 'MRP',
        newValue: 'LGM',
      ),
      description: '-MRP, +LGM');

final Modification sidewinderCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'SatUp', isAux: true)),
      description: '+SatUp (Aux)');

final Modification razorFang = Modification(name: 'Razor Fang Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Razor Fang'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
    UnitAttribute.traits,
    createAddToList(Trait(name: 'Comms')),
    description: '+Comms',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddToList(Trait(name: 'SatUp')),
    description: '+SatUp',
  );

final Modification ruggedTerrain = Modification(name: 'Rugged Terrain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Rugged Terrain'))
  ..addMod(UnitAttribute.react_weapons, createAddToList('MCW'),
      description: '+MCW')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Climber')),
      description: '+Climber');

final Modification copperheadArenaPilot = Modification(name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(UnitAttribute.react_weapons, createAddToList('MVB'),
      description: '+MVB')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Shield')),
      description: '+Shield');

final Modification longFang = Modification(name: 'Long Fang Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Long Fang'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'MAPR', newValue: 'MAR'),
      description: '-MAPR, +MAR');

final Modification diamondbackArenaPilot = Modification(name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(UnitAttribute.react_weapons,
      createAddToList('LVB (Precise) or LCW (Brawl:1)'),
      description: '+LVB (Precise) or +LCW (Brawl:1)')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'Brawl', level: 1)),
      description: '+Brawl:1');

final Modification blackAdderArenaPilot = Modification(name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(UnitAttribute.react_weapons, createAddToList('MVB (Reach:1)'),
      description: '+MVB (Reach:1)')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'Brawl', level: 2)),
      description: '+Brawl:2');

final Modification cobraRazorFang = Modification(name: 'Razor Fang Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Razor Fang'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
    UnitAttribute.traits,
    createAddToList(Trait(name: 'Comms')),
    description: '+Comms',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddToList(Trait(name: 'SatUp')),
    description: '+SatUp',
  );

final Modification boasLongFang = Modification(
    name: 'Long Fang Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('LGM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Long Fang'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'LGM', newValue: 'MFM'),
      description: '-LGM, +MFM');

final Modification meleeSwap = Modification(
    name: 'Melee Swap',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MVB (Reach:1)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with melee swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceInList(
          oldValue: 'MVB (Reach:1)', newValue: 'MCW (Reach:1, Demo:4)'),
      description: '-MVB (Reach:1), +MCW (Reach:1, Demo:4)');

final Modification boasArenaPilot = Modification(name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'Brawl', level: 2)),
      description: '+Brawl:2');

final Modification barbed = Modification(
    name: 'Barbed Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('LRP');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Barbed'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'LRP', newValue: 'MRP'),
      description: '-LRP, +MRP');

final Modification mpCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification antiGear = Modification(
    name: 'Anti-Gear Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MABM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Anti-Gear'))
  ..addMod(UnitAttribute.mounted_weapons,
      createReplaceInList(oldValue: 'MABM', newValue: 'MRP (Link)'),
      description: '-MABM, +MRP (Link)');

final Modification spark = Modification(
    name: 'Spark Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MRC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spark'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'MRC', newValue: 'LPA'),
      description: '-MRC, +LPA');

final Modification flame = Modification(
    name: 'Flame Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MRC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Flame'))
  ..addMod(UnitAttribute.react_weapons,
      createReplaceInList(oldValue: 'MRC', newValue: 'MFL'),
      description: '-MRC, +MFL');

final Modification hetairoiCommand = Modification(name: 'Command Upgrade')
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

final Modification caimanCommand = Modification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'ECM')),
      description: '+ECM')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification single = Modification(name: 'Single')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Single'))
  ..addMod(UnitAttribute.hull, createSetIntMod(2), description: 'Hull 2')
  ..addMod(UnitAttribute.structure, createSetIntMod(1),
      description: 'Structure 1');
