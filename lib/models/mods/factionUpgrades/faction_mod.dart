import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/black_talon.dart';
import 'package:gearforce/models/mods/factionUpgrades/caprice.dart';
import 'package:gearforce/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/mods/factionUpgrades/nucoal.dart';
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
    case conscriptionId:
      return SouthernFactionMods.conscription();
    case samuraiSpiritId:
      return SouthernFactionMods.samuraiSpirit(u);
    case metsukeId:
      return SouthernFactionMods.metsuke(u);

    // NuCoal Faction mods
    case highSpeedLowDragId:
    case hoverTankCommanderId:
      return NuCoalFactionMods.hoverTankCommander();
    case tankJockeysId:
      return NuCoalFactionMods.tankJockeys();
    case somethingToProveId:
      return NuCoalFactionMods.somethingToProve();
    case jannitePilotsId:
      return NuCoalFactionMods.jannitePilots();
    case fastCavalryId:
      return NuCoalFactionMods.fastCavalry();
    case ePexId:
      return NuCoalFactionMods.e_pex();
    case highOctaneId:
      return NuCoalFactionMods.highOctane();
    case personalEquipment1Id:
      return NuCoalFactionMods.personalEquipment(PersonalEquipment.One);
    case personalEquipment2Id:
      return NuCoalFactionMods.personalEquipment(PersonalEquipment.Two);

    // Black Talon mods
    case theChosenId:
      return BlackTalonMods.theChosen();
    case theUnseenId:
      return BlackTalonMods.theUnseen();
    case radioBlackoutId:
      return BlackTalonMods.RadioBlackout();
    case theTalonsId:
      return BlackTalonMods.theTalons();

    // CEF mods
    case minveraId:
      return CEFMods.minerva();
    case advancedInterfaceNetworkId:
      return CEFMods.advancedInterfaceNetwork(
        u,
        ur.factionNotifier.value.factionType,
      );
    case valkyriesId:
      return CEFMods.valkyries();
    case dualLasersId:
      return CEFMods.dualLasers(u);
    case ewDuelistsId:
      return CEFMods.ewDuelists();

    // Caprice mods
    case cyberneticUpgradesId:
      return CapriceMods.cyberneticUpgrades();
  }
  return null;
}
