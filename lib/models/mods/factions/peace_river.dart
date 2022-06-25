import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/factions/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const e_pexID = 'faction: peace river - 10';
const warriorEliteID = 'faction: peace river - 20';
const crisisRespondersID = 'faction: peace river - 30';
const laserTechID = 'faction: peace river - 40';
const architectsID = 'faction: peace river - 50';

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
      ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S: 4/2')
      ..addMod(UnitAttribute.structure, createSetIntMod(2))
      ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW: 4')
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(const Trait(name: 'Agile')),
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
      });
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
      })
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
}
