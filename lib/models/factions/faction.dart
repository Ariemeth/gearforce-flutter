import 'package:gearforce/models/factions/faction_type.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<String> subFactions;

  const Faction(this.factionType, this.subFactions);
  factory Faction.blackTalons() {
    return Faction(FactionType.BlackTalon, [
      'PRDF - Peace River Defense Force',
      'POC - Peace Officer Corps',
      'PPS - Paxton Private Securities',
    ]);
  }
  factory Faction.caprice() {
    return Faction(FactionType.Caprice, []);
  }
  factory Faction.cef() {
    return Faction(FactionType.CEF, []);
  }
  factory Faction.eden() {
    return Faction(FactionType.Eden, []);
  }
  factory Faction.north() {
    return Faction(FactionType.North, []);
  }
  factory Faction.nucoal() {
    return Faction(FactionType.NuCoal, []);
  }
  factory Faction.peaceRiver() {
    return Faction(FactionType.PeaceRiver, []);
  }
  factory Faction.south() {
    return Faction(FactionType.South, []);
  }
  factory Faction.utopia() {
    return Faction(FactionType.Utopia, []);
  }
}
