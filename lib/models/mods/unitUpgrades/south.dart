import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final _plusMinusMatch = RegExp(r'^(\+|-)');

final UnitModification command = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms');

final UnitModification mortarUpgrade = UnitModification(name: 'Mortar Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with mortar'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
        oldValue: buildWeapon('MRP')!,
        newValue: buildWeapon('LGM')!,
      ),
      description: '-MRP, +LGM');

final UnitModification sidewinderCommand =
    UnitModification(name: 'Command Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
      ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
          description: '+Comms')
      ..addMod(
          UnitAttribute.traits,
          createAddTraitToList(Trait(name: 'SatUp', isAux: true)),
          description: '+SatUp (Aux)');

final UnitModification razorFang = UnitModification(name: 'Razor Fang Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Razor Fang'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait(name: 'Comms')),
    description: '+Comms',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait(name: 'SatUp')),
    description: '+SatUp',
  );

final UnitModification ruggedTerrain = UnitModification(
    name: 'Rugged Terrain Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Rugged Terrain'))
  ..addMod(UnitAttribute.react_weapons,
      createAddWeaponToList(buildWeapon('MCW', hasReact: true)!),
      description: '+MCW')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Climber')),
      description: '+Climber');

final UnitModification copperheadArenaPilot = UnitModification(
    name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(UnitAttribute.react_weapons,
      createAddWeaponToList(buildWeapon('MVB', hasReact: true)!),
      description: '+MVB')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Shield')),
      description: '+Shield');

final UnitModification longFang = UnitModification(name: 'Long Fang Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Long Fang'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MAPR')!, newValue: buildWeapon('MAR')!),
      description: '-MAPR, +MAR');

UnitModification diamondbackArenaPilot(Unit u) {
  List<ModificationOption> _options = [];
  _options.add(ModificationOption('+LVB (Precise)'));
  _options.add(ModificationOption('+LCW (Brawl:1)'));

  var modOptions = ModificationOption('Arena Pilot',
      subOptions: _options, description: 'Choose one');

  return UnitModification(
      name: 'Arena Pilot', options: modOptions, id: 'diamondbackArenaPilot')
    ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
    ..addMod(UnitAttribute.name, createSimpleStringMod(false, ' Arena Pilot'))
    ..addMod(UnitAttribute.react_weapons, (value) {
      if (!(value is List<Weapon>)) {
        print('value is not a List<Weapon>, $value');
        return value;
      }

      // check if a option has been chosen
      if (modOptions.selectedOption == null) {
        return value;
      }

      final newList = value.toList();
      var add = buildWeapon(
          // need to remove the + or - from the front of the text
          modOptions.selectedOption!.text.replaceAll(_plusMinusMatch, ''),
          hasReact: true);
      if (add != null) {
        newList.add(add);
      }

      return newList;
    }, description: '+LVB (Precise) or +LCW (Brawl:1)')
    ..addMod(UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'Brawl', level: 1)),
        description: '+Brawl:1');
}

final UnitModification blackAdderArenaPilot = UnitModification(
    name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(UnitAttribute.react_weapons,
      createAddWeaponToList(buildWeapon('MVB (Reach:1)', hasReact: true)!),
      description: '+MVB (Reach:1)')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Brawl', level: 2)),
      description: '+Brawl:2');

final UnitModification cobraRazorFang =
    UnitModification(name: 'Razor Fang Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Razor Fang'))
      ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'Comms')),
        description: '+Comms',
      )
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'SatUp')),
        description: '+SatUp',
      );

final UnitModification boasLongFang = UnitModification(
    name: 'Long Fang Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('LGM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Long Fang'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LGM')!, newValue: buildWeapon('MFM')!),
      description: '-LGM, +MFM');

final UnitModification meleeSwap = UnitModification(
    name: 'Melee Swap',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MVB (Reach:1)');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with melee swap'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MVB (Reach:1)', hasReact: true)!,
          newValue: buildWeapon('MCW (Reach:1, Demo:4)', hasReact: true)!),
      description: '-MVB (Reach:1), +MCW (Reach:1, Demo:4)');

final UnitModification boasArenaPilot = UnitModification(name: 'Arena Pilot')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Arena Pilot'))
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Brawl', level: 2)),
      description: '+Brawl:2');

final UnitModification barbed = UnitModification(
    name: 'Barbed Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('LRP');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Barbed'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LRP')!, newValue: buildWeapon('MRP')!),
      description: '-LRP, +MRP');

final UnitModification mpCommand = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification antiGear = UnitModification(
    name: 'Anti-Gear Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MABM');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Anti-Gear'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MABM')!, newValue: buildWeapon('MRP (Link)')!),
      description: '-MABM, +MRP (Link)');

final UnitModification spark = UnitModification(
    name: 'Spark Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MRC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV: +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spark'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRC', hasReact: true)!,
          newValue: buildWeapon('LPA', hasReact: true)!),
      description: '-MRC, +LPA');

final UnitModification flame = UnitModification(
    name: 'Flame Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.contains('MRC');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Flame'))
  ..addMod(
      UnitAttribute.react_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRC', hasReact: true)!,
          newValue: buildWeapon('MFL', hasReact: true)!),
      description: '-MRC, +MFL');

final UnitModification hetairoiCommand =
    UnitModification(name: 'Command Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
          description: '+SatUp')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
          description: '+ECCM (Aux)');

final UnitModification caimanCommand = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Comms')),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'SatUp')),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECM')),
      description: '+ECM')
  ..addMod(UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification single = UnitModification(name: 'Single')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(-1), description: 'TV -1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Single'))
  ..addMod(UnitAttribute.hull, createSetIntMod(2), description: 'Hull 2')
  ..addMod(UnitAttribute.structure, createSetIntMod(1),
      description: 'Structure 1');
