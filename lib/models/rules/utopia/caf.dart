import 'package:gearforce/models/rules/utopia/utopia.dart';

/*
  CAF - Combined Armiger Force
  Utopia uses automatons to multiply their force’s limited human numbers. Over
  time Kogland and Steelgate have developed impressive synergy on the battlefield
  using human piloted armigers to lead N-KIDUs. Each N-KIDU develops a pseudopersonality
  that helps scientists on Utopia decide which task they would be best
  suited for. Stealthy personalities go into Commando Troupes while Support N-KIDUs
  usually have a penchant for excessive force.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the
  force without counting against the veteran limitations.
  * Allies: You may select models from the CEF, Caprice or Eden (pick one) for
  secondary units.
  * Combined Arms: You may select one of the below for each combat group.
  Commando Troupe, Recce Troupe, Support Troupe or Gilgamesh Troupe.
  Each set of rules applies to one combat group. You may select the same Troupe type
  to be used for more than one combat group.
  Recce Troupe:
  * Quiet Death: Recce Armigers may purchase the React+ trait for 1 TV each.
  * Silent Assault: Recce N-KIDUs may increase their EW skill by one for 1 TV each.
  Support Troupe:
  * Wrath of the Demigods: Each Support Armiger may upgrade their MRP with
  both the Precise trait and the Guided trait for 1 TV total.
  * Not So Silent Assault: Support N-KIDUs may increase their GU skill by one for
  1 TV each.
  Commando Troupe:
  * Who Dares: Commando Armigers may add +1 action for 2 TV each.
  Gilgamesh Troupe:
  * The Divine Brother: This combat group must use a Gilgamesh. The Gilgamesh
  must be the force leader.
  * The Brother’s Friends: The Gilgamesh may spend 1 CP to issue a special order
  that removes the Conscript trait from all N-KIDUs within any one combat group
  during their activation.
*/

class CAF extends Utopia {
  CAF(super.data)
      : super(
          name: 'Combined Armiger Force',
          subFactionRules: [],
        );
}
