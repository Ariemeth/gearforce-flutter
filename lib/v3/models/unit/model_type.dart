enum ModelType {
  Gear('Gear'),
  Strider('Strider'),
  Vehicle('Vehicle'),
  Drone('Drone'),
  AirstrikeCounter('Airstrike Counter'),
  Infantry('Infantry'),
  Cavalry('Cavalry'),
  Terrain('Terrain'),
  AreaTerrain('Area Terrain'),
  Building('Building');

  final String name;

  const ModelType(this.name);

  @override
  String toString() => name;

  factory ModelType.fromName(String name) {
    return ModelType.values.firstWhere(
      (mt) {
        final match = RegExp("^${mt.name}\$", caseSensitive: false);
        return match.hasMatch(name);
      },
      orElse: () => throw new FormatException("Unknown model type", name),
    );
  }
}
