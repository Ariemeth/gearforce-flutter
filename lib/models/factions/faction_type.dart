enum FactionType {
  North('North'),
  South('South'),
  PeaceRiver('Peace River'),
  NuCoal('NuCoal'),
  Leagueless('Leagueless'),
  CEF('CEF'),
  Caprice('Caprice'),
  Utopia('Utopia'),
  Eden('Eden'),
  NewJerusalem('New Jerusalem'),
  Universal('Universal'),
  Universal_TerraNova('Terra Nova Universal'),
  Universal_Non_TerraNova('Non Terra Nova Universal'),
  Terrain('Terrain'),
  BlackTalon('Black Talons'),
  Airstrike('Airstrike Counter'),
  None('No faction');

  const FactionType(this.name);
  final String name;

  @override
  String toString() => name;

  factory FactionType.fromName(String name) {
    return FactionType.values.firstWhere(
      (element) => element.name == name,
      orElse: () => throw new FormatException("Unknown faction type", name),
    );
  }
}
