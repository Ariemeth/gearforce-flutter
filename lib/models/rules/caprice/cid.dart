import 'package:gearforce/models/rules/caprice/caprice.dart';

/*
  CID - Caprice Invasion Detachment
  These units are adapting to combat on Terra Nova quite well. Their experience operating in
  environments on Caprice makes them perfect for urban and mountainous regions on Terra Nova.
  There are unconfirmed reports of CID forces operating in conjunction with Black Talon teams.
  * Commander’s Investment: The force leader’s model may be placed in GP, SK, FS, RC,
  or SO units, regardless of the model’s available roles.
  * Allies: You may select models from the CEF, Black Talon, Utopia or Eden (pick one) to place
  into your secondary units.
  * Melee Specialists: Up to two models per combat group may take this upgrade if they have
  the Brawl:1 trait. Upgrade their Brawl:1 trait to Brawl:2 for 1 TV each.
  * Conscription: You may add the Conscript trait to any non-commander, non-veteran and
  non-duelist in the force if they do not already possess the trait. Reduce the TV of these
  models by 1 TV per action.
*/
class CID extends Caprice {
  CID(super.data)
      : super(
          name: 'Caprice Invasion Detachment',
          subFactionRules: [],
        );
}
