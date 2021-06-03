import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/frame.dart';
import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const String _factionFile = 'assets/data/factions.json';

const Map<Factions, String> _factionUnitFiles = {
  Factions.BlackTalon: 'assets/data/units/black_talon.json',
  Factions.CEF: 'assets/data/units/cef.json',
  Factions.Caprice: 'assets/data/units/caprice.json',
  Factions.Eden: 'assets/data/units/eden.json',
  Factions.North: 'assets/data/units/north.json',
  Factions.NuCoal: 'assets/data/units/nucoal.json',
  Factions.PeaceRiver: 'assets/data/units/peace_river.json',
  Factions.South: 'assets/data/units/south.json',
  Factions.Terrain: 'assets/data/units/terrain.json',
  Factions.Universal: 'assets/data/units/universal.json',
  Factions.Utopia: 'assets/data/units/utopia.json',
};

class Data {
  late List<Faction> _factions = [];

  final Map<Factions, List<Frame>> _factionFrames = {};

  /// Retrieves a list of factions.
  List<Faction> factions() {
    return _factions;
  }

  /// Returns a list of Modifications for a specific [faction]'s [frame]
  ///
  /// If no frames are found for a [faction] or there are no modifications
  /// found, the returned list will be empty.
  List<Modification> availableUnitMods(Factions faction, String frame) {
    var l = _factionFrames[faction];
    return l == null
        ? []
        : l.where((element) => element.name == frame).first.upgrades;
  }

  /// Returns a list of UnitCore's for the specified [faction] and [role] if
  /// available.
  ///
  /// If no UnitCore's are available to match the specified [faction] and [role]
  /// the returned list will be empty.  If [role] is null or not specified all
  /// UnitCore's of the specified [faction] will be returned.
  List<UnitCore> unitList(Factions faction, {RoleType? role}) {
    List<Frame>? factionUnit = _factionFrames[faction];

    if (factionUnit == null) {
      return [];
    }

    List<UnitCore> ulist = [];

    factionUnit.forEach((f) {
      ulist.addAll(f.variants);
    });
    return role == null
        ? ulist
        : ulist.where((element) => element.role!.includesRole(role)).toList();
  }

  /// This function loads all needed data resources.
  ///
  /// This function will not return/complete until all resources have been loaded.
  Future<void> load() async {
    try {
      await _loadFactions().then(
        (value) => this._factions = value,
      );
    } catch (e) {
      print('Exception caught loading factions: $e');
    }

    await Future.forEach<Factions>(_factionUnitFiles.keys, (key) async {
      String? filename = _factionUnitFiles[key];
      try {
        await _loadFrames(filename!).then(
          (value) => _factionFrames[key] = value,
        );
      } catch (e) {
        print('Exception caught loading $key from $filename: $e');
      }
    });
  }

  Future<List<Faction>> _loadFactions() async {
    var jsonData = await rootBundle.loadString(_factionFile);
    var decodedData = json.decode(jsonData) as List;
    return decodedData.map((f) => Faction.fromJson(f)).toList();
  }

  Future<List<Frame>> _loadFrames(String filename) async {
    var jsonData = await rootBundle.loadString(filename);
    var decodedData = json.decode(jsonData)['frames'] as List;
    return decodedData.map((f) => Frame.fromJson(f)).toList();
  }
}
