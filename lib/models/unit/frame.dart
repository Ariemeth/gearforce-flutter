import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Frame {
  const Frame({
    required this.name,
    required this.variants,
    this.faction = FactionType.None,
  })  : assert(name != ''),
        assert(variants.length > 0, 'no variants for $name');

  final String name;
  final List<UnitCore> variants;
  final FactionType faction;

  factory Frame.fromJson(
    dynamic json, {
    FactionType faction = FactionType.None,
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
