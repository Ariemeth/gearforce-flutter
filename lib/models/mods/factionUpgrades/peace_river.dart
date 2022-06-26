import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const peaceRiverIDBase = 'faction: peace river';

const e_pexID = '$peaceRiverIDBase - 10';
const warriorEliteID = '$peaceRiverIDBase - 20';
const crisisRespondersID = '$peaceRiverIDBase - 30';
const laserTechID = '$peaceRiverIDBase - 40';
const olTrustyID = '$peaceRiverIDBase - 50';
const thunderFromTheSkyID = '$peaceRiverIDBase - 60';
const eliteElmentsID = '$peaceRiverIDBase - 70';

class PeaceRiverFactionMods extends FactionModification {
  PeaceRiverFactionMods({
    required String name,
    required bool Function(CombatGroup, Unit) requirementCheck,
    ModificationOption? options,
    required String id,
  }) : super(
          name: name,
          requirementCheck: requirementCheck,
          options: options,
          id: id,
        );
  /*
    E-pex: One Peace River model within each combat group may increase its EW 
    skill by one for 1 TV each.
  */
  factory PeaceRiverFactionMods.e_pex() {
    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      return cg.modCount(e_pexID) == 0;
    };
    return PeaceRiverFactionMods(
        name: 'E-pex', requirementCheck: reqCheck, id: e_pexID)
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      // TODO figure a way to handle both this mod and hunter elite at the same
      // time.  currently there is an ordering issue which could affect the
      // final value.
      ..addMod(UnitAttribute.ew, createSimpleIntMod(-1),
          description: 'One ' +
              'Peace River model within each combat group may ' +
              'increase its EW skill by one for 1 TV each');
  }

  /*
    Warrior Elite: Any Warrior IV may be upgraded to a Warrior Elite for 1 
    TV each. This upgrade gives the Warrior IV a H/S of 4/2, an EW skill of 4+,
    and the Agile trait.
  */
  factory PeaceRiverFactionMods.warriorElite() {
    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      return u.core.frame == 'Warrior IV';
    };
    return PeaceRiverFactionMods(
        name: 'Warrior Elite', requirementCheck: reqCheck, id: warriorEliteID)
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Elite'),
          description: 'Any Warrior IV may be upgraded to a Warrior Elite')
      ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S: 4/2')
      ..addMod(UnitAttribute.structure, createSetIntMod(2))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW: 4')
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(const Trait(name: 'Agile')),
        description: '+Agile',
      );
  }

  /*
    Crisis Responders: Any Crusader IV that has been upgraded to a Crusader V 
    may swap their HAC, MSC, MBZ or LFG for a MPA (React) and a Shield for 1 TV.
    This Crisis Responder variant is unlimited for this force.
  */
  // TODO support the unlimited variant this upgrade adds
  factory PeaceRiverFactionMods.crisisResponders(Unit u) {
    final allowedWeaponMatch = RegExp(r'^(HAC|MSC|MBZ|LFG)$');
    final List<ModificationOption> _options = [];
    u.weapons
        .where((w) => allowedWeaponMatch.hasMatch(w.abbreviation))
        .forEach((w) {
      _options.add(ModificationOption(w.toString()));
    });
    final modOptions = ModificationOption('Crisis Responders',
        subOptions: _options,
        description: 'Choose one of the available weapons be replaced with' +
            'a MPA (React) and a Shield');

    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      return u.core.frame == 'Crusader IV' && u.hasMod('Crusader V Upgrade');
    };
    return PeaceRiverFactionMods(
      name: 'Crisis Responders',
      requirementCheck: reqCheck,
      id: crisisRespondersID,
      options: modOptions,
    )
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(const Trait(name: 'Shield')),
          description: '+Shield')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value.toList();

        if (modOptions.selectedOption == null ||
            !newList
                .any((w) => w.toString() != modOptions.selectedOption?.text)) {
          return newList;
        }
        final selectedWeaponToRemove = newList
            .firstWhere((w) => w.toString() == modOptions.selectedOption?.text);

        newList.remove(selectedWeaponToRemove);
        newList.add(buildWeapon('MPA', hasReact: true)!);

        return newList;
      },
          description: 'Any Crusader IV that has been upgraded to a ' +
              'Crusader V may swap their HAC, MSC, MBZ or LFG for a ' +
              'MPA (React) and a Shield');
  }

  /*
    Laser Tech: Veteran universal infantry and veteran Spitz Monowheels may 
    upgrade their IW, IR or IS for 1 TV each. These weapons receive the 
    Advanced trait.
  */
  factory PeaceRiverFactionMods.laserTech(Unit u) {
    final allowedWeaponMatch = RegExp(r'^(IW|IR|IS)$');
    final List<ModificationOption> _options = [];
    u.weapons.where((w) => allowedWeaponMatch.hasMatch(w.code)).forEach((w) {
      _options.add(ModificationOption(w.toString()));
    });
    final modOptions = ModificationOption('Laser Tech',
        subOptions: _options,
        description: 'Choose one of the available weapons be gain the ' +
            'Advanced trait');

    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      return u.isVeteran() &&
          (u.core.frame == 'Universal Infantry' || u.name == 'Spitz Monowheel');
    };

    return PeaceRiverFactionMods(
      name: 'Laser Tech',
      requirementCheck: reqCheck,
      id: laserTechID,
      options: modOptions,
    )
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }

        if (value.isEmpty) {
          return value;
        }
        final newList = value.toList();

        if (modOptions.selectedOption == null ||
            !newList
                .any((w) => w.toString() == modOptions.selectedOption?.text)) {
          return newList;
        }
        final selectedWeaponToRemove = newList
            .firstWhere((w) => w.toString() == modOptions.selectedOption?.text);

        newList.remove(selectedWeaponToRemove);
        newList.add(Weapon.fromWeapon(
          selectedWeaponToRemove,
          addTraits: [const Trait(name: 'Advanced')],
        ));

        return newList;
      },
          description: 'Veteran universal infantry and veteran Spitz ' +
              'Monowheels may upgrade their IW, IR or IS with the Advanced ' +
              'trait.')
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }

        if (value.isEmpty) {
          return value;
        }
        final newList = value.toList();

        if (modOptions.selectedOption == null ||
            !newList
                .any((w) => w.toString() == modOptions.selectedOption?.text)) {
          return newList;
        }

        final selectedWeaponToRemove = newList
            .firstWhere((w) => w.toString() == modOptions.selectedOption?.text);

        newList.remove(selectedWeaponToRemove);
        newList.add(Weapon.fromWeapon(
          selectedWeaponToRemove,
          addTraits: [const Trait(name: 'Advanced')],
        ));

        return newList;
      });
  }
