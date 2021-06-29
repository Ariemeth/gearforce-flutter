import 'package:flutter/cupertino.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Unit extends ChangeNotifier {
  Unit({
    required this.core,
  });

  final UnitCore core;
  final List<Modification> _unitMods = [];
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

  int tv() {
    var value = this.core.tv;
    value = value + commandTVCost(this._commandLevel);

    for (var mod in this._unitMods) {
      value = mod.applyMods(UnitAttribute.tv, value);
    }

    return value;
  }

  Roles? role() {
    var value = this.core.role;

    for (var mod in this._unitMods) {
      value = mod.applyMods(UnitAttribute.roles, value);
    }

    return value;
  }

  dynamic attribute(UnitAttribute att) {
    var value = this.core.attribute(att);

    for (var mod in this._unitMods) {
      value = mod.applyMods(att, value);
    }

    return value;
  }

  void addUnitMod(Modification mod) {
    _unitMods.add(mod);
    notifyListeners();
  }

  void removeUnitMod(String modName) {
    _unitMods.removeWhere((mod) => mod.name == modName);
    notifyListeners();
  }

  int numUnitMods() => _unitMods.length;
  void clearUnitMods() {
    _unitMods.clear();
    notifyListeners();
  }
}
