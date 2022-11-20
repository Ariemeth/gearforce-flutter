import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

const PRDFSpecialRule1 =
    'Ghost Strike: Models in one combat group using special operations ' +
        'deployment may start the game with hidden tokens if all the models ' +
        'within the combat group are placed in cover relative to at least ' +
        'one enemy model.';

const PRDFBestMenAndWomenSpecial = 'The Best Men and Women for the Job';

final ruleOlTrusty = FactionRule(
    name: 'Ol\' Trusty',
    id: 'rule::prdf::oltrusty',
    description:
        'Warriors, Jackals and Spartans may increase their GU skill by one for 1 TV each. This does not include Warrior IVs.');
final ruleThunderFromTheSky = FactionRule(
    name: 'Thunder from the Sky',
    id: 'rule::prdf::thunderFromTheSky',
    description:
        'irstrike counters may increase their GU skill to 3+ instead of 4+ for 1 TV each.');
final ruleHighTech = FactionRule(
    name: 'High Tech',
    id: 'rule::prdf::highTech',
    description:
        'Models with weapons that have the Advanced or Guided traits have unlimited availability for all primary units.');
final ruleBestMenAndWomen = FactionRule(
    name: 'The Best Men and Women for the Job',
    id: 'rule::prdf::theBestMenAndWomenForTheJob',
    description:
        'One model in each combat group may be selected from the Black Talon model list.');
final ruleEliteElements = FactionRule(
    name: 'Elite Elements',
    id: 'rule::prdf::eliteElements',
    description: 'One SK unit may change their role to SO.');
final ruleGhostStrike = FactionRule(
    name: 'Ghost Strike',
    id: 'rule::prdf::ghostStrike',
    description:
        'Models in one combat group using special operations deployment may start the game with hidden tokens if all the models within the combat group are placed in cover relative to at least one enemy model.');

/*
PRDF - Peace River Defense Force
To be a soldier in the PRDF is to know a deep and abiding hatred of Earth. CEF agents
were responsible for the destruction of Peace River City and countless lives. When this
information came to light, a sleeping beast awoke. PRDF recruitment has never been
better. With the full might of the manufacturing giant of Paxton Arms behind them, the
PRDF is a powerful force to face on the battlefield.
* Ol’ Trusty: Warriors, Jackals and Spartans may increase their GU skill by one for 1
TV each. This does not include Warrior IVs.
* Thunder from the Sky: Airstrike counters may increase their GU skill to 3+ instead
of 4+ for 1 TV each.
* High Tech: Models with weapons that have the Advanced or Guided traits have
unlimited availability for all primary units.
* The Best Men and Women for the Job: One model in each combat group may be
selected from the Black Talon model list.
* Elite Elements: One SK unit may change their role to SO.
* Ghost Strike: Models in one combat group using special operations deployment
may start the game with hidden tokens if all the models within the combat group
are placed in cover relative to at least one enemy model.
*/

class PRDF extends PeaceRiver {
  PRDF(super.data) : super(specialRules: const [PRDFSpecialRule1]);

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return super.availableFactionMods(ur, cg, u)
      ..addAll([
        PeaceRiverFactionMods.olTrusty(),
        PeaceRiverFactionMods.thunderFromTheSky(),
        PeaceRiverFactionMods.eliteElements(ur),
      ]);
  }

  @override
  List<FactionRule> availableSubFactionUpgrades() {
    return [
      ruleOlTrusty,
      ruleThunderFromTheSky,
      ruleHighTech,
      ruleBestMenAndWomen,
      ruleEliteElements,
      ruleGhostStrike,
    ];
  }

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    return super.availableUnitFilters()
      ..addAll(
        [
          const SpecialUnitFilter(
            text: PRDFBestMenAndWomenSpecial,
            filters: [
              const UnitFilter(FactionType.BlackTalon),
            ],
          ),
        ],
      );
  }

  @override
  bool isUnitCountWithinLimits(CombatGroup cg, Group group, Unit unit) {
    /*
       The Best Men and Women for the Job: One model in each combat group may
       be selected from the Black Talon model list.
    */
    if (unit.hasTag(PRDFBestMenAndWomenSpecial)) {
      return cg.units
              .where((u) => u.hasTag(PRDFBestMenAndWomenSpecial))
              .length ==
          0;
    }

    return super.isUnitCountWithinLimits(cg, group, unit);
  }

  @override
  bool isRoleTypeUnlimited(Unit unit, RoleType target, Group group) {
    if (super.isRoleTypeUnlimited(unit, target, group)) {
      return true;
    }

    /*
      High Tech: Models with weapons that have the Advanced or Guided traits
      have unlimited availability for all primary units.
    */
    return group.groupType == GroupType.Primary &&
        (unit.reactWeapons.any((w) => w.traits
                .any((t) => t.name == 'Advanced' || t.name == 'Guided')) ||
            unit.mountedWeapons.any((w) => w.traits
                .any((t) => t.name == 'Advanced' || t.name == 'Guided')));
  }
}