/*
  Ol’ Trusty: Warriors, Jackals and Spartans may increase their GU skill by one for 1
  TV each. This does not include Warrior IVs.
*/
  factory PeaceRiverFactionMods.olTrusty() {
    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      return u.core.frame == 'Warrior' ||
          u.core.frame == 'Jackal' ||
          u.core.frame == 'Spartan';
    };
    return PeaceRiverFactionMods(
        name: 'Ol’ Trusty', requirementCheck: reqCheck, id: olTrustyID)
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(
        UnitAttribute.gunnery,
        createSimpleIntMod(-1),
        description:
            'Warriors, Jackals and Spartans may increase their GU skill by ' +
                'one for 1',
      );
  }

/*
  Thunder from the Sky: Airstrike counters may increase their GU skill to 3+ instead
  of 4+ for 1 TV each.
*/
  factory PeaceRiverFactionMods.thunderFromTheSky() {
    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      return u.core.type == 'Airstrike Counters';
    };
    return PeaceRiverFactionMods(
        name: 'Thunder from the Sky',
        requirementCheck: reqCheck,
        id: thunderFromTheSkyID)
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(UnitAttribute.gunnery, createSetIntMod(3),
          description: 'Airstrike counters may increase their GU skill to 3+');
  }

  /*
    Elite Elements: One SK unit may change their role to SO.
  */
  factory PeaceRiverFactionMods.eliteElements(UnitRoster roster) {
    final bool Function(CombatGroup, Unit) reqCheck = (CombatGroup cg, Unit u) {
      if (u.role() == null) {
        return false;
      }
      // unit must be of the SK role type and only 1 unit may have this mod.
      return u.role()!.roles.any((r) => r.name == RoleType.SK) &&
          roster.unitsWithMod(eliteElmentsID) == 0;
    };
    return PeaceRiverFactionMods(
        name: 'Elite Elements', requirementCheck: reqCheck, id: eliteElmentsID)
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(
          UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
          description: '+SO, One SK unit may change their role to SO');
  }
}
