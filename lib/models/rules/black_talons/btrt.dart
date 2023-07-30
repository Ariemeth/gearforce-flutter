import 'package:gearforce/models/rules/black_talons/black_talons.dart';

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
          subFactionRules: [],
        );
}
