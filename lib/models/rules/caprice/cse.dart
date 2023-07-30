import 'package:gearforce/models/rules/caprice/caprice.dart';

/*
  CSE - Corporate Security Element
  The major corporations regard their security elements much like any nation would regard their
  military. With assets from people, equipment and even secret research, the corporations have
  much to protect. Shadow wars have been known to sprout up between competing corporations.
  * The Best Money Can Buy: Two combat groups may be designated as veteran combat groups
  instead of the normal limit of one combat group.
  * Allies: You may select models from the CEF, Utopia or Eden (pick one) to place into your
  secondary units.
  * Appropriations: This force may have one primary unit composed of CEF frames, Utopian
  APEs or Eden golems. The CEF Minerva upgrade cannot be selected. These models may be
  mixed with Caprician models or each other.
  * Acquisitions: One objective selected for this force may be the raid objective, regardless of
  whether this force has the SO role as one of their primary unit’s roles. Select any remaining
*/
class CSE extends Caprice {
  CSE(super.data)
      : super(
          name: 'Corporate Security Element',
          subFactionRules: [],
        );
}
