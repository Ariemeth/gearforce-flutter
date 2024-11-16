import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';

class Frame {
  const Frame({
    required this.name,
    required this.variants,
    this.faction = FactionType.none,
  })  : assert(name != ''),
        assert(variants.length > 0, 'no variants for $name');

  final String name;
  final List<UnitCore> variants;
  final FactionType faction;

  factory Frame.fromJson(
    dynamic json, {
    FactionType faction = FactionType.none,
  }) =>
      Frame(
        name: json['name'] as String,
        variants: (json['variants'] as List)
            .map((j) => UnitCore.fromJson(
                  j,
                  frame: json['name'] as String,
                  faction: faction,
                ))
            .toList(),
        faction: faction,
      );
}
