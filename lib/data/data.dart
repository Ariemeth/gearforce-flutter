import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/factions.dart';
import 'package:gearforce/models/unit/unit.dart';

final String _factionFile = 'assets/data/factions.json';
final String _northFile = 'assets/data/units/north.json';

class Data {
  List<Faction> _factions = [];
  List<Unit> _north = [];

  List<Faction> factions() {
    return _factions;
  }

  List<Unit> north() {
    return _north;
  }

  Future<void> load() async {
    await _loadFactions().then((value) => this._factions = value);
    await _loadUnits(_northFile).then((value) => this._north = value);
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
