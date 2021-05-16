import 'package:gearforce/models/unit/movement.dart';

class Unit {
  const Unit({
    required this.name,
    required this.tv,
    required this.role,
    required this.movement,
    required this.armor,
    required this.hull,
    required this.structure,
    required this.actions,
    required this.gunnery,
    required this.piloting,
    required this.ew,
    required this.reactWeapons,
    required this.mountedWeapons,
    required this.traits,
    required this.type,
    required this.height,
  });
  final String name;
  final int tv;
  final List<String> role;
  final Movement movement;
  final int armor;
  final int hull;
  final int structure;
  final int actions;
  final int gunnery;
  final int piloting;
  final int ew;
  final List<String> reactWeapons;
  final List<String> mountedWeapons;
  final List<String> traits;
  final String type;
  final String height;

  factory Unit.fromJson(dynamic json) => Unit(
        name: json['model'] as String,
        tv: json['tv'] as int,
        role: List.from(json['role'].toString().split(",")),
        movement: Movement.fromJson(json['mr']),
        armor: json['arm'] as int,
        hull: int.parse(json['h/s'].toString().split("/").first),
        structure: int.parse(json['h/s'].toString().split("/").last),
        actions: json['a'] as int,
        gunnery: json['gu'] as int,
        piloting: json['pi'] as int,
        ew: json['ew'] as int,
        reactWeapons: List.from(json['react-weapons']),
        mountedWeapons: List.from(json['mounted-weapons']),
        traits: List.from(json['traits']),
        type: json['type'],
        height: json['height'],
      );

  @override
  String toString() {
    return "Unit: " +
        "{Name: ${this.name} " +
        "TV: ${this.tv} " +
        "Role: ${this.role} " +
        "MR: ${this.movement} " +
        "ARM: ${this.armor} " +
        "H/S: ${this.hull}/${this.structure} " +
        "A: ${this.actions} " +
        "GU: ${this.gunnery}+ " +
        "PI: ${this.piloting}+ " +
        "EW: ${this.ew}+ " +
        "React Weapons: ${this.reactWeapons} " +
        "Mounted Weapons: ${this.mountedWeapons} " +
        "Traits: ${this.traits} " +
        "Type: ${this.type} " +
        "Height: ${this.height} " +
        "}";
  }
}
