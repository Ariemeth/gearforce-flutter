class Faction {
  final String name;
  final List<String> subFactions;

  const Faction({required this.name, required this.subFactions});

  factory Faction.fromJson(dynamic json) => Faction(
        name: json['name'] as String,
        subFactions: List.from(json['subFactions']),
      );
}

enum Factions {
  North,
//  South,
  PeaceRiver,
  // NuCoal,
  // CEF,
  // Caprice,
  // Utopia,
  // Eden,
  // Universal
}
