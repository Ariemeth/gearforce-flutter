import 'package:gearforce/models/rules/nucoal/nucoal.dart';

/*
  KADA - Khayr ad-Din
  The arena city is a contradiction in terms. While the city itself is seedy and unsafe, there lives a
  deeper sense of honor amongst some within its walls. Warriors who normally face off against each
  other in glorious arena combat, to be the best, will also fight together to protect their city.
  * Heroes of the Arena: This force may include any number of duelists. Duelists may choose their
  gears from the North, South, Peace River, and NuCoal. This force cannot use the Independent
  Operator rule for duelists.
  * The Brute: One duelist may select a strider from the North, South, Peace River, or NuCoal.
  * Challengers: One objective selected for this force may be the assassinate objective, regardless
  of whether this force has the SO role as one of their primary roles. Select any remaining
  objectives normally.
*/
class KADA extends NuCoal {
  KADA(super.data)
      : super(
          name: 'Khayr ad-Din',
          subFactionRules: [],
        );
}
