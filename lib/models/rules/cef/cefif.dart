import 'package:gearforce/models/rules/cef/cef.dart';

/*
  CEFIF - CEF Infantry Formation
  The CEF infantry formations swarm across the landscape, each genetically
  engineered soldier hypno-trained from birth to fight to their last breath and to follow
  orders to the letter. A more disciplined army has never existed in all of history
  and no army survives being engaged by the relentless attacks of the CEF infantry
  formations for very long.
  * The Anvil: Infantry may be placed in GP, SK, FS, RC or SO units.
  * Alternate Approach: GREL upgraded with the Veteran trait will also receive the
  Jetpack:4 trait.
  * Something to Prove: GREL infantry models may increase their GU skill by one
  for 1 TV each.
*/
class CEFIF extends CEF {
  CEFIF(super.data)
      : super(
          name: 'CEF Infantry Formation',
          subFactionRules: [],
        );
}
