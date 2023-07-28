import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/north/north.dart';

const String _baseRuleId = 'rule::nlc';

/*
NLC - Northern Lights Confederacy
The home of the Revisionist church, the most powerful religious organization on
Terra Nova, many of the members of the Norlight armed forces see their role as a
calling instead of just a job or a mission. Foremost among these are the chaplains
and warrior monks who leverage the power of gears and formidable martial skills
with their chosen weapon, the fighting staff. Their skill and courage are powerful
inspirations to all soldiers.
* Chaplain: You may select one non-commander gear to be a Battle Chaplain
(BC) for 2 TV. The BC becomes an officer and can take the place as a third
commander within a combat group. The BC comes with 1 CP and can use it to
give orders to any model or combat group in the force. BCs will only be used
to roll for initiative if there are no other commanders in the force. When there
are no other commanders in the force, the BC will roll with a 5+ initiative skill.
* Warrior Monks: Commanders and veterans, with the Hands trait, may purchase
a fighting staff upgrade for 1 TV each. If a model takes this upgrade, then it will
also receive the Brawl:1 trait or increase its Brawl:X trait by one. A fighting staff
is a MVB that has the React and Reach:2 traits.
* The Pride: You may select 2 gears in this force to become duelists. All duelists
must take the Warrior Monks upgrade.
* Devoted: When the chaplain is targeted by a direct or indirect attack, a friendly
monk (model with a fighting staff) within 3 inches may choose to be the target
instead. Resolve the attack normally against the monk as if the monk was in the
chaplain’s position. This may result in the monk being the target of the attack
twice in the case of Split or AOE weapons. Only one monk may be targeted in
this way per attack.
*/
class NLC extends North {
  NLC(super.data)
      : super(
          name: 'Northern Lights Confederacy',
          subFactionRules: [
            rule1,
            rule2,
            rule3,
            rule4,
          ],
        );
}

final FactionRule rule1 = FactionRule(
  name: '',
  id: '$_baseRuleId::rule1',
  description: '',
);

final FactionRule rule2 = FactionRule(
  name: '',
  id: '$_baseRuleId::rule2',
  description: '',
);

final FactionRule rule3 = FactionRule(
  name: '',
  id: '$_baseRuleId::rule3',
  description: '',
);

final FactionRule rule4 = FactionRule(
  name: '',
  id: '$_baseRuleId::rule4',
  description: '',
);
