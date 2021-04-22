class Faction {
  String name;
  List<String> subFactions;

  Faction(this.name, this.subFactions);

  factory Faction.fromJson(dynamic json) => Faction(
        json['name'] as String,
        List.from(json['subFactions']),
      );
}
