import 'package:gearforce/models/rules/cef/cef.dart';

/*
  CEFTF - CEF Tank Formation
  When the mobile elements of the CEF begin their blitzing attacks, it is the hover
  tank formations that lead the way. Powerful enough to destroy most targets and
  fast enough to escape fights they cannot win; these formations are a tried and true.
  * The Hammer: Vehicles in this force may purchase the Improved Gunnery
  veteran upgrade without being veterans.
  * Tank Jockeys: Light and medium hovertanks upgraded with the Vet trait ignore
  the movement penalty for traveling through difficult terrain.
  * Outriders: One combat group, with all models having the hover type movement,
  may deploy using the recon special deployment.
*/
class CEFTF extends CEF {
  CEFTF(super.data)
      : super(
          name: 'CEF Tank Formation',
          subFactionRules: [],
        );
}
