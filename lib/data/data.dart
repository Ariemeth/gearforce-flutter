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
  List<Faction> _factions = [];
  List<Unit> _blackTalon = [];
  List<Unit> _caprice = [];
  List<Unit> _cef = [];
  List<Unit> _eden = [];
  List<Unit> _north = [];
  List<Unit> _nucoal = [];
  List<Unit> _terrain = [];
  List<Unit> _universal = [];
  List<Unit> _utopia = [];
  List<Unit> _peaceRiver = [];
  List<Unit> _south = [];

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
    await _loadFactions().then((value) => this._factions = value);
    await _loadUnits(_northFile).then((value) => this._north = value);
    await _loadUnits(_southFile).then((value) => this._south = value);
    await _loadUnits(_blackTalonFile).then((value) => this._blackTalon = value);
    await _loadUnits(_capriceFile).then((value) => this._caprice = value);
    await _loadUnits(_cefFile).then((value) => this._cef = value);
    await _loadUnits(_edenFile).then((value) => this._eden = value);
    await _loadUnits(_nucoalFile).then((value) => this._nucoal = value);
    await _loadUnits(_terrainFile).then((value) => this._terrain = value);
    await _loadUnits(_universalFile).then((value) => this._universal = value);
    await _loadUnits(_utopiaFile).then((value) => this._utopia = value);
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
