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
  String get name => factionType.name;
  final FactionType factionType;
  final List<RuleSet> rulesets;
  final RuleSet defaultSubFaction;

  const Faction(this.factionType, this.rulesets, this.defaultSubFaction);

  factory Faction.blackTalons(DataV3 data, Settings settings) {
    final rulesets = [
      BlackTalons(data, settings, name: _emptySubFactionName),
      BlackTalons.btrt(data, settings),
      BlackTalons.btit(data, settings),
      BlackTalons.btst(data, settings),
      BlackTalons.btat(data, settings),
    ];
    return Faction(FactionType.blackTalon, rulesets, rulesets.first);
  }
  factory Faction.caprice(DataV3 data, Settings settings) {
    final rulesets = [
      Caprice(data, settings, name: _emptySubFactionName),
      Caprice.cid(data, settings),
      Caprice.cse(data, settings),
      Caprice.lrc(data, settings),
    ];
    return Faction(FactionType.caprice, rulesets, rulesets.first);
  }
  factory Faction.cef(DataV3 data, Settings settings) {
    final rulesets = [
      CEF(data, settings, name: _emptySubFactionName),
      CEF.cefff(data, settings),
      CEF.ceftf(data, settings),
      CEF.cefif(data, settings),
    ];
    return Faction(FactionType.cef, rulesets, rulesets.first);
  }
  factory Faction.eden(DataV3 data, Settings settings) {
    final rulesets = [
      Eden(data, settings, name: _emptySubFactionName),
      Eden.eif(data, settings),
      Eden.enh(data, settings),
      Eden.aef(data, settings),
    ];
    return Faction(FactionType.eden, rulesets, rulesets.first);
  }
  factory Faction.north(DataV3 data, Settings settings) {
    final rulesets = [
      North(data, settings, name: _emptySubFactionName),
      North.ng(data, settings),
      North.wfp(data, settings),
      North.umf(data, settings),
      North.nlc(data, settings),
    ];
    return Faction(FactionType.north, rulesets, rulesets.first);
  }
  factory Faction.nucoal(DataV3 data, Settings settings) {
    final rulesets = [
      NuCoal(data, settings, name: _emptySubFactionName),
      NuCoal.nsdf(data, settings),
      NuCoal.pak(data, settings),
      NuCoal.hapf(data, settings),
      NuCoal.kada(data, settings),
      NuCoal.th(data, settings),
      NuCoal.hcsa(data, settings),
    ];
    return Faction(FactionType.nuCoal, rulesets, rulesets.first);
  }
  factory Faction.peaceRiver(DataV3 data, Settings settings) {
    final rulesets = [
      PeaceRiver(data, settings, name: _emptySubFactionName),
      PeaceRiver.prdf(data, settings),
      PeaceRiver.poc(data, settings),
      PeaceRiver.pps(data, settings),
    ];
    return Faction(FactionType.peaceRiver, rulesets, rulesets.first);
  }
  factory Faction.south(DataV3 data, Settings settings) {
    final rulesets = [
      South(data, settings, name: _emptySubFactionName),
      South.sra(data, settings),
      South.milicia(data, settings),
      South.md(data, settings),
      South.ese(data, settings),
      South.fha(data, settings),
    ];
    return Faction(FactionType.south, rulesets, rulesets.first);
  }
  factory Faction.utopia(DataV3 data, Settings settings) {
    final rulesets = [
      Utopia(data, settings, name: _emptySubFactionName),
      Utopia.caf(data, settings),
      Utopia.ouf(data, settings),
    ];
    return Faction(FactionType.utopia, rulesets, rulesets.first);
  }

  factory Faction.leagueless(DataV3 data, Settings settings) {
    final rulesets = [
      Leagueless.north(data, settings),
      Leagueless.south(data, settings),
      Leagueless.peaceRiver(data, settings),
      Leagueless.nuCoal(data, settings),
    ];

    return Faction(FactionType.leagueless, rulesets, rulesets.first);
  }

  factory Faction.fromType(
      FactionType faction, DataV3 data, Settings settings) {
    switch (faction) {
      case FactionType.north:
        return Faction.north(data, settings);
      case FactionType.south:
        return Faction.south(data, settings);
      case FactionType.peaceRiver:
        return Faction.peaceRiver(data, settings);
      case FactionType.nuCoal:
        return Faction.nucoal(data, settings);
      case FactionType.leagueless:
        return Faction.leagueless(data, settings);
      case FactionType.cef:
        return Faction.cef(data, settings);
      case FactionType.caprice:
        return Faction.caprice(data, settings);
      case FactionType.utopia:
        return Faction.utopia(data, settings);
      case FactionType.eden:
        return Faction.eden(data, settings);
      case FactionType.universal:
        break;
      case FactionType.universalTerraNova:
        break;
      case FactionType.universalNonTerraNova:
        break;
      case FactionType.terrain:
        break;
      case FactionType.blackTalon:
        return Faction.blackTalons(data, settings);
      case FactionType.airstrike:
        break;
      case FactionType.none:
        break;
    }
    throw FormatException('Cannot create a faction from ${faction.name}');
  }
}
