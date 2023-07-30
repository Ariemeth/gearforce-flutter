import 'package:gearforce/models/rules/nucoal/nucoal.dart';

/*
  HAPF - Humanist Alliance Protection Force
  In the aftermath of a failed revolt against the Southern Republic, eight percent of the Humanist
  Alliance’s population, including most of its military, migrated to NuCoal. The protector caste of the
  Humanist Alliance boasts a small, powerful and highly advanced armed force.
  * Wrote the Book: Two models per combat group may purchase the Vet trait without counting
  against the veteran limitations.
  * Experts: Veteran Sagittariuses, veteran Fire Dragons and veteran Hetairoi may purchase the
  Stable and/or Precise duelist upgrades, without having to be duelists.
  * Southern Surplus: This force may include models from the South in GP, SK, FS and RC units,
  except for King Cobras and Drakes.
*/
class HAPF extends NuCoal {
  HAPF(super.data)
      : super(
          name: 'Humanist Alliance Protection Force',
          subFactionRules: [],
        );
}
