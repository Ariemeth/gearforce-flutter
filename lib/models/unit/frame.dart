import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/unit_upgrades.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Frame {
  const Frame({
    required this.name,
    required this.variants,
    this.availableUpgrades = const [],
  });

  final String name;
  final List<UnitCore> variants;
  final List<Modification> availableUpgrades;

  factory Frame.fromJson(dynamic json) => Frame(
        name: json['name'] as String,
        variants: (json['variants'] as List)
            .map((j) => UnitCore.fromJson(j, frame: json['name'] as String))
            .toList(),
        availableUpgrades: getUnitMods(json['name']),
      );
}
