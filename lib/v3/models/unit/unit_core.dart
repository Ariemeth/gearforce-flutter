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
    this.faction = FactionType.none,
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
      this.role = const Roles(roles: [Role(name: RoleType.gp)]),
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
      this.type = ModelType.gear,
      this.height = '1.5',
      this.frame = 'none',
      this.faction = FactionType.none});

  dynamic attribute(UnitAttribute att) {
    switch (att) {
      case UnitAttribute.name:
        return name;
      case UnitAttribute.tv:
        return tv;
      case UnitAttribute.roles:
        return role;
      case UnitAttribute.movement:
        return movement;
      case UnitAttribute.armor:
        return armor;
      case UnitAttribute.hull:
        return hull;
      case UnitAttribute.structure:
        return structure;
      case UnitAttribute.actions:
        return actions;
      case UnitAttribute.gunnery:
        return gunnery;
      case UnitAttribute.piloting:
        return piloting;
      case UnitAttribute.ew:
        return ew;
      case UnitAttribute.weapons:
        return weapons;
      case UnitAttribute.traits:
        return traits;
      case UnitAttribute.type:
        return type;
      case UnitAttribute.height:
        return height;
      case UnitAttribute.special:
        return [];
      case UnitAttribute.cp:
        return 0;
      case UnitAttribute.sp:
        var value = 0;
        traits.where((t) => t.isSameType(Trait.sp(0))).forEach((t) {
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

      if (name.toLowerCase().contains(c)) {
        return true;
      }

      if (tv.toString().contains(c)) {
        return true;
      }

      if (movement != null && movement.toString().contains(c)) {
        return true;
      }

      if (armor != null && armor.toString().contains(c)) {
        return true;
      }

      if (hull != null && hull.toString().contains(c)) {
        return true;
      }

      if (structure != null && structure.toString().contains(c)) {
        return true;
      }

      if (actions != null && actions.toString().contains(c)) {
        return true;
      }

      if (gunnery != null && '${gunnery.toString()}+'.contains(c)) {
        return true;
      }

      if (piloting != null && '${piloting.toString()}+'.contains(c)) {
        return true;
      }

      if (ew != null && '${ew.toString()}+'.contains(c)) {
        return true;
      }

      if (role != null &&
          role!.roles.toString().toLowerCase().split(',').contains(c)) {
        return true;
      }

      if (weapons.toString().toLowerCase().contains(c)) {
        return true;
      }

      if (traits.toString().toLowerCase().contains(c)) {
        return true;
      }

      if (type.name.toLowerCase().contains(c)) {
        return true;
      }
      if (height.toLowerCase().contains(c)) {
        return true;
      }
    }
    return false;
  }

  factory UnitCore.fromJson(
    dynamic json, {
    String frame = '',
    FactionType faction = FactionType.none,
  }) {
    final reactWeaponsJson = json['react-weapons'];
    List<Weapon> reactWeapons = (reactWeaponsJson == null ||
            reactWeaponsJson == '-' ||
            reactWeaponsJson == '')
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
            mountedWeaponsJson == '')
        ? []
        : List.from(json['mounted-weapons']
            .toString()
            .split(',')
            .map<Weapon?>((e) => buildWeapon(e.trim()))
            .whereType<Weapon>()
            .toList());

    final traitsJson = json['traits'];
    List<Trait> traits =
        (traitsJson == null || traitsJson == '-' || traitsJson == '')
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
          : int.parse(json['h/s'].toString().split('/').first),
      structure: json['h/s'] == '-'
          ? null
          : int.parse(json['h/s'].toString().split('/').last),
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
    var r = role == null ? 'N/A' : '$role';
    var m = movement == null ? '-' : '$movement';
    var a = actions == null ? '-' : '$actions';
    var ar = armor == null ? '-' : '$armor';
    var g = gunnery == null ? '-' : '$gunnery+';
    var p = piloting == null ? '-' : '$piloting+';
    var e = ew == null ? '-' : '$ew+';
    var h = hull == null ? '-' : '$hull';
    var s = structure == null ? '-' : '$structure';
    var hs = h == '-' && s == '-' ? '-' : '$h/$s';
    return 'UnitCore: ' +
        '{Name: $name ' +
        'TV: $tv ' +
        'Role: $r ' +
        'MR: $m ' +
        'ARM: $ar ' +
        'H/S: $hs ' +
        'A: $a ' +
        'GU: $g ' +
        'PI: $p ' +
        'EW: $e ' +
        'Weapons: $weapons ' +
        'Traits: $traits ' +
        'Type: $type ' +
        'Height: $height ' +
        'Frame: $frame' +
        'Faction: $faction' +
        '}';
  }
}
