import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/factions.dart';
import 'package:gearforce/models/unit/unit.dart';

final String factionFile = 'assets/data/factions.json';
final String northFile = 'assets/data/units/north.json';

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
    await _loadFactions();
    await _loadNorth();
  }

  Future<void> _loadFactions() async {
    var jsonData = await rootBundle.loadString(factionFile);
    var decodedData = json.decode(jsonData) as List;
    _factions = decodedData.map((f) => Faction.fromJson(f)).toList();
  }

  Future<void> _loadNorth() async {
    var jsonData = await rootBundle.loadString(northFile);
    var decodedData = json.decode(jsonData) as List;
    _north = decodedData.map((f) => Unit.fromJson(f)).toList();
    // DEBUG printing
    print(_north);
  }
}
