import 'package:gearforce/models/rules/nucoal/nucoal.dart';

/*
  PAK - Port Arthur Korps
  The Port Arthur Korps is the CEF remnants of the first failed invasion of Terra Nova. This force is
  led by Colonel Arthur himself. The Korp’s GREL army is the largest contributor to the defense of
  NuCoal. Their equipment is not the top of the line, but the GREL infantry and hover vehicles form a
  very strong core that few are willing to test.
  * Hover Tank Commander: Any commander that is in a vehicle type model may improve its EW
  skill by one, to a maximum of 3+, for 1 TV each.
  * Tank Jockeys: Vehicles with the Agile trait may purchase the following ability for 1 TV each:
  Ignore the movement penalty for traveling through difficult terrain.
  * Allies: This force may include gears from the North and South (may include a mix) in GP, SK, FS
  and RC units. Models that come with the Vet trait on their profile cannot be purchased. However,
  the Vet trait may be purchased for models that do not come with it.
  * Acquired Tech: This force may also select the following models from the CEF model list: F6-16s,
  LHT-67s, 71s, MHT-68s, 72s, 95s, HPC-64s and HC-3As.
  * Something to Prove: GREL infantry may increase their GU skill by one for 1 TV each.
*/
class PAK extends NuCoal {
  PAK(super.data)
      : super(
          name: 'Port Arthur Korps',
          subFactionRules: [],
        );
}
