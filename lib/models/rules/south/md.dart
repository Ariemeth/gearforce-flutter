import 'package:gearforce/models/rules/south/south.dart';

/*
  MD - Mekong Dominion
  Powerful economically, the Dominion is known to prefer targeted actions or
  subterfuge instead of face-to-face confrontations. Corporate interests are
  paramount, and harsh working conditions have resulted in several famous worker
  revolts. The elite military police are often supplemented with mercenary and regular
  army units to provide additional brawn and motivation. Once they are tasked with a
  mission, the officers reinforce their corporate backers’ interests with gusto.
  * Mekongese Excellence: All models in the force leader’s combat group may
  purchase the Vet trait. This does not count against the veteran limits.
  * Samurai Spirit: Commanders and veterans, with the Hands trait, may purchase
  the vibro-katana upgrade for 1 TV each. If a model takes this upgrade, it will also
  receive the Brawl:1 trait or increase its Brawl:X trait by one. A vibro-katana is a
  LVB (React, Precise).
  * Metsuke: MP models within one combat group may purchase the Shield+ trait
  for 1 TV each. The Shield+ trait works just like a Shield trait but also adds +1D6
  to defensive rolls from attacks originating from the front arc. The Shield+ trait
  may not be stacked with cover modifiers.
  * Mercenary Contract: One combat group in this force may be made with models
  from North, South, Peace
*/
class MD extends South {
  MD(super.data)
      : super(
          name: 'Mekong Dominion',
          subFactionRules: [],
        );
}
