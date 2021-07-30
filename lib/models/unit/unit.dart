import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/mods/modification.dart';
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
  final List<Modification> _mods = [];
  CommandLevel _commandLevel = CommandLevel.none;

  CommandLevel commandLevel() => _commandLevel;

  void makeCommand(CommandLevel cl) {
    _commandLevel = cl;
    notifyListeners();
  }

  bool isDuelist = false;
  bool isVeteran() {
    String? value = this
        .core
        .traits
        .firstWhere((element) => element.contains("Vet"), orElse: () {
      return '';
    });
    return value == '' ? false : true;
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

  List<String> get reactWeapons {
    var value = this.core.reactWeapons;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.react_weapons, value);
    }

    return value;
  }

  List<String> get mountedWeapons {
    var value = this.core.mountedWeapons;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.mounted_weapons, value);
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

  void addUnitMod(Modification mod) {
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

  int numUnitMods() => _mods.length;
  void clearUnitMods() {
    _mods.clear();
    notifyListeners();
  }
}
