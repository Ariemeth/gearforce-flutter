import 'package:gearforce/models/rules/south/south.dart';

/*
  ESE - Eastern Sun Emirates
  Perpetually in turmoil, the various Emirates maintain armed forces more to continue
  the bid for overall power than to protect against outside invaders. War in the
  Emirates is an extension of politics and allies one week will turn on each other the
  next. With their need for replacements far outstripping their local supply, the Emirs
  must make deals and purchases from any arms manufacturer who will see them.
  Failure in the Emirates is met with harsh repercussions, but success leads to a life
  of luxury and renown.
  * Local Manufacturing: Iguanas may be placed in GP, SK, FS, RC and SO units.
  * Personal Escort: The force leader’s combat group may include a duelist in
  addition to any other duelist this force may have. This duelist model may be
  chosen from the North, South, Peace River or NuCoal model lists and must
  follow all normal duelist rules.
  * Allies: This force may include models from the North, Peace River or NuCoal
  (pick one). Models that come with the Vet trait on their profile cannot be
  purchased.
*/
class ESE extends South {
  ESE(super.data)
      : super(
          name: 'Eastern Sun Emirates',
          subFactionRules: [],
        );
}
