import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

/*
  All the models in the Peace River Model List can be used in any of the sub-lists below. There are also models in the
  Universal Model List that may be selected as well.
  All Peace River forces have the following rule:
  * E-pex: One Peace River model within each combat group may increase its EW skill by one for 1 TV each.
  * Warrior Elite: Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a
  H/S of 4/2, an EW skill of 4+, and the Agile trait.
  * Crisis Responders: Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG
  for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.
  * Laser Tech: Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each.
  These weapons receive the Advanced trait.
  * Architects: The duelist for this force may use a Peace River strider.
*/
class PeaceRiver extends RuleSet {
  final List<Unit> _units = [];
  // TODO This constructor code is generic and could probably be moved into the
  // Ruleset constructor.
  PeaceRiver(super.data, {super.specialRules}) {
    this.availableSpecialFilters().forEach((specialUnitFilter) {
      print(specialUnitFilter.text);
      data
          .getUnitsByFilter(
        filters: specialUnitFilter.filters,
        roleFilter: null,
        characterFilters: null,
      )
          .forEach((uc) {
        if (_units.any((u) => u.core.name == uc.name)) {
          _units.firstWhere((u) => u.core.name == uc.name)
            ..addTag(specialUnitFilter.text);
        } else {
          _units.add(Unit(core: uc)..addTag(specialUnitFilter.text));
        }
      });
    });
  }

  // TODO this function is generic and could probably be moved into the Ruleset
  // class and not need to be overridden in most cases.
  @override
  List<Unit> availableUnits({
    List<RoleType>? role,
    List<String>? characterFilters,
    SpecialUnitFilter? specialUnitFilter,
  }) {
    List<Unit> results = _units.toList();

    if (specialUnitFilter != null) {
      results = results.where((u) => u.hasTag(specialUnitFilter.text)).toList();
    }

    if (role != null && role.isNotEmpty) {
      results = results.where((u) {
        if (u.role != null) {
          return u.role!.includesRole(role);
        }
        return false;
      }).toList();
    }

    if (characterFilters != null) {
      results =
          results.where((u) => u.core.contains(characterFilters)).toList();
    }

    return results;
  }

  @override
  List<SpecialUnitFilter> availableSpecialFilters() {
    return [
      const SpecialUnitFilter(
        text: tagCore,
        filters: const [
          const UnitFilter(FactionType.PeaceRiver),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
    ];
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster, CombatGroup cg, Unit u) {
    return [
      PeaceRiverFactionMods.e_pex(),
      PeaceRiverFactionMods.warriorElite(),
      PeaceRiverFactionMods.crisisResponders(u),
      PeaceRiverFactionMods.laserTech(u),
    ];
  }

  @override
  bool duelistCheck(UnitRoster roster, Unit u) {
    /*
    Architects: The duelist for this force may use a Peace River strider.
    */
    if (!(u.type == ModelType.Gear || u.type == ModelType.Strider)) {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }
}
