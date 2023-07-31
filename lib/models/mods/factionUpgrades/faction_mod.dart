import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/factionUpgrades/south.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

class FactionModification extends BaseModification {
  FactionModification(
      {required super.name,
      super.options,
      required super.requirementCheck,
      required super.id,
      super.onAdd,
      super.onRemove})
      : super(modType: ModificationType.faction);
}

FactionModification? factionModFromId(String id, UnitRoster ur, Unit u) {
  switch (id) {
    // Peace River Faction mods
    case e_pexID:
      return PeaceRiverFactionMods.e_pex();
    case warriorEliteID:
      return PeaceRiverFactionMods.warriorElite();
    case crisisRespondersID:
      return PeaceRiverFactionMods.crisisResponders(u);
    case laserTechID:
      return PeaceRiverFactionMods.laserTech(u);
    case olTrustyID:
      return PeaceRiverFactionMods.olTrusty();
    case thunderFromTheSkyID:
      return PeaceRiverFactionMods.thunderFromTheSky();
    case eliteElementsID:
      return PeaceRiverFactionMods.eliteElements(ur);
    case ecmSpecialistID:
      return PeaceRiverFactionMods.ecmSpecialist();
    case olTrustyPOCID:
      return PeaceRiverFactionMods.olTrustyPOC();
    case peaceOfficersID:
      return PeaceRiverFactionMods.peaceOfficers(u);
    case gSWATSniperID:
      return PeaceRiverFactionMods.gSWATSniper();

    // Northern Faction mods
    case taskBuiltID:
      return NorthernFactionMods.taskBuilt(u);
    case hammersOfTheNorthID:
      return NorthernFactionMods.hammerOfTheNorth(u);
    case olTrustyWFPID:
      return NorthernFactionMods.olTrustyWFP();
    case wellFundedID:
      return NorthernFactionMods.wellFunded();
    case chaplainID:
      return NorthernFactionMods.chaplain();
    case warriorMonksID:
      return NorthernFactionMods.warriorMonks(u);

    // Southern Faction mods
    case prideOfTheSouthId:
      return SouthernFactionMods.prideOfTheSouth(u);
    case politicalOfficerId:
      return SouthernFactionMods.politicalOfficer();
  }
  return null;
}
