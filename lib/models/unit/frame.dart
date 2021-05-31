import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Frame {
  const Frame({
    required this.name,
    required this.variants,
    this.manufacturer = '',
    this.unitType = '',
    this.height = '',
    this.weight = '',
    this.description = '',
    this.upgrades = const [],
  });

  final String name;
  final String manufacturer;
  final String unitType;
  final String height;
  final String weight;
  final String description;
  final List<UnitCore> variants;
  final List<Modification> upgrades;

  factory Frame.fromJson(dynamic json) => Frame(
        name: json['name'] as String,
        variants: (json['variants'] as List)
            .map((j) => UnitCore.fromJson(j))
            .toList(),
        manufacturer: json['manufacturer'] as String,
        unitType: json['unit type'] as String,
        height: json['height'] as String,
        weight: json['weight'] as String,
        description: json['description'] as String,
        upgrades: [],
      );
}
