import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/unit/command.dart';

const String _baseRuleId = 'rule::north::nlc';
const String _ruleChaplainId = '$_baseRuleId::10';
const String _ruleWarriorMonksId = '$_baseRuleId::20';
const String _ruleThePrideId = '$_baseRuleId::30';
const String _ruleDevotedId = '$_baseRuleId::40';

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
            ruleChaplain,
            ruleWarriorMonks,
            ruleThePride,
            ruleDevoted,
          ],
        );
}

final FactionRule ruleChaplain = FactionRule(
  name: 'Chaplain',
  id: _ruleChaplainId,
  factionMods: (ur, cg, u) => [NorthernFactionMods.chaplain()],
  availableCommandLevelOverride: (u) {
    if (!u.hasMod(chaplainID)) {
      return null;
    }
    return [CommandLevel.bc];
  },
  description: 'You may select one non-commander gear to be a Battle Chaplain' +
      ' (BC) for 2 TV. The BC becomes an officer and can take the place as a' +
      ' thid commander within a combat group. The BC comes with 1 CP and can' +
      ' use it to give orders to any model or combat group in the force. BCs' +
      ' will only be used to roll for initiative if there are no other' +
      ' commanders in the force. When there are no other commanders in the' +
      ' force, the BC will roll with a 5+ initiative skill.',
);

final FactionRule ruleWarriorMonks = FactionRule(
  name: 'Warrior Monks',
  id: _ruleWarriorMonksId,
  factionMods: (ur, cg, u) => [NorthernFactionMods.warriorMonks(u)],
  description: 'Commanders and veterans, with the Hands trait, may purchase' +
      ' a fighting staff upgrade for 1 TV each. If a model takes this upgrade,' +
      ' then it will also receive the Brawl:1 trait or increase its Brawl:X' +
      ' trait by one. A fighting staff is a MVB that has the React and' +
      ' Reach:2 traits.',
);

final FactionRule ruleThePride = FactionRule(
  name: 'The Pride',
  id: _ruleThePrideId,
  duelistMaxNumberOverride: (roster, cg, u) => 2,
  onModAdded: (unit, modId) {
    if (modId != duelistId) {
      return;
    }
    unit.addUnitMod(NorthernFactionMods.warriorMonks(unit));
  },
  onModRemoved: (unit, modId) {
    if (modId != warriorMonksID || !unit.isDuelist) {
      return;
    }
    unit.addUnitMod(NorthernFactionMods.warriorMonks(unit));
  },
  description: 'You may select 2 gears in this force to become duelists. All' +
      'duelists must take the Warrior Monks upgrade.',
);

final FactionRule ruleDevoted = FactionRule(
  name: 'Devoted',
  id: _ruleDevotedId,
  description: 'When the chaplain is targeted by a direct or indirect attack,' +
      ' a friendly monk (model with a fighting staff) within 3 inches may' +
      ' choose to be the targetinstead. Resolve the attack normally against' +
      'the monk as if the monk was in the chaplain’s position. This may' +
      'result in the monk being the target of the attack twice in the case' +
      ' of Split or AOE weapons. Only one monk may be targeted in this' +
      ' way per attack.',
);
