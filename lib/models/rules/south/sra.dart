import 'package:gearforce/models/rules/south/south.dart';

/*
  SRA - Southern Republic Army
  The SRA is a multifaceted professional army of the highest caliber. It is the standing
  army of the highly expansionistic and imperialistic Southern Republic. As such it is
  called on to deal with potential enemies outside and inside its frontiers. The SRA
  is considered one of the strongest and better equipped forces in Terra Nova and
  considers itself to be superior in all ways, culturally and militarily. Hierarchy is very
  important to the SRA and political clout plays a large part of unit selection and
  equipment or mission assignment.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the
  force without counting against the veteran limitations.
  * Pride of the South: Commanders and veterans, with the Hands trait, may
  purchase the vibro-rapier upgrade for 1 TV each. If a model takes this upgrade,
  it will also receive the Brawl:1 trait or increase its Brawl:X trait by one. A vibrorapier
  is a LVB (React, Precise).
  * Assault Troops: Infantry and cavalry may purchase the Brawler veteran upgrade
  without being veterans.
  * Political Officer: You may select one non-commander to be a Political Officer
  (PO) for 2 TV. The PO becomes an officer and can take the place as a third
  commander within a combat group. The PO comes with 1 CP and can use it to
  give orders to any model or combat group in the force. POs will only be used
  to roll for initiative if there are no other commanders in the force. When there
  are no other commanders in the force, the PO will roll with a 5+ initiative skill.
  * Well Funded: Two models in each combat group may purchase one veteran
  upgrade without making them veterans.
*/
class SRA extends South {
  SRA(super.data)
      : super(
          name: 'Southern Republic Army',
          subFactionRules: [],
        );
}
