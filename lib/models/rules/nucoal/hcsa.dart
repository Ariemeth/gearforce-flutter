import 'package:gearforce/models/rules/nucoal/nucoal.dart';

/*
  HCSA - Hardscrabble City-State Armies
  The NuCoal city-states each have a standing army for self defense. Individually, they are all hard
  pressed to field enough of a fighting force for any kind of major operation. But they are well practiced
  at combining their powers to support larger military actions in support of NuCoal’s interests.
  All HCSA forces have the following upgrade options:
  * City-States Detachments: Select a city-state from below for each combat group.
  Lance Point, Fort Neil, Prince Gable and/or Erech & Nineveh.
  Each set of rules applies to one combat group. You may select the same city-state to be used for
  more than one combat group.
  Lance Point: A fast-growing city-state, Lance Point is an oil boom town currently occupied by
  Southern forces. Time will tell if the presence of these ‘Observers’ will become a permanent feature
  of the situation in Lance Point.
  * Allies: This combat group may include models from the South with an armor of 9 or less.
  * Pathfinder: If this combat group is composed entirely of gears, then it may use the recon special
  deployment option.
  Fort Neil: An industrial hub that has spearheaded many of the new developments of the Gallic series
  of gears. In addition, the Sampson hover APC was developed by Fort Neil engineers. Formations of
  Sampsons are common in Fort Neil regiments and the local rally scene.
  * Gallic Manufacturing: Chasseurs and Chasseur MK2s may be placed in GP, SK, FS or RC units.
  * Licensed Manufacturing: This combat group may include Sidewinders from the South, and
  Ferrets from the North.
  * Test Pilots: Two models in this combat group may purchase the Vet trait without counting
  against the veteran limitations.
  * Fast Cavalry: Sampsons in this combat group may purchase the Agile trait for 1 TV each.
  Prince Gable: This is the home to the manufacturer of the Jerboa, Verton Tech, which got its own
  start as a rally gear company. Because the city’s infrastructure is rather advanced, especially for the
  Badlands, many refugees and tech companies have made their way to this city-state.
  * Allies: This combat group may include models from the North with an armor of 9 or less.
  * EW Specialists: One gear, strider, or vehicle in this combat group may purchase the ECCM
  veteran upgrade without being a veteran.
  * E-pex: One model in this combat group may improve its EW skill by one for 1 TV.
  Erech & Nineveh: The Twin Cities have vast wealth, enough to host several private military contractors
  each. When not on active duty, the citizens and soldiers spend a lot of their time participating in
  races, wagering their fuel allowances and even their lives on the outcomes.
  * Allies: This combat group may include models from the North or South (pick one) with an
  armor of 9 or less.
  * Personal Equipment: Two models in this combat group may purchase two veteran upgrades
  each without being veterans.
  * High Octane: Add +1 to the MR of any veteran gears in this combat group for 1 TV each.
*/
class HCSA extends NuCoal {
  HCSA(super.data)
      : super(
          name: 'Hardscrabble City-State Armies',
          subFactionRules: [],
        );
}
