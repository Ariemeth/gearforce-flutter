import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

final String _factionFile = 'assets/data/factions.json';
final String _northFile = 'assets/data/units/north.json';
final String _peaceRiverFile = 'assets/data/units/peace_river.json';

class Data {
  List<Faction> _factions = [];
  List<Unit> _north = [];
  List<Unit> _peaceRiver = [];

  List<Faction> factions() {
    return _factions;
  }

  List<Unit> unitList(Factions f, {RoleType? role}) {
    List<Unit> factionUnit;
    switch (f) {
      case Factions.North:
        factionUnit = _north;
        break;
      case Factions.PeaceRiver:
        factionUnit = _peaceRiver;
        break;
    }

    return role == null
        ? factionUnit
        : factionUnit.where((element) {
            return element.role.includesRole(role);
          }).toList();
  }

  Future<void> load() async {
    await _loadFactions().then((value) => this._factions = value);
    await _loadUnits(_northFile).then((value) => this._north = value);
    await _loadUnits(_peaceRiverFile).then((value) => this._peaceRiver = value);
  }

  Future<List<Faction>> _loadFactions() async {
    var jsonData = await rootBundle.loadString(_factionFile);
    var decodedData = json.decode(jsonData) as List;
    return decodedData.map((f) => Faction.fromJson(f)).toList();
  }

  Future<List<Unit>> _loadUnits(String filename) async {
    var jsonData = await rootBundle.loadString(filename);
    var decodedData = json.decode(jsonData) as List;
    return decodedData.map((f) => Unit.fromJson(f)).toList();
  }
}
