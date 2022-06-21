import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_factions.dart/sub_faction.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<SubFaction> subFactions;

  const Faction(this.factionType, this.subFactions);
  factory Faction.blackTalons() {
    return Faction(FactionType.BlackTalon, [
      SubFaction('Black Talon Recon Team'),
      SubFaction('Black Talon Insertion Team'),
      SubFaction('Black Talon Strike Team'),
      SubFaction('Black Talon Assault Team'),
    ]);
  }
  factory Faction.caprice() {
    return Faction(FactionType.Caprice, [
      SubFaction('Caprice Invasion Detachment'),
      SubFaction('Corporate Security Element'),
      SubFaction('Liberati Resistance Cell'),
    ]);
  }
  factory Faction.cef() {
    return Faction(FactionType.CEF, [
      SubFaction('CEF Frame Formation'),
      SubFaction('CEF Tank Formation'),
      SubFaction('CEF Infantry Formation'),
    ]);
  }
  factory Faction.eden() {
    return Faction(FactionType.Eden, [
      SubFaction('Edenite Invasion Force'),
      SubFaction('Edenite Noble Houses'),
      SubFaction('Ad-Hoc Edenite Force'),
    ]);
  }
  factory Faction.north() {
    return Faction(FactionType.North, [
      SubFaction('Norguard'),
      SubFaction('Western Frontier Protectorate'),
      SubFaction('United Mercantile Federation'),
      SubFaction('Northern Lights Confederacy'),
    ]);
  }
  factory Faction.nucoal() {
    return Faction(FactionType.NuCoal, [
      SubFaction('NuCoal Self Defense Force'),
      SubFaction('Port Arthur Korps'),
      SubFaction('Humanist Alliance Protection Force'),
      SubFaction('Khayr ad-Dine'),
      SubFaction('Temple Heights'),
      SubFaction('Hardscrabble City-State Armies'),
    ]);
  }
  factory Faction.peaceRiver() {
    return Faction(FactionType.PeaceRiver, [
      SubFaction('Peace River Defense Force'),
      SubFaction('Peace Officer Corps'),
      SubFaction('Paxton Private Securities'),
    ]);
  }
  factory Faction.south() {
    return Faction(FactionType.South, [
      SubFaction('Military Intervention and Counter Insurgency Army'),
      SubFaction('Mekong Dominion'),
      SubFaction('Eastern Sun Emirates'),
      SubFaction('Free Humanist Alliance'),
    ]);
  }
  factory Faction.utopia() {
    return Faction(FactionType.Utopia, [
      SubFaction('Combined Armiger Force'),
      SubFaction('Other Utopian Forces'),
    ]);
  }

  bool hasSubFaction(String name) {
    return this.subFactions.any((element) => element.name == name);
  }
}
