import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/black_talons/black_talons.dart';
import 'package:gearforce/models/traits/trait.dart';

const String _baseRuleId = 'rule::blackTalon::btat';
const String _ruleShadowWarriorsId = '$_baseRuleId::10';
const String _ruleBreachersId = '$_baseRuleId::20';
const String _ruleDropsOfDarknessId = '$_baseRuleId::30';

/*
  BTAT - Black Talon Assault Team
  BTATs are some of the largest Black Talon elements in existance. Their missions also
  have some of the highest casualty rates amongst any of the Black Talon mission
  profiles. However, capturing large transports, supply ships and capital ships is of
  extreme importance. Successful missions are not only responsible for taking away
  highly valuable assets from the enemy, they also acquire those same assets to be used
  by the Terra Novan forces.
  * Shadow Warriors: Models that start the game in area terrain gain a hidden token at
  the start of the first round.
  * Breachers: Shaped Explosives (SE) for models in this force do not come with the
  Brawl:-1 trait.
  * Drops of Darkness: If the airdrop special deployment option is used, models in this
  force will roll for a target number of 3+ instead of 4+.
*/
class BTAT extends BlackTalons {
  BTAT(super.data)
      : super(
          name: 'Black Talon Assault Team',
          subFactionRules: [
            ruleShadowWarriors,
            ruleBreachers,
            ruleDropsOfDarkness
          ],
        );
}

final FactionRule ruleShadowWarriors = FactionRule(
  name: 'Shadow Warriors',
  id: _ruleShadowWarriorsId,
  description: 'Models that start the game in area terrain gain a hidden' +
      ' token at the start of the first round.',
);

final FactionRule ruleBreachers = FactionRule(
  name: 'Breachers',
  id: _ruleBreachersId,
  modifyWeapon: (weapons) {
    weapons.where((w) => w.code == 'SE').forEach((w) {
      w.baseTraits.removeWhere((t) => Trait.Brawl(-1).isSame(t));
    });
  },
  description: 'Shaped Explosives (SE) for models in this force do not come' +
      ' with the Brawl:-1 trait.',
);

final FactionRule ruleDropsOfDarkness = FactionRule(
  name: 'Drops of Darkness',
  id: _ruleDropsOfDarknessId,
  description: 'If the airdrop special deployment option is used, models in' +
      ' this force will roll for a target number of 3+ instead of 4+.',
);
