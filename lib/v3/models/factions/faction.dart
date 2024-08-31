import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/rules/rulesets/black_talons/black_talons.dart';
import 'package:gearforce/v3/models/rules/rulesets/caprice/caprice.dart';
import 'package:gearforce/v3/models/rules/rulesets/cef/cef.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/eden.dart';
import 'package:gearforce/v3/models/rules/rulesets/leagueless/leagueless.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/nucoal.dart';
import 'package:gearforce/v3/models/rules/rulesets/peace_river/peace_river.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/south.dart';
import 'package:gearforce/v3/models/rules/rulesets/utopia/utopia.dart';
import 'package:gearforce/widgets/settings.dart';

const String _emptySubFactionName = '';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<RuleSet> rulesets;
  final RuleSet defaultSubFaction;

  const Faction(this.factionType, this.rulesets, this.defaultSubFaction);

  factory Faction.blackTalons(Data data, Settings settings) {
    final rulesets = [
      BlackTalons(data, settings, name: _emptySubFactionName),
      BlackTalons.BTRT(data, settings),
      BlackTalons.BTIT(data, settings),
      BlackTalons.BTST(data, settings),
      BlackTalons.BTAT(data, settings),
    ];
    return Faction(FactionType.BlackTalon, rulesets, rulesets.first);
  }
  factory Faction.caprice(Data data, Settings settings) {
    final rulesets = [
      Caprice(data, settings, name: _emptySubFactionName),
      Caprice.CID(data, settings),
      Caprice.CSE(data, settings),
      Caprice.LRC(data, settings),
    ];
    return Faction(FactionType.Caprice, rulesets, rulesets.first);
  }
  factory Faction.cef(Data data, Settings settings) {
    final rulesets = [
      CEF(data, settings, name: _emptySubFactionName),
      CEF.CEFFF(data, settings),
      CEF.CEFTF(data, settings),
      CEF.CEFIF(data, settings),
    ];
    return Faction(FactionType.CEF, rulesets, rulesets.first);
  }
  factory Faction.eden(Data data, Settings settings) {
    final rulesets = [
      Eden(data, settings, name: _emptySubFactionName),
      Eden.EIF(data, settings),
      Eden.ENH(data, settings),
      Eden.AEF(data, settings),
    ];
    return Faction(FactionType.Eden, rulesets, rulesets.first);
  }
  factory Faction.north(Data data, Settings settings) {
    final rulesets = [
      North(data, settings, name: _emptySubFactionName),
      North.NG(data, settings),
      North.WFP(data, settings),
      North.UMF(data, settings),
      North.NLC(data, settings),
    ];
    return Faction(FactionType.North, rulesets, rulesets.first);
  }
  factory Faction.nucoal(Data data, Settings settings) {
    final rulesets = [
      NuCoal(data, settings, name: _emptySubFactionName),
      NuCoal.NSDF(data, settings),
      NuCoal.PAK(data, settings),
      NuCoal.HAPF(data, settings),
      NuCoal.KADA(data, settings),
      NuCoal.TH(data, settings),
      NuCoal.HCSA(data, settings),
    ];
    return Faction(FactionType.NuCoal, rulesets, rulesets.first);
  }
  factory Faction.peaceRiver(Data data, Settings settings) {
    final rulesets = [
      PeaceRiver(data, settings, name: _emptySubFactionName),
      PeaceRiver.PRDF(data, settings),
      PeaceRiver.POC(data, settings),
      PeaceRiver.PPS(data, settings),
    ];
    return Faction(FactionType.PeaceRiver, rulesets, rulesets.first);
  }
  factory Faction.south(Data data, Settings settings) {
    final rulesets = [
      South(data, settings, name: _emptySubFactionName),
      South.SRA(data, settings),
      South.MILICIA(data, settings),
      South.MD(data, settings),
      South.ESE(data, settings),
      South.FHA(data, settings),
    ];
    return Faction(FactionType.South, rulesets, rulesets.first);
  }
  factory Faction.utopia(Data data, Settings settings) {
    final rulesets = [
      Utopia(data, settings, name: _emptySubFactionName),
      Utopia.CAF(data, settings),
      Utopia.OUF(data, settings),
    ];
    return Faction(FactionType.Utopia, rulesets, rulesets.first);
  }

  factory Faction.leagueless(Data data, Settings settings) {
    final rulesets = [
      Leagueless.North(data, settings),
      Leagueless.South(data, settings),
      Leagueless.PeaceRiver(data, settings),
      Leagueless.NuCoal(data, settings),
    ];

    return Faction(FactionType.Leagueless, rulesets, rulesets.first);
  }

  factory Faction.fromType(FactionType faction, Data data, Settings settings) {
    switch (faction) {
      case FactionType.North:
        return Faction.north(data, settings);
      case FactionType.South:
        return Faction.south(data, settings);
      case FactionType.PeaceRiver:
        return Faction.peaceRiver(data, settings);
      case FactionType.NuCoal:
        return Faction.nucoal(data, settings);
      case FactionType.Leagueless:
        return Faction.leagueless(data, settings);
      case FactionType.CEF:
        return Faction.cef(data, settings);
      case FactionType.Caprice:
        return Faction.caprice(data, settings);
      case FactionType.Utopia:
        return Faction.utopia(data, settings);
      case FactionType.Eden:
        return Faction.eden(data, settings);
      case FactionType.Universal:
        break;
      case FactionType.Universal_TerraNova:
        break;
      case FactionType.Universal_Non_TerraNova:
        break;
      case FactionType.Terrain:
        break;
      case FactionType.BlackTalon:
        return Faction.blackTalons(data, settings);
      case FactionType.Airstrike:
        break;
      case FactionType.None:
        break;
    }
    throw FormatException('Cannot create a faction from ${faction.name}');
  }
}
