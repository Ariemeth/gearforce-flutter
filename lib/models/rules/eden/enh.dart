import 'package:gearforce/models/rules/eden/eden.dart';

/*
  ENH - Edenite Noble Houses
  “Protect the innocent, shield thy lord, honor thine ancestors.” - Code Chivalei, Chapter 1,
  Verse 4. While the CEF invasion was successful, they suffered unexpected losses at the
  hands of some noble houses. Of note, the Fasaim Knights were never truly defeated. They
  merely yielded for the sake of Edenites everywhere.
  * Champions: This force may include one duelist per combat group. This force cannot
  use the Independent Operator rule for duelists.
  * Ishara: Golems may have their melee weapon upgraded to a halberd for +1 TV each.
  The halberd is a MVB (React, Reach:1). Models with a halberd gain the Brawl:1 trait
  or add +1 to their existing Brawl:X trait if they have it.
  * Well Supported: One model per combat group may select one veteran upgrade
  without being a veteran.
  * Assertion: This force may select one flag objective regardless of its unit composition.
  Select any remaining objectives normally.
*/
class ENH extends Eden {
  ENH(super.data)
      : super(
          name: 'Edenite Noble Houses',
          subFactionRules: [],
        );
}
