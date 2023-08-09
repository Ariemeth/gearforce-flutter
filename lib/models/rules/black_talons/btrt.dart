import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/black_talon.dart';
import 'package:gearforce/models/rules/black_talons/black_talons.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;

const String _baseRuleId = 'rule::btrt';
const String _ruleTheUnseenId = '$_baseRuleId::10';
const String _ruleOperatorsId = '$_baseRuleId::20';
const String _ruleCatchThemSleepingId = '$_baseRuleId::30';

/*
  BTRT - Black Talon Recon Team
  The recon teams are trained to use more than just their weapons to fight. They use
  the environment itself. Sent out ahead of other Black Talon teams, the recon teams are
  expected to find the enemy and eliminate keystone components such as command units
  and important communications facilities. They also do their best to sabotage forces that
  would be used as reactionary elements to larger Talon strikes.
  * ECM Specialist: One gear or strider per combat group may improve its ECM to
  ECM+ for 1 TV each.
  * Operators: You may select 2 gears in this force to become duelists.
  * The Unseen: Dark Cheetahs and Dark Skirmishers may add +1 action for 2 TV each.
  * Catch Them Sleeping: This force may forgo all airdrop special deployments
*/
class BTRT extends BlackTalons {
  BTRT(super.data)
      : super(
          name: 'Black Talon Recon Team',
          subFactionRules: [
            poc.ruleECMSpecialist,
            ruleOperators,
            ruleTheUnseen,
            ruleCatchThemSleeping,
          ],
        );
}

final FactionRule ruleOperators = FactionRule(
  name: 'Operators',
  id: _ruleOperatorsId,
  duelistMaxNumberOverride: (roster, cg, u) => 2,
  description: 'You may select 2 gears in this force to become duelists.',
);

final FactionRule ruleTheUnseen = FactionRule(
  name: 'The Unseen',
  id: _ruleTheUnseenId,
  factionMods: (ur, cg, u) => [BlackTalonMods.theUnseen()],
  description:
      'Dark Cheetahs and Dark Skirmishers may add +1 action for 2 TV each.',
);

final FactionRule ruleCatchThemSleeping = FactionRule(
  name: 'Catch Them Sleeping',
  id: _ruleCatchThemSleepingId,
  description: 'This force may forgo all airdrop special deployments to allow' +
      ' any or all models to use the recon special deployment.',
);
