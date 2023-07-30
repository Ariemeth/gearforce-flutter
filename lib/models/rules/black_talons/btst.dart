import 'package:gearforce/models/rules/black_talons/black_talons.dart';

/*
  BTST - Black Talon Strike Team
  As BTSTs specialize in asymmetric warfare on the conventional Terra Novan battlefield,
  they are frequently found operating with collocated forces. BTST operatives are trained
  in the many intricacies of all the Terra Novan militaries. They know their capabilities,
  policies and doctrines like the back of their hand. This enables them to speak to any
  Terra Novan force in their native lingo and procedures. Even Badland forces have been
  known to take part in BTST operations.
  * Allies: You may select models from North, South, Peace River and NuCoal (may
  include a mix). Commanders must choose a Black Talon model.
  * Best and Brightest: Any number of allies may purchase the Vet trait without
  counting against the veteran limitations.
  * Showoffs: One gear in each combat group may
*/
class BTST extends BlackTalons {
  BTST(super.data)
      : super(
          name: 'Black Talon Strike Team',
          subFactionRules: [],
        );
}
