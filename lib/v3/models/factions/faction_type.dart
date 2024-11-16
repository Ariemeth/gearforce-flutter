enum FactionType {
  north('North'),
  south('South'),
  peaceRiver('Peace River'),
  nuCoal('NuCoal'),
  leagueless('Leagueless'),
  cef('CEF'),
  caprice('Caprice'),
  utopia('Utopia'),
  eden('Eden'),
  universal('Universal'),
  universalTerraNova('Terra Nova Universal'),
  universalNonTerraNova('Non Terra Nova Universal'),
  terrain('Terrain'),
  blackTalon('Black Talons'),
  airstrike('Airstrike Counter'),
  none('No faction');

  const FactionType(this.name);
  final String name;

  @override
  String toString() => name;

  factory FactionType.fromName(String name) {
    return FactionType.values.firstWhere(
      (element) => element.name == name,
      orElse: () => throw FormatException('Unknown faction type', name),
    );
  }
}
