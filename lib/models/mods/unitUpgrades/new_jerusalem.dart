import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapons.dart';

final UnitModification faithful = UnitModification(name: 'Faithful')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Faithful'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5, onlyIfLessThan: true),
      description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Faithful()),
      description: '+Faithful');

final UnitModification archUpgrade4 = UnitModification(name: 'Arch Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arch'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4, onlyIfLessThan: true),
      description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms');

final UnitModification archUpgrade5 = UnitModification(name: 'Arch Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arch'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5, onlyIfLessThan: true),
      description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms');

final UnitModification archUpgradeGhazi = UnitModification(name: 'Arch Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arch'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4, onlyIfLessThan: true),
      description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
      description: '+ECCM');

final UnitModification archUpgradeAbbess =
    UnitModification(name: 'Arch Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arch'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4, onlyIfLessThan: true),
          description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
          description: '+ECCM');

final UnitModification archUpgradeZealot =
    UnitModification(name: 'Arch Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Arch'))
      ..addMod(UnitAttribute.armor, createSetIntMod(4), description: 'Arm:4')
      ..addMod(UnitAttribute.hull, createSetIntMod(5), description: 'H:5')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
          description: '+Comms');

final UnitModification genesisUpgrade =
    UnitModification(name: 'Genesis Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Genesis'))
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
          description: '+ECM')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
          description: '+ECCM');

final UnitModification genesisUpgradePrioress =
    UnitModification(name: 'Genesis Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Genesis'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4, onlyIfLessThan: true),
          description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
          description: '+ECM')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
          description: '+ECCM');

final UnitModification samsonUpgrade = UnitModification(name: 'Samson Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Samson'))
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
        oldValue: Trait.Brawl(2),
        newValue: Trait.Brawl(4),
      ),
      description: '-Brawl:2, +Brawl:4');

final UnitModification neshUpgrade = UnitModification(name: 'Nesh Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Nesh'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.CBS()),
      description: '+CBS');

final UnitModification zacchaeusUpgrade = UnitModification(
    name: 'Zacchaeus Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Zacchaeus'))
  ..addMod(
    UnitAttribute.weapons,
    createAddWeaponToList(buildWeapon('MCW', hasReact: true)!),
    description: '+MCW',
  )
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Climber()),
      description: '+Climber')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.Brawl(1)),
      description: '+Brawl:1');

final UnitModification sayfUpgrade = UnitModification(name: 'Sayf Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sayf'))
  ..addMod(
    UnitAttribute.weapons,
    createAddWeaponToList(buildWeapon('LVB (Link)', hasReact: true)!),
    description: '+LVB (Link)',
  )
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.Brawl(1)),
      description: '+Brawl:1');

final UnitModification nissiUpgrade = UnitModification(name: 'Nissi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Nissi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4, onlyIfLessThan: true),
      description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
      description: '+ECM');

final UnitModification enhancedEngine = UnitModification(
    name: 'Enhanced Engine')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Enhanced Engine'))
  ..addMod(UnitAttribute.movement,
      createSetMovementMod(Movement(type: 'H', rate: 9)),
      description: 'H:9');

final UnitModification squadKwaja = UnitModification(name: 'Squad Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4))
  ..addMod(UnitAttribute.structure, createSetIntMod(4), description: 'H/S 4/4');

final UnitModification milchamaPack = UnitModification(
  name: 'Milchama Pack',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, milchamaPack.name);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Milchama Pack'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MAG', hasReact: false)!),
      description: '+MAG');

final UnitModification raavPack = UnitModification(
  name: 'Ra\'av Pack',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, raavPack.name);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(4), description: 'TV +4')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Ra\'av Pack'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('HRG', hasReact: false)!),
      description: '+HRG');

final UnitModification mavethPack = UnitModification(
  name: 'Maveth Pack',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, mavethPack.name);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Maveth Pack'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('LFG (Link)', hasReact: false)!),
      description: '+LFG (Link)');

final UnitModification deverPack = UnitModification(
  name: 'Dever Pack',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, deverPack.name);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Dever Pack'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MAM', hasReact: false)!),
      description: '+MAM');

final UnitModification kibushPack = UnitModification(
  name: 'Kibush Pack',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, kibushPack.name);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(5), description: 'TV +5')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Kibush Pack'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4, onlyIfLessThan: true),
      description: 'EW 4+')
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MRL (AA)', hasReact: true)!),
      description: '+MRL (AA)')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECM()),
      description: '+ECM')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Sensors(24)),
      description: '+Sensors:24');

final UnitModification milchamaPack2 = UnitModification(
  name: 'Milchama Pack 2',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, milchamaPack2.name) &&
        unit.hasMod('Milchama Pack');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Milchama Pack'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MAG', hasReact: false)!,
          newValue: buildWeapon('2 x MAG', hasReact: false)!),
      description: '+MAG');

final UnitModification raavPack2 = UnitModification(
  name: 'Ra\'av Pack 2',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, raavPack2.name) &&
        unit.hasMod('Ra\'av Pack');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(4), description: 'TV +4')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Ra\'av Pack'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HRG', hasReact: false)!,
          newValue: buildWeapon('2 x HRG', hasReact: false)!),
      description: '+HRG');

final UnitModification mavethPack2 = UnitModification(
  name: 'Maveth Pack 2',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, mavethPack2.name) &&
        unit.hasMod('Maveth Pack');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Maveth Pack'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LFG (Link)', hasReact: false)!,
          newValue: buildWeapon('2 x LFG (Link)', hasReact: false)!),
      description: '+LFG (Link)');

final UnitModification deverPack2 = UnitModification(
  name: 'Dever Pack 2',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, deverPack2.name) &&
        unit.hasMod('Dever Pack');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Dever Pack'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MAM', hasReact: false)!,
          newValue: buildWeapon('2 x MAM', hasReact: false)!),
      description: '+MAM');

final UnitModification kibushPack2 = UnitModification(
  name: 'Kibush Pack 2',
  requirementCheck: (rs, ur, cg, unit) {
    return hasLessThenTwoPackMods(unit, kibushPack2.name) &&
        unit.hasMod('Kibush Pack');
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(5), description: 'TV +5')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'w/ Kibush Pack'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3, onlyIfLessThan: true),
      description: 'EW 3+')
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRL (AA)', hasReact: true)!,
          newValue: buildWeapon('2 x MRL (AA)', hasReact: true)!),
      description: '+MRL (AA)')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.ECM(), newValue: Trait.ECMPlus()),
      description: '+ECM+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Sensors(36)),
      description: '+Sensors:36');

final _packMatch = RegExp(r'^w\/.+Pack$');

final _packModNames = [
  milchamaPack.name,
  raavPack.name,
  mavethPack.name,
  deverPack.name,
  kibushPack.name,
  milchamaPack2.name,
  raavPack2.name,
  mavethPack2.name,
  deverPack2.name,
  kibushPack2.name,
];

bool hasLessThenTwoPackMods(Unit unit, String exludedPackName) {
  final trimmedModNames =
      _packModNames.where((name) => name != exludedPackName);

  final modsWithPack =
      unit.getMods().where((mod) => trimmedModNames.contains(mod.name));
  final hasLessThanTwo = modsWithPack.length < 2;
  return hasLessThanTwo;
}
