import 'package:gearforce/models/unit/movement.dart';

class Unit {
  const Unit({
    required this.name,
    required this.tv,
    required this.ua,
    required this.movement,
    required this.armor,
    required this.hull,
    required this.structure,
    required this.actions,
    required this.gunnery,
    required this.piloting,
    required this.ew,
    required this.weapons,
    required this.traits,
    required this.type,
    required this.height,
  });
  final String name;
  final int tv;
  final List<String> ua;
  final Movement movement;
  final int armor;
  final int hull;
  final int structure;
  final int actions;
  final int gunnery;
  final int piloting;
  final int ew;
  final List<String> weapons;
  final List<String> traits;
  final String type;
  final String height;

  factory Unit.fromJson(dynamic json) => Unit(
        name: json['model'] as String,
        tv: json['tv'] as int,
        ua: List.from(json['ua'].toString().split(",")),
        movement: Movement.fromJson(json['mr']),
        armor: json['ar'] as int,
        hull: int.parse(json['h/s'].toString().split("/").first),
        structure: int.parse(json['h/s'].toString().split("/").last),
        actions: json['a'] as int,
        gunnery: json['gu'] as int,
        piloting: json['pi'] as int,
        ew: json['ew'] as int,
        weapons: List.from(json['weapons']),
        traits: List.from(json['traits']),
        type: json['type/height'].toString().split(" ").first,
        height: json['type/height'].toString().split(" ").last,
      );

  @override
  String toString() {
    return "Unit: " +
        "{Name: ${this.name} " +
        "TV: ${this.tv} " +
        "UA: ${this.ua} " +
        "MR: ${this.movement} " +
        "AR: ${this.armor} " +
        "H/S: ${this.hull}/${this.structure} " +
        "A: ${this.actions} " +
        "GU: ${this.gunnery}+ " +
        "PI: ${this.piloting}+ " +
        "EW: ${this.ew}+ " +
        "Weapons: ${this.weapons} " +
        "Traits: ${this.traits} " +
        "Type: ${this.type} " +
        "Height: ${this.height} " +
        "}";
  }
}
