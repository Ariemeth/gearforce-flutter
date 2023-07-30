import 'package:gearforce/models/rules/south/south.dart';

/*
  FHA - Free Humanist Alliance
  While eight percent of the original Humanists were able to escape to NuCoal after a
  failed revolt against the Republic, the Humanists that could not get out were brutally
  taken over and occupied, loosing all autonomy to self-govern. In the aftermath of
  the Southern Republic civil war, the Humanists were given back their autonomy
  as a gesture of good will. This new Humanist Alliance is called the Free Humanist
  Alliance. The ties between the Free Humanist Alliance within the South and the
  Humanist Alliance in NuCoal are generally friendly.
  * Wrote the Book: Two models per combat group may purchase the Vet trait
  without counting against the veteran limitations.
  * Experts: Veteran Sagittariuses, veteran Fire Dragons and veteran Hetairoi may
  purchase the Stable and/or Precise duelist upgrades, without having to be
  duelists.
  * Conscription: You may add the Conscript trait to any non-commander,
  non-veteran and non-duelist in the force if they do not already possess the trait.
  Reduce the TV of these models by 1 TV per action.
  * Allies: You may select models from NuCoal for secondary units. GREL models
  may not be selected.
*/
class FHA extends South {
  FHA(super.data)
      : super(
          name: 'Free Humanist Alliance',
          subFactionRules: [],
        );
}
