import 'package:gearforce/models/rules/eden/eden.dart';

/*
  AEF – Ad-Hoc Edenite Force
  Ad-Hoc Edenite Forces represent the many varied types of militias and privateer militant
  forces on Eden. Whether they are privateers performing piracy or even anti-piracy
  operations, or whether they are conscripted militias for major cities, these forces contrast
  dramatically from each other. More than a few are suspected of taking part in resistance
  operations against CEF forces.
  * Improviso: Select one upgrade option from EIF or ENH.
  * Self-Made: Veteran golems may purchase the following duelist upgrades without
  being duelists; Duelist Melee Upgrade, Dual Melee Weapons and Shield.
  * Water-Born: Infantry that receive the Frogmen upgrade also receive a GU of 3+.
  * Freeblade: Constable and Man at Arm Golems may take the Conscript trait for -1 TV.
  Commanders, veterans and duelists may not take this upgrade.
*/
class AEF extends Eden {
  AEF(super.data)
      : super(
          name: 'Ad-Hoc Edenite Force',
          subFactionRules: [],
        );
}
