import 'package:gearforce/models/unit/unit_core.dart';

class Frame {
  const Frame({
    required this.name,
    required this.variants,
  })  : assert(name != ''),
        assert(variants.length > 0, 'no variants for $name');

  final String name;
  final List<UnitCore> variants;

  factory Frame.fromJson(dynamic json) => Frame(
        name: json['name'] as String,
        variants: (json['variants'] as List)
            .map((j) => UnitCore.fromJson(j, frame: json['name'] as String))
            .toList(),
      );
}
