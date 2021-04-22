import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/factions.dart';

final String factionFile = 'assets/data/factions.json';

class Data {
  List<Faction> _factions = [];

  List<Faction> factions() {
    return _factions;
  }

  Future<void> load() async {
    await _loadFactions();
  }

  Future<void> _loadFactions() async {
    var jsonData = await rootBundle.loadString(factionFile);
    var decodedData = json.decode(jsonData) as List;
    _factions = decodedData.map((f) => Faction.fromJson(f)).toList();
  }
}
