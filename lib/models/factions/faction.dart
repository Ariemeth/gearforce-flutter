class Faction {
  String get name => factionToString(this.factionType);
  late final FactionType factionType;
  final List<String> subFactions;

  Faction({required this.factionType, required this.subFactions});
}

enum FactionType {
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

String factionToString(FactionType f) {
  switch (f) {
    case FactionType.North:
      return 'North';
    case FactionType.South:
      return 'South';
    case FactionType.PeaceRiver:
      return 'Peace River';
    case FactionType.NuCoal:
      return 'NuCoal';
    case FactionType.CEF:
      return 'CEF';
    case FactionType.Caprice:
      return 'Caprice';
    case FactionType.Utopia:
      return 'Utopia';
    case FactionType.Eden:
      return 'Eden';
    case FactionType.Universal:
      return 'Universal';
    case FactionType.Terrain:
      return 'Terrain';
    case FactionType.BlackTalon:
      return 'Black Talon';
  }
}

FactionType convertToFaction(String faction) {
  switch (faction.toUpperCase()) {
    case "NORTH":
      return FactionType.North;
    case 'SOUTH':
      return FactionType.South;
    case 'PEACE RIVER':
    case 'PEACERIVER':
      return FactionType.PeaceRiver;
    case 'NUCOAL':
      return FactionType.NuCoal;
    case 'CEF':
      return FactionType.CEF;
    case 'CAPRICE':
      return FactionType.Caprice;
    case 'UTOPIA':
      return FactionType.Utopia;
    case 'EDEN':
      return FactionType.Eden;
    case 'UNIVERSAL':
      return FactionType.Universal;
    case 'TERRAIN':
      return FactionType.Terrain;
    case 'BLACK TALON':
    case 'BLACKTALON':
      return FactionType.BlackTalon;
  }

  throw new FormatException("Unknown role type", faction);
}
