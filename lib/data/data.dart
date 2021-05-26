import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

const String _factionFile = 'assets/data/factions.json';

const String _blackTalonFile = 'assets/data/units/black_talon.json';
const String _capriceFile = 'assets/data/units/caprice.json';
const String _cefFile = 'assets/data/units/cef.json';
const String _edenFile = 'assets/data/units/eden.json';
const String _northFile = 'assets/data/units/north.json';
const String _nucoalFile = 'assets/data/units/nucoal.json';
const String _terrainFile = 'assets/data/units/terrain.json';
const String _universalFile = 'assets/data/units/universal.json';
const String _utopiaFile = 'assets/data/units/utopia.json';
const String _peaceRiverFile = 'assets/data/units/peace_river.json';
const String _southFile = 'assets/data/units/south.json';

class Data {
  late List<Faction> _factions = [];
  late List<Unit> _blackTalon = [];
  late List<Unit> _caprice = [];
  late List<Unit> _cef = [];
  late List<Unit> _eden = [];
  late List<Unit> _north = [];
  late List<Unit> _nucoal = [];
  late List<Unit> _terrain = [];
  late List<Unit> _universal = [];
  late List<Unit> _utopia = [];
  late List<Unit> _peaceRiver = [];
  late List<Unit> _south = [];

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
      case Factions.South:
        factionUnit = _south;
        break;
      case Factions.NuCoal:
        factionUnit = _nucoal;
        break;
      case Factions.CEF:
        factionUnit = _cef;
        break;
      case Factions.Caprice:
        factionUnit = _caprice;
        break;
      case Factions.Utopia:
        factionUnit = _utopia;
        break;
      case Factions.Eden:
        factionUnit = _eden;
        break;
      case Factions.Universal:
        factionUnit = _universal;
        break;
      case Factions.Terrain:
        factionUnit = _terrain;
        break;
      case Factions.BlackTalon:
        factionUnit = _blackTalon;
        break;
    }

    return role == null
        ? factionUnit
        : factionUnit.where((element) {
            return element.role.includesRole(role);
          }).toList();
  }

  Future<void> load() async {
    try {
      await _loadFactions().then(
        (value) => this._factions = value,
      );
    } catch (e) {
      print('Exception caught loading factions: $e');
    }
    try {
      await _loadUnits(_northFile).then(
        (value) => this._north = value,
      );
    } catch (e) {
      print('Exception caught loading $_northFile: $e');
    }
    try {
      await _loadUnits(_southFile).then(
        (value) => this._south = value,
      );
    } catch (e) {
      print('Exception caught loading $_southFile: $e');
    }
    try {
      await _loadUnits(_blackTalonFile).then(
        (value) => this._blackTalon = value,
      );
    } catch (e) {
      print('Exception caught loading $_blackTalonFile: $e');
    }
    try {
      await _loadUnits(_capriceFile).then(
        (value) => this._caprice = value,
      );
    } catch (e) {
      print('Exception caught loading $_capriceFile: $e');
    }
    try {
      await _loadUnits(_cefFile).then(
        (value) => this._cef = value,
      );
    } catch (e) {
      print('Exception caught loading $_cefFile: $e');
    }
    try {
      await _loadUnits(_edenFile).then(
        (value) => this._eden = value,
      );
    } catch (e) {
      print('Exception caught loading $_edenFile: $e');
    }
    try {
      await _loadUnits(_nucoalFile).then(
        (value) => this._nucoal = value,
      );
    } catch (e) {
      print('Exception caught loading $_nucoalFile: $e');
    }
    try {
      await _loadUnits(_terrainFile).then(
        (value) => this._terrain = value,
      );
    } catch (e) {
      print('Exception caught loading $_terrainFile: $e');
    }
    try {
      await _loadUnits(_universalFile).then(
        (value) => this._universal = value,
      );
    } catch (e) {
      print('Exception caught loading $_universalFile: $e');
    }

    try {
      await _loadUnits(_utopiaFile).then(
        (value) => this._utopia = value,
      );
    } catch (e) {
      print('Exception caught loading $_utopiaFile: $e');
    }
    try {
      await _loadUnits(_peaceRiverFile).then(
        (value) => this._peaceRiver = value,
      );
    } catch (e) {
      print('Exception caught loading $_peaceRiverFile: $e');
    }
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
