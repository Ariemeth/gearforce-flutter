import 'package:gearforce/models/rules/caprice/caprice.dart';

/*
  LRC - Liberati Resistance Cell
  Caprician corporations have tried for hundreds of years to rid themselves of the Liberati threat.
  However, they are in fact a society within itself, with millions of people. The Liberati cells are only
  one smaller aspect. On the other end of this spectrum is a work force that’s willing to do jobs no
  one else on Caprice will do. And after 30 years of CEF occupation, many have started looking at
  the Liberati as allies instead of adversaries.
  * Heroes of the Resistance: This force may include one duelist per combat group. This force
  cannot use the Independent Operator rule for duelists.
  * Allies: You may select models from Black Talon, Utopia or Eden (pick one) to place into your
  secondary units.
  * Ambush: One combat group may use the special operations deployment regardless of their
  primary unit’s role.
  * Elimination: One objective selected for this force may be the assassinate objective,
  regardless of whether this force has the SO role as one of their primary unit’s roles. Select
  any remaining objectives normally.
*/
class LRC extends Caprice {
  LRC(super.data)
      : super(
          name: 'Liberati Resistance Cell',
          subFactionRules: [],
        );
}
