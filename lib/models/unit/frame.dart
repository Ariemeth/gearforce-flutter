import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Frame {
  const Frame({
    required this.name,
    required this.variants,
    this.upgrades = const [],
  });

  final String name;
  final List<UnitCore> variants;
  final List<Modification> upgrades;

  factory Frame.fromJson(dynamic json) => Frame(
        name: json['name'] as String,
        variants: (json['variants'] as List)
            .map((j) => UnitCore.fromJson(j, frame: json['name'] as String))
            .toList(),
        upgrades: [],
      );
}
