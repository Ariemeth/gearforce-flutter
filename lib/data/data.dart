import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/frame.dart';
import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

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
  late List<Frame> _blackTalon = [];
  late List<Frame> _caprice = [];
  late List<Frame> _cef = [];
  late List<Frame> _eden = [];
  late List<Frame> _north = [];
  late List<Frame> _nucoal = [];
  late List<Frame> _terrain = [];
  late List<Frame> _universal = [];
  late List<Frame> _utopia = [];
  late List<Frame> _peaceRiver = [];
  late List<Frame> _south = [];

  List<Faction> factions() {
    return _factions;
  }

  List<Modification> availableUnitMods(Factions f, String frame) {
    return f == Factions.North
        ? _north.where((element) => element.name == frame).first.upgrades
        : [];
  }

  List<UnitCore> unitList(Factions f, {RoleType? role}) {
    List<Frame> factionUnit;
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

    List<UnitCore> ulist = [];
    factionUnit.forEach((f) {
      ulist.addAll(f.variants);
    });
    return role == null
        ? ulist
        : ulist.where((element) => element.role!.includesRole(role)).toList();
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
      await _loadFrames(_northFile).then(
        (value) => this._north = value,
      );
    } catch (e) {
      print('Exception caught loading $_northFile: $e');
    }

    try {
      await _loadFrames(_southFile).then(
        (value) => this._south = value,
      );
    } catch (e) {
      print('Exception caught loading $_southFile: $e');
    }

    try {
      await _loadFrames(_blackTalonFile).then(
        (value) => this._blackTalon = value,
      );
    } catch (e) {
      print('Exception caught loading $_blackTalonFile: $e');
    }

    try {
      await _loadFrames(_capriceFile).then(
        (value) => this._caprice = value,
      );
    } catch (e) {
      print('Exception caught loading $_capriceFile: $e');
    }

    try {
      await _loadFrames(_cefFile).then(
        (value) => this._cef = value,
      );
    } catch (e) {
      print('Exception caught loading $_cefFile: $e');
    }

    try {
      await _loadFrames(_edenFile).then(
        (value) => this._eden = value,
      );
    } catch (e) {
      print('Exception caught loading $_edenFile: $e');
    }

    try {
      await _loadFrames(_nucoalFile).then(
        (value) => this._nucoal = value,
      );
    } catch (e) {
      print('Exception caught loading $_nucoalFile: $e');
    }

    try {
      await _loadFrames(_terrainFile).then(
        (value) => this._terrain = value,
      );
    } catch (e) {
      print('Exception caught loading $_terrainFile: $e');
    }

    try {
      await _loadFrames(_universalFile).then(
        (value) => this._universal = value,
      );
    } catch (e) {
      print('Exception caught loading $_universalFile: $e');
    }

    try {
      await _loadFrames(_utopiaFile).then(
        (value) => this._utopia = value,
      );
    } catch (e) {
      print('Exception caught loading $_utopiaFile: $e');
    }

    try {
      await _loadFrames(_peaceRiverFile).then(
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

  Future<List<Frame>> _loadFrames(String filename) async {
    var jsonData = await rootBundle.loadString(filename);
    var decodedData = json.decode(jsonData)['frames'] as List;
    return decodedData.map((f) => Frame.fromJson(f)).toList();
  }
}
