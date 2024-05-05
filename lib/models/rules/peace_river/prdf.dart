import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

const String PRDFSpecialRule1 =
    'Ghost Strike: Models in one combat group using special operations ' +
        'deployment may start the game with hidden tokens if all the models ' +
        'within the combat group are placed in cover relative to at least ' +
        'one enemy model.';

const String _baseRuleId = 'rule::peaceriver::prdf';
const String _ruleOlTrustyId = '$_baseRuleId::10';
const String _ruleThunderFromTheSkyId = '$_baseRuleId::20';
const String _ruleHighTechId = '$_baseRuleId::30';
const String _ruleBestMenAndWomenId = '$_baseRuleId::40';
const String _ruleEliteElementsId = '$_baseRuleId::50';
const String _ruleGhostStrikeId = '$_baseRuleId::60';

const String PRDFDescription =
    'To be a soldier in the PRDF is to know a deep and abiding' +
        'hatred of Earth. CEF agents were responsible for the destruction of' +
        'Peace River City and countless lives. When this information came to ' +
        'light, a sleeping beast awoke. PRDF recruitment has never been ' +
        'better. With the full might of the manufacturing giant of Paxton ' +
        'Arms behind them, the PRDF is a powerful force to face on the ' +
        'battlefield.';

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
  PRDF(super.data)
      : super(
          description: PRDFDescription,
          name: 'Peace River Defense Force',
          specialRules: const [PRDFSpecialRule1],
          subFactionRules: [
            ruleOlTrusty,
            ruleThunderFromTheSky,
            ruleHighTech,
            ruleBestMenAndWomen,
            ruleEliteElements,
            ruleGhostStrike,
          ],
        );
}

final Rule ruleOlTrusty = Rule(
  name: 'Ol’ Trusty',
  id: _ruleOlTrustyId,
  factionMods: (ur, cg, u) => [PeaceRiverFactionMods.olTrusty()],
  description: 'Warriors, Jackals and Spartans may increase their GU skill' +
      ' by one for 1 TV each. This does not include Warrior IVs.',
);

final Rule ruleThunderFromTheSky = Rule(
  name: 'Thunder from the Sky',
  id: _ruleThunderFromTheSkyId,
  factionMods: (ur, cg, u) => [PeaceRiverFactionMods.thunderFromTheSky()],
  description: 'Airstrike counters may increase their GU skill to 3+' +
      ' instead of 4+ for 1 TV each.',
);

final Rule ruleHighTech = Rule(
    name: 'High Tech',
    id: _ruleHighTechId,
    isRoleTypeUnlimited: (unit, target, group, roster) {
      if (group.groupType != GroupType.Primary) {
        return null;
      }
      if (unit.weapons.any((w) =>
          w.traits.any((t) => t.name == 'Advanced' || t.name == 'Guided'))) {
        return true;
      }
      return null;
    },
    description:
        'Models with weapons that have the Advanced or Guided traits have unlimited availability for all primary units.');

final Rule ruleBestMenAndWomen = Rule(
  name: 'The Best Men and Women for the Job',
  id: _ruleBestMenAndWomenId,
  description:
      'One model in each combat group may be selected from the Black Talon model list.',
  isUnitCountWithinLimits: (cg, group, unit) {
    if (unit.faction != FactionType.BlackTalon) {
      return null;
    }
    final bTalonUnits =
        cg.units.where((u) => u.faction == FactionType.BlackTalon);
    if (bTalonUnits.length == 0) {
      return true;
    }
    return bTalonUnits.length == 1 &&
        group.allUnits().where((u) => u == unit).length == 1;
  },
  isRoleTypeUnlimited: (unit, target, group, roster) {
    return unit.faction == FactionType.BlackTalon ? false : null;
  },
  combatGroupOption: () => [
    ruleBestMenAndWomen.buidCombatGroupOption(
      canBeToggled: false,
      initialState: true,
    )
  ],
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'The Best Men and Women for the Job',
      filters: [const UnitFilter(FactionType.BlackTalon)],
      id: _ruleBestMenAndWomenId),
);

final Rule ruleEliteElements = Rule(
    name: 'Elite Elements',
    id: _ruleEliteElementsId,
    factionMods: (ur, cg, u) => [PeaceRiverFactionMods.eliteElements(ur)],
    description: 'One SK unit may change their role to SO.');

final Rule ruleGhostStrike = Rule(
    name: 'Ghost Strike',
    id: _ruleGhostStrikeId,
    description: 'Models in one combat group using special operations' +
        ' deployment may start the game with hidden tokens if all the models' +
        ' within the combat group are placed in cover relative to at least' +
        ' one enemy model.');
