enum FactionType {
  North('North'),
  South('South'),
  PeaceRiver('Peace River'),
  NuCoal('NuCoal'),
  CEF('CEF'),
  Caprice('Caprice'),
  Utopia('Utopia'),
  Eden('Eden'),
  Universal('Universal'),
  Universal_TerraNova('Terra Nova Universal'),
  Universal_Non_TerraNova('Non Terra Nova Universal'),
  Terrain('Terrain'),
  BlackTalon('Black Talons'),
  Airstrike('Airstrike Counter');

  const FactionType(this.name);
  final String name;

  @override
  String toString() => name;

  factory FactionType.fromName(String name) {
    return FactionType.values.firstWhere(
      (element) => element.name == name,
      orElse: () => throw new FormatException("Unknown role type", name),
    );
  }
}
