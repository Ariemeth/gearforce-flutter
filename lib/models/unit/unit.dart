import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Unit extends ChangeNotifier {
  Unit({
    required this.core,
  });

  Map<String, dynamic> toJson() => {
        'frame': core.frame,
        'variant': core.name,
        'mods': _mods.map((e) => e.name).toList(),
        'command': commandLevelString(_commandLevel)
      };

  factory Unit.fromJson(
    dynamic json,
    Data data,
    FactionType faction,
    String? subfaction,
  ) {
    var core = data
        .unitList(faction)
        .firstWhere((element) => element.name == json['variant']);
    Unit u = Unit(core: core);

    u._commandLevel = convertToCommand(json['command']);

    var decodedMods = json['mods'] as List;
    if (decodedMods.isNotEmpty) {
      var availableUnitMods = getUnitMods(u.core.frame);
      decodedMods.forEach((modeName) {
        try {
          var mod = availableUnitMods.firstWhere((mod) => mod.name == modeName);
          u.addUnitMod(mod);
        } on StateError catch (e) {
          print('mod $modeName not found in available mods, $e');
        }
      });
    }
    return u;
  }

  final UnitCore core;
  final List<BaseModification> _mods = [];
  CommandLevel _commandLevel = CommandLevel.none;
  List<String> _special = [];

  CommandLevel get commandLevel => _commandLevel;
  set commandLevel(CommandLevel cl) {
    _commandLevel = cl;
    notifyListeners();
  }

  bool get isDuelist {
    return this.traits.any((element) => element.name == 'Duelist');
  }

  bool isVeteran() {
    return this.traits.any((element) => element.name == 'Vet');
  }

  String get name {
    var value = this.core.name;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.name, value);
    }

    return value;
  }

  int tv() {
    var value = this.core.tv;
    value = value + commandTVCost(this._commandLevel);

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.tv, value);
    }

    return value;
  }

  Roles? role() {
    var value = this.core.role;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.roles, value);
    }

    return value;
  }

  Movement? get movement {
    var value = this.core.movement;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.movement, value);
    }

    return value;
  }

  int? get armor {
    var value = this.core.armor;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.armor, value);
    }
    return value;
  }

  int? get actions {
    var value = this.core.actions;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.actions, value);
    }
    return value;
  }

  int? get gunnery {
    var value = this.core.gunnery;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.gunnery, value);
    }
    return value;
  }

  int? get piloting {
    var value = this.core.piloting;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.piloting, value);
    }
    return value;
  }

  int? get ew {
    var value = this.core.ew;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.ew, value);
    }
    return value;
  }

  List<String> get reactWeapons {
    var value = this.core.reactWeapons.toList();

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.react_weapons, value);
    }

    return value;
  }

  List<String> get mountedWeapons {
    var value = this.core.mountedWeapons.toList();

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.mounted_weapons, value);
    }

    return value;
  }

  List<Trait> get traits {
    var value = this.core.traits.toList();

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.traits, value);
    }

    return value;
  }

  String get type {
    var value = this.core.type;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.type, value);
    }

    return value;
  }

  List<String> get special {
    var value = this._special.toList();
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.special, value);
    }
    return value;
  }

  dynamic attribute(UnitAttribute att) {
    var value = this.core.attribute(att);

    for (var mod in this._mods) {
      value = mod.applyMods(att, value);
    }

    return value;
  }

  void addUnitMod(BaseModification mod) {
    _mods.add(mod);
    notifyListeners();
  }

  void removeUnitMod(String id) {
    _mods.removeWhere((mod) => mod.id == id);
    notifyListeners();
  }

  bool hasMod(String id) => this
      ._mods
      .where((element) => element.name == id || element.id == id)
      .isNotEmpty;

  BaseModification? getMod(String id) {
    if (!this.hasMod(id)) {
      return null;
    }
    return this._mods.firstWhere((mod) => mod.id == id);
  }

  int numUnitMods() => _mods.length;
  void clearUnitMods() {
    _mods.clear();
    notifyListeners();
  }
}
