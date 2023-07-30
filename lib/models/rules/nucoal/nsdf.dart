import 'package:gearforce/models/rules/nucoal/nucoal.dart';

/*
  NSDF - NuCoal Self Defense Force
  The NSDF is a somewhat recently established force that benefits from being well funded and
  motivated. The main strengths of the NSDF are its hover gears and hovertanks. They are particularly
  effective at hit-and-run tactics utilizing their high-speed machines.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force without
  counting against the veteran limitations.
  * Bait and Switch: One combat group composed of all gears may use the special operations
  deployment or the recon special deployment option.
  * High Speed, Low Drag: Veteran gears may purchase
*/
class NSDF extends NuCoal {
  NSDF(super.data)
      : super(
          name: 'NuCoal Self Defense Force',
          subFactionRules: [],
        );
}
