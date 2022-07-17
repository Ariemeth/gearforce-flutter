import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

class FactionModification extends BaseModification {
  FactionModification({
    required String name,
    ModificationOption? options,
    required RequirementCheck requirementCheck,
    required String id,
  }) : super(
            name: name,
            requirementCheck: requirementCheck,
            options: options,
            id: id);
}

FactionModification? factionModFromId(String id, UnitRoster ur, Unit u) {
  switch (id) {
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
  }
  return null;
}
