import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_factions.dart/sub_faction.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<SubFaction> subFactions;

  const Faction(this.factionType, this.subFactions);
  factory Faction.blackTalons() {
    return Faction(FactionType.BlackTalon, [
      SubFaction('Black Talon Recon Team', ruleSet: null),
      SubFaction('Black Talon Insertion Team', ruleSet: null),
      SubFaction('Black Talon Strike Team', ruleSet: null),
      SubFaction('Black Talon Assault Team', ruleSet: null),
    ]);
  }
  factory Faction.caprice() {
    return Faction(FactionType.Caprice, [
      SubFaction('Caprice Invasion Detachment', ruleSet: null),
      SubFaction('Corporate Security Element', ruleSet: null),
      SubFaction('Liberati Resistance Cell', ruleSet: null),
    ]);
  }
  factory Faction.cef() {
    return Faction(FactionType.CEF, [
      SubFaction('CEF Frame Formation', ruleSet: null),
      SubFaction('CEF Tank Formation', ruleSet: null),
      SubFaction('CEF Infantry Formation', ruleSet: null),
    ]);
  }
  factory Faction.eden() {
    return Faction(FactionType.Eden, [
      SubFaction('Edenite Invasion Force', ruleSet: null),
      SubFaction('Edenite Noble Houses', ruleSet: null),
      SubFaction('Ad-Hoc Edenite Force', ruleSet: null),
    ]);
  }
  factory Faction.north() {
    return Faction(FactionType.North, [
      SubFaction('Norguard', ruleSet: null),
      SubFaction('Western Frontier Protectorate', ruleSet: null),
      SubFaction('United Mercantile Federation', ruleSet: null),
      SubFaction('Northern Lights Confederacy', ruleSet: null),
    ]);
  }
  factory Faction.nucoal() {
    return Faction(FactionType.NuCoal, [
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
      SubFaction('Peace River Defense Force', ruleSet: null),
      SubFaction('Peace Officer Corps', ruleSet: null),
      SubFaction('Paxton Private Securities', ruleSet: null),
    ]);
  }
  factory Faction.south() {
    return Faction(FactionType.South, [
      SubFaction('Military Intervention and Counter Insurgency Army',
          ruleSet: null),
      SubFaction('Mekong Dominion', ruleSet: null),
      SubFaction('Eastern Sun Emirates', ruleSet: null),
      SubFaction('Free Humanist Alliance', ruleSet: null),
    ]);
  }
  factory Faction.utopia() {
    return Faction(FactionType.Utopia, [
      SubFaction('Combined Armiger Force', ruleSet: null),
      SubFaction('Other Utopian Forces', ruleSet: null),
    ]);
  }

  bool hasSubFaction(String name) {
    return this.subFactions.any((element) => element.name == name);
  }
}
