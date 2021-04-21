import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/factions/factions.dart';

class Data {
  List<Faction>? _factions;

  List<Faction>? factions() {
    return _factions;
  }

  Future<void> load() async {
    await loadFactions().then((value) => _factions = value);
  }
}

final String factionFile = 'data/factions.json';

Future<List<Faction>> loadFactions() async {
  var jsonData = await rootBundle.loadString(factionFile);
  var decodedData = json.decode(jsonData) as List;
  List<Faction> factions = decodedData.map((f) => Faction.fromJson(f)).toList();

  return factions;
}
