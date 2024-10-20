import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/movement.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

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
    required this.weapons,
    required this.traits,
    required this.type,
    required this.height,
    this.frame = '',
    this.faction = FactionType.None,
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
  final List<Weapon> weapons;
  final List<Trait> traits;
  final ModelType type;
  final String height;
  final String frame;
  final FactionType faction;

  const UnitCore.test(
      {this.name = 'test',
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
      this.weapons = const [],
      this.traits = const [],
      this.type = ModelType.Gear,
      this.height = '1.5',
      this.frame = 'none',
      this.faction = FactionType.None});

  dynamic attribute(UnitAttribute att) {
    switch (att) {
      case UnitAttribute.name:
        return this.name;
      case UnitAttribute.tv:
        return this.tv;
      case UnitAttribute.roles:
        return this.role;
      case UnitAttribute.movement:
        return this.movement;
      case UnitAttribute.armor:
        return this.armor;
      case UnitAttribute.hull:
        return this.hull;
      case UnitAttribute.structure:
        return this.structure;
      case UnitAttribute.actions:
        return this.actions;
      case UnitAttribute.gunnery:
        return this.gunnery;
      case UnitAttribute.piloting:
        return this.piloting;
      case UnitAttribute.ew:
        return this.ew;
      case UnitAttribute.weapons:
        return this.weapons;
      case UnitAttribute.traits:
        return this.traits;
      case UnitAttribute.type:
        return this.type;
      case UnitAttribute.height:
        return this.height;
      case UnitAttribute.special:
        return [];
      case UnitAttribute.cp:
        return 0;
      case UnitAttribute.sp:
        var value = 0;
        traits.where((t) => t.isSameType(Trait.SP(0))).forEach((t) {
          value += t.level ?? 0;
        });
        return value;
    }
  }

  bool contains(List<String> criteria) {
    if (criteria.isEmpty) {
      return true;
    }
    for (var i = 0; i < criteria.length; i++) {
      if (criteria[i].isEmpty) {
        continue;
      }

      var c = criteria[i].toLowerCase();

      if (this.name.toLowerCase().contains(c)) {
        return true;
      }

      if (this.tv.toString().contains(c)) {
        return true;
      }

      if (this.movement != null && this.movement.toString().contains(c)) {
        return true;
      }

      if (this.armor != null && this.armor.toString().contains(c)) {
        return true;
      }

      if (this.hull != null && this.hull.toString().contains(c)) {
        return true;
      }

      if (this.structure != null && this.structure.toString().contains(c)) {
        return true;
      }

      if (this.actions != null && this.actions.toString().contains(c)) {
        return true;
      }

      if (this.gunnery != null && '${this.gunnery.toString()}+'.contains(c)) {
        return true;
      }

      if (this.piloting != null && '${this.piloting.toString()}+'.contains(c)) {
        return true;
      }

      if (this.ew != null && '${this.ew.toString()}+'.contains(c)) {
        return true;
      }

      if (this.role != null &&
          this.role!.roles.toString().toLowerCase().split(',').contains(c)) {
        return true;
      }

      if (this.weapons.toString().toLowerCase().contains(c)) {
        return true;
      }

      if (this.traits.toString().toLowerCase().contains(c)) {
        return true;
      }

      if (this.type.name.toLowerCase().contains(c)) {
        return true;
      }
      if (this.height.toLowerCase().contains(c)) {
        return true;
      }
    }
    return false;
  }

  factory UnitCore.fromJson(
    dynamic json, {
    String frame = '',
    FactionType faction = FactionType.None,
  }) {
    final reactWeaponsJson = json['react-weapons'];
    List<Weapon> reactWeapons = (reactWeaponsJson == null ||
            reactWeaponsJson == '-' ||
            reactWeaponsJson == "")
        ? []
        : List.from(json['react-weapons']
            .toString()
            .split(',')
            .map<Weapon?>((e) => buildWeapon(e.trim(), hasReact: true))
            .whereType<Weapon>()
            .toList());

    final mountedWeaponsJson = json['mounted-weapons'];
    List<Weapon> mountedWeapons = (mountedWeaponsJson == null ||
            mountedWeaponsJson == '-' ||
            mountedWeaponsJson == "")
        ? []
        : List.from(json['mounted-weapons']
            .toString()
            .split(',')
            .map<Weapon?>((e) => buildWeapon(e.trim()))
            .whereType<Weapon>()
            .toList());

    final traitsJson = json['traits'];
    List<Trait> traits =
        (traitsJson == null || traitsJson == '-' || traitsJson == "")
            ? []
            : List.from(json['traits']
                .toString()
                .split(',')
                .map((e) => Trait.fromString(e.trim()))
                .toList());

    var uc = UnitCore(
      frame: frame,
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
      weapons: [...reactWeapons, ...mountedWeapons],
      traits: traits,
      type: ModelType.fromName(json['type']),
      height: json['height'].toString(),
      faction: faction,
    );

    return uc;
  }
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
        "Weapons: ${this.weapons} " +
        "Traits: ${this.traits} " +
        "Type: ${this.type} " +
        "Height: ${this.height} " +
        "Frame: ${this.frame}" +
        "Faction: ${this.faction}" +
        "}";
  }
}
