import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/black_talon.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/caprice.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/leagueless.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/south.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/utopia.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';
import 'package:gearforce/v3/models/unit/unit.dart';

class FactionModification extends BaseModification {
  FactionModification({
    required super.name,
    super.options,
    required super.requirementCheck,
    required super.id,
    super.onAdd,
    super.onRemove,
    super.ruleType = RuleType.standard,
    super.refreshData,
  }) : super(modType: ModificationType.faction);
}

FactionModification? factionModFromId(String id, UnitRoster ur, Unit u) {
  switch (id) {
    // Peace River Faction mods
    case ePexID:
      return PeaceRiverFactionMods.ePex();
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
      return SouthernFactionMods.conscription(u);
    case samuraiSpiritId:
      return SouthernFactionMods.samuraiSpirit(u);
    case metsukeId:
      return SouthernFactionMods.metsuke(u);
    case lionHuntersId:
      return SouthernFactionMods.lionHunters(u);

    // NuCoal Faction mods
    case highSpeedLowDragId:
      return NuCoalFactionMods.highSpeedLowDrag();
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
      return NuCoalFactionMods.ePex();
    case highOctaneId:
      return NuCoalFactionMods.highOctane();
    case personalEquipment1Id:
      return NuCoalFactionMods.personalEquipment(PersonalEquipment.one);
    case personalEquipment2Id:
      return NuCoalFactionMods.personalEquipment(PersonalEquipment.two);

    // Black Talon mods
    case theChosenId:
      return BlackTalonMods.theChosen();
    case theUnseenId:
      return BlackTalonMods.theUnseen();
    case radioBlackoutId:
      return BlackTalonMods.radioBlackout();
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
    case meleeSpecialistsId:
      return CapriceMods.meleeSpecialists(u);

    // Utopia mods
    case quietDeathId:
      return UtopiaMods.quietDeath();
    case silentAssaultId:
      return UtopiaMods.silentAssault();
    case wrathOfTheDemigodsId:
      return UtopiaMods.wrathOfTheDemigods();
    case notSoSilentAssaultId:
      return UtopiaMods.notSoSilentAssault();
    case whoDaresId:
      return UtopiaMods.whoDares();
    case greenwayCausticsId:
      return UtopiaMods.greenwayCaustics();
    case naiExperimentsId:
      return UtopiaMods.naiExperiments();
    case frankNKiduId:
      return UtopiaMods.frankNKidu();

    // Eden mods
    case lancersId:
      return EdenMods.lancers(u);
    case wellSupportedId:
      return EdenMods.wellSupported();
    case isharaId:
      return EdenMods.ishara(u);
    case expertMarksmenId:
      return EdenMods.expertMarksmen();
    case freebladeId:
      return EdenMods.freeblade();
    case waterBornId:
      return EdenMods.waterBorn();

    // Leagueless mods
    case olRustyId:
      return LeaguelessFactionMods.olRusty();
    case discountsId:
      return LeaguelessFactionMods.discounts(u);
    case localHeroId:
      return LeaguelessFactionMods.localHero();
  }
  return null;
}
