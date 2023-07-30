import 'package:gearforce/models/rules/eden/eden.dart';

/*
  EIF - Edenite Invasion Force
  The Edenite Invasion Force is a mix of feudal households, militias, and militant privateers.
  Nobles from the Seiath Empire hold ultimate leadership. Their motivations seem dubious
  as their tactics frequently place rival nobles from other kingdoms on missions that have a
  low probability for survival. In turn, their field commanders have started doing their best
  to not always follow the plans as given. This ultimately gives the EIF a very random profile
  on which tactics and strategies are selected.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force
  without counting against the veteran limitations.
  * Improviso: Select one upgrade option from ENH or AEF.
  * Expert Marksmen: Each golem with a rifle may increase their GU skill by one for 1 TV.
  * Equity: This force may select one capture objective
*/
class EIF extends Eden {
  EIF(super.data)
      : super(
          name: 'Edenite Invasion Force',
          subFactionRules: [],
        );
}
