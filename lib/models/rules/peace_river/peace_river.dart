import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_upgrades.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
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
  PeaceRiver(super.data, {super.specialRules});

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
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
  List<FactionUpgrade> availableFactionUpgrades() => [
        const FactionUpgrade(
            name: 'E-pex',
            description:
                'One Peace River model within each combat group may increase its EW skill by one for 1 TV each.'),
        const FactionUpgrade(
            name: 'Warrior Elite',
            description:
                'Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a H/S of 4/2, an EW skill of 4+, and the Agile trait.'),
        const FactionUpgrade(
            name: 'Crisis Responders',
            description:
                'Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.'),
        const FactionUpgrade(
            name: 'Laser Tech',
            description:
                'Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each. These weapons receive the Advanced trait.'),
        const FactionUpgrade(
            name: 'Architects',
            description:
                'The duelist for this force may use a Peace River strider.'),
      ];

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
