class Faction {
  final String name;
  late final Factions factionType;
  final List<String> subFactions;

  Faction({required this.name, required this.subFactions}) {
    factionType = convertToFaction(this.name);
  }

  factory Faction.fromJson(dynamic json) => Faction(
        name: json['name'] as String,
        subFactions: List.from(json['subFactions']),
      );
}

enum Factions {
  North,
  South,
  PeaceRiver,
  NuCoal,
  CEF,
  Caprice,
  Utopia,
  Eden,
  Universal,
  Terrain,
  BlackTalon
}

Factions convertToFaction(String faction) {
  //TODO: there must be an easier way instead of a string switch
  switch (faction.toUpperCase()) {
    case "NORTH":
      return Factions.North;
    case 'SOUTH':
      return Factions.South;
    case "PEACE RIVER":
      return Factions.PeaceRiver;
    case 'NUCOAL':
      return Factions.NuCoal;
    case 'CEF':
      return Factions.CEF;
    case 'CAPRICE':
      return Factions.Caprice;
    case 'UTOPIA':
      return Factions.Utopia;
    case 'EDEN':
      return Factions.Eden;
    case 'UNIVERSAL':
      return Factions.Universal;
    case 'TERRAIN':
      return Factions.Terrain;
    case 'BLACK TALON':
      return Factions.BlackTalon;
  }

  throw new FormatException("Unknown role type", faction);
}
