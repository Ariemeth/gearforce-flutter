import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_factions.dart/black_talons.dart';
import 'package:gearforce/models/factions/sub_factions.dart/caprice.dart';
import 'package:gearforce/models/factions/sub_factions.dart/cef.dart';
import 'package:gearforce/models/factions/sub_factions.dart/eden.dart';
import 'package:gearforce/models/factions/sub_factions.dart/north.dart';
import 'package:gearforce/models/factions/sub_factions.dart/nucoal.dart';
import 'package:gearforce/models/factions/sub_factions.dart/peace_river.dart';
import 'package:gearforce/models/factions/sub_factions.dart/south.dart';
import 'package:gearforce/models/factions/sub_factions.dart/sub_faction.dart';
import 'package:gearforce/models/factions/sub_factions.dart/utopia.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<SubFaction> subFactions;

  const Faction(this.factionType, this.subFactions);
  factory Faction.blackTalons() {
    return Faction(FactionType.BlackTalon, [
      blackTalon_BTRT(),
      blackTalon_BTIT(),
      blackTalon_BTST(),
      blackTalon_BTAT(),
    ]);
  }
  factory Faction.caprice() {
    return Faction(FactionType.Caprice, [
      caprice_CID(),
      caprice_CSE(),
      caprice_LRC(),
    ]);
  }
  factory Faction.cef() {
    return Faction(FactionType.CEF, [
      cef_CEFFF(),
      cef_CEFTF(),
      cef_CEFIF(),
    ]);
  }
  factory Faction.eden() {
    return Faction(FactionType.Eden, [
      eden_EIF(),
      eden_ENH(),
      eden_AEF(),
    ]);
  }
  factory Faction.north() {
    return Faction(FactionType.North, [
      north_NG(),
      north_WFP(),
      north_UMF(),
      north_NLC(),
    ]);
  }
  factory Faction.nucoal() {
    return Faction(FactionType.NuCoal, [
      nucoal_NSDF(),
      nucoal_PAK(),
      nucoal_HAPF(),
      nucoal_KADA(),
      nucoal_TH(),
      nucoal_HCSA(),
    ]);
  }
  factory Faction.peaceRiver() {
    return Faction(FactionType.PeaceRiver, [
      peaceRiver_PRDF(),
      peaceRiver_POC(),
      peaceRiver_PRDF(),
    ]);
  }
  factory Faction.south() {
    return Faction(FactionType.South, [
      south_MILICIA(),
      south_MD(),
      south_ESE(),
      south_FHA(),
    ]);
  }
  factory Faction.utopia() {
    return Faction(FactionType.Utopia, [
      utopia_CAF(),
      utopia_OUF(),
    ]);
  }
}
