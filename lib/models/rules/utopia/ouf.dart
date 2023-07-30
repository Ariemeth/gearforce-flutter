import 'package:gearforce/models/rules/utopia/utopia.dart';

/*
  OUF – Other Utopian Forces
  Other places on Utopia are not as comfortable under CEF control. The Greenway
  Alliance and the independent states have benefitted the least from military contracts
  and they are becoming more vocal about their discontent. Whispers of revolt are
  sometimes heard but significant actions have yet to be taken.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the
  force without counting against the veteran limitations.
  * Greenway Caustics: Models in one combat group may add the Corrosion trait
  to, and remove the AP trait from, their rocket packs for 0 TV.
  * Allies: You may select models from the CEF, Black Talon, Caprice or Eden (pick
  one) for secondary units.
  * NAI Experiments: This force may include CEF frames regardless of any allies
  chosen. CEF frames may add the Conscript trait for -1 TV. The CEF’s Minerva
  and Advanced Interface Network upgrades cannot be selected. Commanders,
  veterans and duelists may not receive the Conscript trait.
  * Frank-N-KIDU: One N-KIDU per combat group may purchase one veteran or
  duelist upgrade without being a veteran or a duelist.
*/

class OUF extends Utopia {
  OUF(super.data)
      : super(
          name: 'Other Utopian Forces',
          subFactionRules: [],
        );
}
