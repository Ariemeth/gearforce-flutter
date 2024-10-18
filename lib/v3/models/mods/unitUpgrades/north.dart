import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification headHunter = UnitModification(name: 'Headhunter Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
    UnitAttribute.name,
    createReplaceStringMod(change: 'Headhunter', old: 'Hunter'),
  )
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.Comms()),
    description: '+Comms',
  );

final UnitModification meleeSpecialist1 = UnitModification(
    name: 'Melee Specialist Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Melee specialist'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MVB', hasReact: true)!),
      description: '+MVB')
  ..addMod(
      UnitAttribute.traits,
      createReplaceTraitInList(
          oldValue: Trait.Brawl(1), newValue: Trait.Brawl(2)),
      description: '-Brawl:1, +Brawl:2');

final UnitModification thunderJaguar =
    UnitModification(name: 'Thunder Jaguar Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Thunder'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
          description: '+SatUp');

final UnitModification seccom = UnitModification(name: 'Seccom Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Seccom'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
      description: '+ECCM');

final UnitModification sabertooth = UnitModification(name: 'Sabertooth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sabertooth'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp');

final UnitModification tattletale = UnitModification(name: 'Tattletale Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tattletale'))
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.SP(1)),
      description: 'SP:1');

final UnitModification mpCommand = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification armored = UnitModification(name: 'Armored Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Armored'))
  ..addMod(UnitAttribute.armor, createSetIntMod(5), description: 'Armor 5')
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('LPZ')!),
      description: '+LPZ');

final UnitModification thunderGrizzly =
    UnitModification(name: 'Thunder Grizzly Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Thunder'))
      ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
          description: '+SatUp');

final UnitModification koalaCommand = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
      description: '+ECCM');

final UnitModification denMother = UnitModification(name: 'Den Mother Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Den Mother'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp');

final UnitModification gatlingLaser = UnitModification(
    name: 'Gatling Laser Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasLATM = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: gatlingLaser.id)
          .any((w) =>
              w.abbreviation == 'LATM' &&
              w.traits.any((t) => Trait.T().isSameType(t)));

      return hasLATM;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Gatling Laser'))
  ..addMod(
      UnitAttribute.weapons,
      createMultiReplaceWeaponsInList(
        oldItems: [buildWeapon('LATM (T)')!],
        newItems: [buildWeapon('MRL (T Link)')!],
      ),
      description: '-LATM, +MRL (T,Link)');

final UnitModification crossbow = UnitModification(
    name: 'Crossbow Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasLATM = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: crossbow.id)
          .any((w) =>
              w.abbreviation == 'LATM' &&
              w.traits.any((t) => Trait.T().isSameType(t)));

      return hasLATM;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Crossbow'))
  ..addMod(
      UnitAttribute.weapons,
      createMultiReplaceWeaponsInList(
        oldItems: [buildWeapon('LATM (T)')!],
        newItems: [buildWeapon('MATM (T)')!],
      ),
      description: '-LATM, +MATM (T)');

final UnitModification scimitarCommand =
    UnitModification(name: 'Command Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
          description: '+Comms')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
          description: '+SatUp')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ECCM()),
          description: '+ECCM');

final UnitModification sledgehammer = UnitModification(
    name: 'Sledgehammer Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Sledgehammer'))
  ..addMod(
      UnitAttribute.weapons, createAddWeaponToList(buildWeapon('2 X MARs')!),
      description: '+2 x MARs');

final UnitModification aegis = UnitModification(name: 'Aegis Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Aegis'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
        oldValue: buildWeapon('2 X MMGs (Auto)', hasReact: true)!,
        newValue: buildWeapon('HAPGL (Auto)', hasReact: true)!,
      ),
      description: '-2 x MMGs (Auto), +HAPGL (Auto)');

final UnitModification bastion = UnitModification(name: 'Bastion Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Bastion'))
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.Transport(2, 'Squad')),
      description: '+Transport: 2 Squads');

final UnitModification allerCommand = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.Comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.SatUp()),
      description: '+SatUp');

final UnitModification howler = UnitModification(name: 'Hower Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Howler'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5))
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.Comms()),
      description: '+Comms');

final UnitModification flakJacketUpgrade = UnitModification(
    name: 'Flak Jacket Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Flak Jacket'))
  ..addMod(
      UnitAttribute.traits, createAddOrCombineTraitToList(Trait.FieldArmor()),
      description: '+Field Armor');

final UnitModification assaultUpgrade = UnitModification(
    name: 'Assault Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Assault'))
  ..addMod(
      UnitAttribute.weapons, createAddWeaponToList(buildWeapon('MRP (Link)')!),
      description: '+MRP (Link)');

final UnitModification vibro_axeUpgrade = UnitModification(
    name: 'Vibro-Axe Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with Vibro-Axe'))
  ..addMod(UnitAttribute.weapons,
      createAddWeaponToList(buildWeapon('MVB', hasReact: true)!),
      description: '+MVB»')
  ..addMod(
      UnitAttribute.traits, createAddOrReplaceSameTraitInList(Trait.Brawl(2)),
      description: '+Brawl:2');
