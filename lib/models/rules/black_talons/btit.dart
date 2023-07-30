import 'package:gearforce/models/rules/black_talons/black_talons.dart';

/*
  BTIT - Black Talon Insertion Team
  A successful operation for BTITs is an operation that is over before the defenders even
  know what they’re fighting. BTITs have a diverse range of specially trained operatives that
  allow them to perform an assortment of missions including; unconventional warfare,
  foreign internal defense, direct action, counter-insurgency, special reconnaissance,
  counter-terrorism, information operations, counterproliferation of weapons of mass
  destruction, security force assistance and even manhunts.
  * Allies: You may select models from Caprice, Utopia or Eden (may include a mix).
  Commanders must choose a Black Talon model.
  * Asymmetry: Any combat group that can use the airdrop special deployment may
  use the special operations deployment instead.
  * Radio Blackout: One model per combat group with the ECM, or ECM+ trait may
  improve its EW skill by one for 1 TV each.
  * The Talons: Dark Jaguars and Dark Mambas may add +1 action for 2 TV each.
*/
class BTIT extends BlackTalons {
  BTIT(super.data)
      : super(
          name: 'Black Talon Insertion Team',
          subFactionRules: [],
        );
}
