import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';

const PRDFSpecialRule1 =
    'Ghost Strike: Models in one combat group using special operations ' +
        'deployment may start the game with hidden tokens if all the models ' +
        'within the combat group are placed in cover relative to at least ' +
        'one enemy model.';

const _ruleBestMenAndWomenName = 'The Best Men and Women for the Job';
const _ruleBestMenAndWomenID = '$_baseRuleId::bestmenandwomenforthejob';

const String _baseRuleId = 'rule::prdf';

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
  PRDF(super.data) : super(specialRules: const [PRDFSpecialRule1]) {
    ruleOlTrusty..addListener(() => notifyListeners());
    ruleThunderFromTheSky..addListener(() => notifyListeners());
    ruleHighTech..addListener(() => notifyListeners());
    ruleBestMenAndWomen..addListener(() => notifyListeners());
    ruleEliteElements..addListener(() => notifyListeners());
    ruleGhostStrike..addListener(() => notifyListeners());
  }

  @override
  List<FactionRule> availableSubFactionRules() {
    return [
      ruleOlTrusty,
      ruleThunderFromTheSky,
      ruleHighTech,
      ruleBestMenAndWomen,
      ruleEliteElements,
      ruleGhostStrike,
    ];
  }
}

const filterBestMenAndWomen = SpecialUnitFilter(
  text: _ruleBestMenAndWomenName,
  id: _ruleBestMenAndWomenID,
  filters: [
    const UnitFilter(FactionType.BlackTalon),
  ],
);

final ruleOlTrusty = FactionRule(
    name: 'Ol\' Trusty',
    id: '$_baseRuleId::oltrusty',
    description:
        'Warriors, Jackals and Spartans may increase their GU skill by one for 1 TV each. This does not include Warrior IVs.');
final ruleThunderFromTheSky = FactionRule(
    name: 'Thunder from the Sky',
    id: '$_baseRuleId::thunderFromTheSky',
    description:
        'Airstrike counters may increase their GU skill to 3+ instead of 4+ for 1 TV each.');
final ruleHighTech = FactionRule(
    name: 'High Tech',
    id: '$_baseRuleId::highTech',
    isRoleTypeUnlimited: (unit, target, group, roster) {
      return group.groupType == GroupType.Primary &&
          (unit.reactWeapons.any((w) => w.traits
                  .any((t) => t.name == 'Advanced' || t.name == 'Guided')) ||
              unit.mountedWeapons.any((w) => w.traits
                  .any((t) => t.name == 'Advanced' || t.name == 'Guided')));
    },
    description:
        'Models with weapons that have the Advanced or Guided traits have unlimited availability for all primary units.');
final ruleBestMenAndWomen = FactionRule(
  name: _ruleBestMenAndWomenName,
  id: '$_ruleBestMenAndWomenID',
  description:
      'One model in each combat group may be selected from the Black Talon model list.',
  isUnitCountWithinLimits: (cg, group, unit) {
    return cg.units.where((u) => u.hasTag(ruleBestMenAndWomen.id)).length == 0;
  },
);
final ruleEliteElements = FactionRule(
    name: 'Elite Elements',
    id: '$_baseRuleId::eliteElements',
    description: 'One SK unit may change their role to SO.');
final ruleGhostStrike = FactionRule(
    name: 'Ghost Strike',
    id: '$_baseRuleId::ghostStrike',
    description:
        'Models in one combat group using special operations deployment may start the game with hidden tokens if all the models within the combat group are placed in cover relative to at least one enemy model.');
