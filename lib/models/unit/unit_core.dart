import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';

class UnitCore {
  const UnitCore({
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
  final Roles? role;
  final Movement? movement;
  final int? armor;
  final int? hull;
  final int? structure;
  final int? actions;
  final int? gunnery;
  final int? piloting;
  final int? ew;
  final List<String> reactWeapons;
  final List<String> mountedWeapons;
  final List<String> traits;
  final String type;
  final String height;

  const UnitCore.test({
    this.name = 'test',
    this.tv = 5,
    this.role = const Roles(roles: [Role(name: RoleType.GP)]),
    this.movement = const Movement(type: 'G', rate: 7),
    this.armor = 6,
    this.hull = 3,
    this.structure = 3,
    this.actions = 1,
    this.gunnery = 4,
    this.piloting = 4,
    this.ew = 5,
    this.reactWeapons = const [],
    this.mountedWeapons = const [],
    this.traits = const [],
    this.type = 'gear',
    this.height = '1.5',
  });

  factory UnitCore.fromJson(dynamic json) => UnitCore(
        name: json['model'] as String,
        tv: json['tv'] as int,
        role: json['role'] == 'N/A' || json['role'] == '-'
            ? null
            : Roles.fromJson(json['role']),
        movement: json['mr'] == '-' ? null : Movement.fromJson(json['mr']),
        armor: json['arm'] == '-' ? null : json['arm'] as int,
        hull: json['h/s'] == '-'
            ? null
            : int.parse(json['h/s'].toString().split("/").first),
        structure: json['h/s'] == '-'
            ? null
            : int.parse(json['h/s'].toString().split("/").last),
        actions: json['a'] == '-' ? null : json['a'] as int,
        gunnery: json['gu'].toString() == '-'
            ? null
            : int.parse(json['gu'].toString().substring(0, 1)),
        piloting: json['pi'].toString() == '-'
            ? null
            : int.parse(json['pi'].toString().substring(0, 1)),
        ew: json['ew'].toString() == '-'
            ? null
            : int.parse(json['ew'].toString().substring(0, 1)),
        reactWeapons: json['react-weapons'] == '-'
            ? []
            : List.from(json['react-weapons'].toString().split(',')),
        mountedWeapons: json['mounted-weapons'] == '-'
            ? []
            : List.from(json['mounted-weapons'].toString().split(',')),
        traits: List.from(json['traits'].toString().split(',')),
        type: json['type'],
        height: json['height'].toString(),
      );

  @override
  String toString() {
    var r = this.role == null ? 'N/A' : '${this.role}';
    var m = this.movement == null ? '-' : '${this.movement}';
    var a = this.actions == null ? '-' : '${this.actions}';
    var ar = this.armor == null ? '-' : '${this.armor}';
    var g = this.gunnery == null ? '-' : '${this.gunnery}+';
    var p = this.piloting == null ? '-' : '${this.piloting}+';
    var e = this.ew == null ? '-' : '${this.ew}+';
    var h = this.hull == null ? '-' : '${this.hull}';
    var s = this.structure == null ? '-' : '${this.structure}';
    var hs = h == '-' && s == '-' ? '-' : '$h/$s';
    return "UnitCore: " +
        "{Name: ${this.name} " +
        "TV: ${this.tv} " +
        "Role: $r " +
        "MR: $m " +
        "ARM: $ar " +
        "H/S: $hs " +
        "A: $a " +
        "GU: $g " +
        "PI: $p " +
        "EW: $e " +
        "React Weapons: ${this.reactWeapons} " +
        "Mounted Weapons: ${this.mountedWeapons} " +
        "Traits: ${this.traits} " +
        "Type: ${this.type} " +
        "Height: ${this.height} " +
        "}";
  }
}
