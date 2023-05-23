import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _peaceRiverIDBase = 'mod::faction::peace river';

const e_pexID = '$_peaceRiverIDBase::10';
const warriorEliteID = '$_peaceRiverIDBase::20';
const crisisRespondersID = '$_peaceRiverIDBase::30';
const laserTechID = '$_peaceRiverIDBase::40';
const olTrustyID = '$_peaceRiverIDBase::50';
const thunderFromTheSkyID = '$_peaceRiverIDBase::60';
const eliteElementsID = '$_peaceRiverIDBase::70';
const ecmSpecialistID = '$_peaceRiverIDBase::80';
const olTrustyPOCID = '$_peaceRiverIDBase::90';
const peaceOfficersID = '$_peaceRiverIDBase::100';
const gSWATSniperID = '$_peaceRiverIDBase::110';

class PeaceRiverFactionMods extends FactionModification {
  PeaceRiverFactionMods({
    required String name,
    required RequirementCheck requirementCheck,
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
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      return cg!.modCount(e_pexID) == 0 ||
          (cg.modCount(e_pexID) == 1 && u.hasMod(e_pexID));
    };
    return PeaceRiverFactionMods(
        name: 'E-pex', requirementCheck: reqCheck, id: e_pexID)
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      // TODO figure a way to handle both this mod and hunter elite at the same
      // time.  currently there is an ordering issue which could affect the
      // final value.
      ..addMod<int>(UnitAttribute.ew, createSimpleIntMod(-1),
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
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.core.frame == 'Warrior IV';
    };
    return PeaceRiverFactionMods(
        name: 'Warrior Elite', requirementCheck: reqCheck, id: warriorEliteID)
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<String>(UnitAttribute.name, createSimpleStringMod(true, 'Elite'),
          description: 'Any Warrior IV may be upgraded to a Warrior Elite')
      ..addMod<int>(UnitAttribute.hull, createSetIntMod(4),
          description: 'H/S: 4/2')
      ..addMod<int>(UnitAttribute.structure, createSetIntMod(2))
      ..addMod<int>(UnitAttribute.ew, createSetIntMod(4), description: 'EW: 4')
      ..addMod<List<Trait>>(
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

    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.core.frame == 'Crusader IV' && u.hasMod('Crusader V Upgrade');
    };
    return PeaceRiverFactionMods(
      name: 'Crisis Responders',
      requirementCheck: reqCheck,
      id: crisisRespondersID,
      options: modOptions,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<List<Trait>>(UnitAttribute.traits,
          createAddTraitToList(const Trait(name: 'Shield')),
          description: '+Shield')
      ..addMod<List<Weapon>>(UnitAttribute.react_weapons, (value) {
        final newList = value.toList();

        if (modOptions.selectedOption == null ||
            !newList
                .any((w) => w.toString() == modOptions.selectedOption?.text)) {
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

    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.isVeteran() &&
          (u.core.frame == 'Universal Infantry' || u.name == 'Spitz Monowheel');
    };

    return PeaceRiverFactionMods(
      name: 'Laser Tech',
      requirementCheck: reqCheck,
      id: laserTechID,
      options: modOptions,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<List<Weapon>>(UnitAttribute.react_weapons, (value) {
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
      ..addMod<List<Weapon>>(UnitAttribute.mounted_weapons, (value) {
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
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.core.frame == 'Warrior' ||
          u.core.frame == 'Jackal' ||
          u.core.frame == 'Spartan';
    };
    return PeaceRiverFactionMods(
        name: 'Ol’ Trusty', requirementCheck: reqCheck, id: olTrustyID)
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<int>(
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
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.core.type == ModelType.AirstrikeCounter;
    };
    return PeaceRiverFactionMods(
        name: 'Thunder from the Sky',
        requirementCheck: reqCheck,
        id: thunderFromTheSkyID)
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<int>(UnitAttribute.gunnery, createSetIntMod(3),
          description: 'Airstrike counters may increase their GU skill to 3+');
  }

  /*
    Elite Elements: One SK unit may change their role to SO.
  */
  factory PeaceRiverFactionMods.eliteElements(UnitRoster roster) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      if (u.role == null) {
        return false;
      }
      // unit must be of the SK role type and only 1 unit may have this mod.
      return u.role!.roles.any((r) => r.name == RoleType.SK) &&
          (roster.unitsWithMod(eliteElementsID).length == 0 ||
              (roster.unitsWithMod(eliteElementsID).length == 1 &&
                  u.hasMod(eliteElementsID)));
    };
    return PeaceRiverFactionMods(
        name: 'Elite Elements', requirementCheck: reqCheck, id: eliteElementsID)
      ..addMod<Roles>(
          UnitAttribute.roles, createAddRoleToList(Role(name: RoleType.SO)),
          description: '+SO, One SK unit may change their role to SO');
  }

  /*
    ECM Specialist: One gear or strider per combat group may improve it's ECM to
    ECM+ for 1 TV each.
  */
  factory PeaceRiverFactionMods.ecmSpecialist() {
    final RegExp traitCheck = RegExp(r'^ECM$', caseSensitive: false);
    return PeaceRiverFactionMods(
        name: 'ECM Specialist',
        id: ecmSpecialistID,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(cg != null);
          if (cg!.modCount((ecmSpecialistID)) >= 1 &&
              !u.hasMod(ecmSpecialistID)) {
            return false;
          }

          if (!(u.type == ModelType.Gear || u.type == ModelType.Strider)) {
            return false;
          }

          if (!u.traits.any((trait) => traitCheck.hasMatch(trait.name)) &&
              !u.hasMod(ecmSpecialistID)) {
            return false;
          }
          return true;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(UnitAttribute.traits, (value) {
        var newList = new List<Trait>.from(value);

        final oldTrait =
            newList.firstWhere((t) => t.name.toLowerCase() == 'ecm');
        newList.remove(oldTrait);

        if (!newList.any((t) => t.name.toLowerCase() == 'ecm+')) {
          newList.add(Trait.fromTrait(oldTrait, name: 'ECM+'));
        }

        return newList;
      },
          description: '-ECM, +ECM+, One gear or strider per combat group' +
              ' may improve it\'s ECM to ECM+');
  }

  /*
    Ol’ Trusty: Pit Bulls and Mustangs may increase their GU skill by one for 
    1 TV each.
  */
  factory PeaceRiverFactionMods.olTrustyPOC() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return u.core.frame == 'Pit Bull' || u.core.frame == 'Mustang';
    };
    return PeaceRiverFactionMods(
      name: 'Ol’ Trusty',
      requirementCheck: reqCheck,
      id: olTrustyPOCID,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<int>(
        UnitAttribute.gunnery,
        createSimpleIntMod(-1),
        description: 'Pit Bulls and Mustangs may increase their GU skill by ' +
            'one for 1',
      );
  }

  /*
    Peace Officers: Gears from one combat group may swap their rocket packs for
    the Shield trait. If a gear does not have a rocket pack, then it may instead gain the
    Shield trait for 1 TV.
  */
  factory PeaceRiverFactionMods.peaceOfficers(Unit unit) {
    const weaponCodeToRemove = 'RP';
    final unitRPToRemove = unit
            .attribute<List<Weapon>>(UnitAttribute.mounted_weapons,
                modIDToSkip: peaceOfficersID)
            .any((w) => w.code == weaponCodeToRemove)
        ? unit
            .attribute<List<Weapon>>(
              UnitAttribute.mounted_weapons,
              modIDToSkip: peaceOfficersID,
            )
            .firstWhere((w) => w.code == weaponCodeToRemove)
            .abbreviation
        : '';

    final RequirementCheck reqCheck = (rs, ur, cg, u) {
      assert(cg != null);
      assert(ur != null);

      if (u.type != ModelType.Gear) {
        return false;
      }

      final cgWithMod = ur!.combatGroupsWithMod(peaceOfficersID);
      if (cgWithMod.length > 1) {
        return false;
      }
      return (cgWithMod.isEmpty || cgWithMod.any((c) => c!.name == cg!.name));
    };
    return PeaceRiverFactionMods(
      name: 'Peace Officers',
      requirementCheck: reqCheck,
      id: peaceOfficersID,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<List<Weapon>>(UnitAttribute.mounted_weapons, (value) {
        return new List<Weapon>.from(value)
            .where(
                (existingWeapon) => existingWeapon.code != weaponCodeToRemove)
            .toList();
      }, dynamicDescription: () {
        return '${unitRPToRemove.isNotEmpty ? '-$unitRPToRemove' : ''}';
      })
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(const Trait(name: 'Shield')),
          description: '+Shield');
  }
  /*
    G-SWAT Sniper: One gear with a rifle, per combat group, may purchase the
    Improved Gunnery upgrade for 1 TV each, without being a veteran.
  */
  factory PeaceRiverFactionMods.gSWATSniper() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(rs != null);
      assert(cg != null);
      return ((cg!.modCount(gSWATSniperID) == 0) ||
              (cg.modCount(gSWATSniperID) == 1 && u.hasMod(gSWATSniperID))) &&
          u.weapons.any((w) => w.code == 'RF');
    };
    return PeaceRiverFactionMods(
      name: 'G-SWAT Sniper',
      requirementCheck: reqCheck,
      id: gSWATSniperID,
    )..addMod<int>(UnitAttribute.tv, createSimpleIntMod(0),
        description: 'TV: +0, One gear with a rifle, per combat group,' +
            ' may purchase the Improved Gunnery upgrade for 1 TV each,' +
            ' without being a veteran');
  }
}
