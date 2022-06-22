import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_factions.dart/sub_faction.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<SubFaction> subFactions;

  const Faction(this.factionType, this.subFactions);

  factory Faction.blackTalons() {
    return Faction(FactionType.BlackTalon, [
      SubFaction('', ruleSet: null),
      SubFaction('Black Talon Recon Team', ruleSet: null),
      SubFaction('Black Talon Insertion Team', ruleSet: null),
      SubFaction('Black Talon Strike Team', ruleSet: null),
      SubFaction('Black Talon Assault Team', ruleSet: null),
    ]);
  }
  factory Faction.caprice() {
    return Faction(FactionType.Caprice, [
      SubFaction('', ruleSet: null),
      SubFaction('Caprice Invasion Detachment', ruleSet: null),
      SubFaction('Corporate Security Element', ruleSet: null),
      SubFaction('Liberati Resistance Cell', ruleSet: null),
    ]);
  }
  factory Faction.cef() {
    return Faction(FactionType.CEF, [
      SubFaction('', ruleSet: null),
      SubFaction('CEF Frame Formation', ruleSet: null),
      SubFaction('CEF Tank Formation', ruleSet: null),
      SubFaction('CEF Infantry Formation', ruleSet: null),
    ]);
  }
  factory Faction.eden() {
    return Faction(FactionType.Eden, [
      SubFaction('', ruleSet: null),
      SubFaction('Edenite Invasion Force', ruleSet: null),
      SubFaction('Edenite Noble Houses', ruleSet: null),
      SubFaction('Ad-Hoc Edenite Force', ruleSet: null),
    ]);
  }
  factory Faction.north() {
    return Faction(FactionType.North, [
      SubFaction('', ruleSet: null),
      SubFaction('Norguard', ruleSet: null),
      SubFaction('Western Frontier Protectorate', ruleSet: null),
      SubFaction('United Mercantile Federation', ruleSet: null),
      SubFaction('Northern Lights Confederacy', ruleSet: null),
    ]);
  }
  factory Faction.nucoal() {
    return Faction(FactionType.NuCoal, [
      SubFaction('', ruleSet: null),
      SubFaction('NuCoal Self Defense Force', ruleSet: null),
      SubFaction('Port Arthur Korps', ruleSet: null),
      SubFaction('Humanist Alliance Protection Force', ruleSet: null),
      SubFaction('Khayr ad-Dine', ruleSet: null),
      SubFaction('Temple Heights', ruleSet: null),
      SubFaction('Hardscrabble City-State Armies', ruleSet: null),
    ]);
  }
  factory Faction.peaceRiver() {
    return Faction(FactionType.PeaceRiver, [
      SubFaction('', ruleSet: null),
      SubFaction('Peace River Defense Force', ruleSet: null),
      SubFaction('Peace Officer Corps', ruleSet: null),
      SubFaction('Paxton Private Securities', ruleSet: null),
    ]);
  }
  factory Faction.south() {
    return Faction(FactionType.South, [
      SubFaction('', ruleSet: null),
      SubFaction('Military Intervention and Counter Insurgency Army',
          ruleSet: null),
      SubFaction('Mekong Dominion', ruleSet: null),
      SubFaction('Eastern Sun Emirates', ruleSet: null),
      SubFaction('Free Humanist Alliance', ruleSet: null),
    ]);
  }
  factory Faction.utopia() {
    return Faction(FactionType.Utopia, [
      SubFaction('', ruleSet: null),
      SubFaction('Combined Armiger Force', ruleSet: null),
      SubFaction('Other Utopian Forces', ruleSet: null),
    ]);
  }

  factory Faction.fromType(FactionType faction) {
    switch (faction) {
      case FactionType.North:
        return Faction.north();
      case FactionType.South:
        return Faction.south();
      case FactionType.PeaceRiver:
        return Faction.peaceRiver();
      case FactionType.NuCoal:
        return Faction.nucoal();
      case FactionType.CEF:
        return Faction.cef();
      case FactionType.Caprice:
        return Faction.caprice();
      case FactionType.Utopia:
        return Faction.utopia();
      case FactionType.Eden:
        return Faction.eden();
      case FactionType.Universal:
        break;
      case FactionType.Universal_TerraNova:
        break;
      case FactionType.Universal_Non_TerraNova:
        break;
      case FactionType.Terrain:
        break;
      case FactionType.BlackTalon:
        return Faction.blackTalons();
      case FactionType.Airstrike:
        break;
    }
    throw FormatException('Cannot create a faction from ${faction.name}');
  }

  bool hasSubFaction(String name) {
    return this.subFactions.any((element) => element.name == name);
  }
}
