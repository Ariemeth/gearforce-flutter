import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/black_talons/black_talons.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart';
import 'package:gearforce/models/rules/cef/cef.dart';
import 'package:gearforce/models/rules/eden/eden.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/nucoal/nucoal.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/south/south.dart';
import 'package:gearforce/models/rules/utopia/utopia.dart';

const String _emptySubFactionName = '';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<RuleSet> rulesets;
  final RuleSet defaultSubFaction;

  const Faction(this.factionType, this.rulesets, this.defaultSubFaction);

  factory Faction.blackTalons(Data data) {
    final rulesets = [
      BlackTalons(data, name: _emptySubFactionName),
      BlackTalons.BTRT(data),
      BlackTalons.BTIT(data),
      BlackTalons.BTST(data),
      BlackTalons.BTAT(data),
    ];
    return Faction(FactionType.BlackTalon, rulesets, rulesets.first);
  }
  factory Faction.caprice(Data data) {
    final rulesets = [
      Caprice(data, name: _emptySubFactionName),
      Caprice.CID(data),
      Caprice.CSE(data),
      Caprice.LRC(data),
    ];
    return Faction(FactionType.Caprice, rulesets, rulesets.first);
  }
  factory Faction.cef(Data data) {
    final rulesets = [
      CEF(data, name: _emptySubFactionName),
      CEF.CEFFF(data),
      CEF.CEFTF(data),
      CEF.CEFIF(data),
    ];
    return Faction(FactionType.CEF, rulesets, rulesets.first);
  }
  factory Faction.eden(Data data) {
    final rulesets = [
      Eden(data, name: _emptySubFactionName),
      Eden.EIF(data),
      Eden.ENH(data),
      Eden.AEF(data),
    ];
    return Faction(FactionType.Eden, rulesets, rulesets.first);
  }
  factory Faction.north(Data data) {
    final rulesets = [
      North(data, name: _emptySubFactionName),
      North.NG(data),
      North.WFP(data),
      North.UMF(data),
      North.NLC(data),
    ];
    return Faction(FactionType.North, rulesets, rulesets.first);
  }
  factory Faction.nucoal(Data data) {
    final rulesets = [
      NuCoal(data, name: _emptySubFactionName),
      NuCoal.NSDF(data),
      NuCoal.PAK(data),
      NuCoal.HAPF(data),
      NuCoal.KADA(data),
      NuCoal.TH(data),
      NuCoal.HCSA(data),
    ];
    return Faction(FactionType.NuCoal, rulesets, rulesets.first);
  }
  factory Faction.peaceRiver(Data data) {
    final rulesets = [
      PeaceRiver(data, name: _emptySubFactionName),
      PeaceRiver.PRDF(data),
      PeaceRiver.POC(data),
      PeaceRiver.PPS(data),
    ];
    return Faction(FactionType.PeaceRiver, rulesets, rulesets.first);
  }
  factory Faction.south(Data data) {
    final rulesets = [
      South(data, name: _emptySubFactionName),
      South.SRA(data),
      South.MILICIA(data),
      South.MD(data),
      South.ESE(data),
      South.FHA(data),
    ];
    return Faction(FactionType.South, rulesets, rulesets.first);
  }
  factory Faction.utopia(Data data) {
    final rulesets = [
      Utopia(data, name: _emptySubFactionName),
      Utopia.CAF(data),
      Utopia.OUF(data),
    ];
    return Faction(FactionType.Utopia, rulesets, rulesets.first);
  }

  factory Faction.fromType(FactionType faction, Data data) {
    switch (faction) {
      case FactionType.North:
        return Faction.north(data);
      case FactionType.South:
        return Faction.south(data);
      case FactionType.PeaceRiver:
        return Faction.peaceRiver(data);
      case FactionType.NuCoal:
        return Faction.nucoal(data);
      case FactionType.CEF:
        return Faction.cef(data);
      case FactionType.Caprice:
        return Faction.caprice(data);
      case FactionType.Utopia:
        return Faction.utopia(data);
      case FactionType.Eden:
        return Faction.eden(data);
      case FactionType.Universal:
        break;
      case FactionType.Universal_TerraNova:
        break;
      case FactionType.Universal_Non_TerraNova:
        break;
      case FactionType.Terrain:
        break;
      case FactionType.BlackTalon:
        return Faction.blackTalons(data);
      case FactionType.Airstrike:
        break;
      case FactionType.None:
        break;
    }
    throw FormatException('Cannot create a faction from ${faction.name}');
  }
}
