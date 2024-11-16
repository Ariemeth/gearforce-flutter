enum ModelType {
  gear('Gear'),
  strider('Strider'),
  vehicle('Vehicle'),
  drone('Drone'),
  airstrikeCounter('Airstrike Counter'),
  infantry('Infantry'),
  cavalry('Cavalry'),
  terrain('Terrain'),
  areaTerrain('Area Terrain'),
  building('Building');

  final String name;

  const ModelType(this.name);

  @override
  String toString() => name;

  factory ModelType.fromName(String name) {
    return ModelType.values.firstWhere(
      (mt) {
        final match = RegExp('^${mt.name}\$', caseSensitive: false);
        return match.hasMatch(name);
      },
      orElse: () => throw FormatException('Unknown model type', name),
    );
  }
}
