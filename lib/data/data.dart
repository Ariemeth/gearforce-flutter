import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/frame.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const Map<FactionType, String> _factionUnitFiles = {
  FactionType.Airstrike: 'assets/data/units/air_strike.json',
  FactionType.BlackTalon: 'assets/data/units/black_talon.json',
  FactionType.CEF: 'assets/data/units/cef.json',
  FactionType.Caprice: 'assets/data/units/caprice.json',
  FactionType.Eden: 'assets/data/units/eden.json',
  FactionType.North: 'assets/data/units/north.json',
  FactionType.NuCoal: 'assets/data/units/nucoal.json',
  FactionType.PeaceRiver: 'assets/data/units/peace_river.json',
  FactionType.South: 'assets/data/units/south.json',
  FactionType.Terrain: 'assets/data/units/terrain.json',
  FactionType.Universal: 'assets/data/units/universal.json',
  FactionType.Universal_TerraNova: 'assets/data/units/universal_terranova.json',
  FactionType.Universal_Non_TerraNova:
      'assets/data/units/universal_non_terranova.json',
  FactionType.Utopia: 'assets/data/units/utopia.json',
};

class Data {
  late List<Faction> _factions = [];

  final Map<FactionType, List<Frame>> _factionFrames = {};

  /// Retrieves a list of factions.
  List<Faction> factions() {
    return _factions.toList();
  }

  /// Returns a list of UnitCore's for the specified [faction] and [role] if
  /// available.
  ///
  /// If no UnitCore's are available to match the specified [faction] and [role]
  /// the returned list will be empty.  If [role] is null or not specified all
  /// UnitCore's of the specified [faction] will be returned.
  List<UnitCore> unitList(
    FactionType faction, {
    List<RoleType?>? role,
    List<String>? characterFilter,
    bool Function(UnitCore)? filter,
    bool includeTerrain = true,
    bool includeAirstrikeTokens = true,
    bool includeUniversal = true,
  }) {
    List<Frame>? factionUnits = _factionFrames[faction]!.toList();

    switch (faction) {
      case FactionType.North:
      case FactionType.South:
      case FactionType.NuCoal:
      case FactionType.PeaceRiver:
      case FactionType.BlackTalon:
        if (includeUniversal) {
          var uniList = _factionFrames[FactionType.Universal_TerraNova];
          if (uniList != null) {
            factionUnits.addAll(uniList.toList());
          }
          var fullUniList = _factionFrames[FactionType.Universal];
          if (fullUniList != null) {
            factionUnits.addAll(fullUniList.toList());
          }
        }
        break;
      case FactionType.CEF:
      case FactionType.Caprice:
      case FactionType.Utopia:
      case FactionType.Eden:
        if (includeUniversal) {
          var uniList = _factionFrames[FactionType.Universal_Non_TerraNova];
          if (uniList != null) {
            factionUnits.addAll(uniList.toList());
          }
          var fullUniList = _factionFrames[FactionType.Universal];
          if (fullUniList != null) {
            factionUnits.addAll(fullUniList.toList());
          }
        }
        break;
      case FactionType.Universal:
        break;
      case FactionType.Universal_Non_TerraNova:
        break;
      case FactionType.Universal_TerraNova:
        break;
      case FactionType.Terrain:
        break;
      case FactionType.Airstrike:
        break;
    }

    if (includeTerrain && faction != FactionType.Terrain) {
      final terrainList = _factionFrames[FactionType.Terrain];
      if (terrainList != null) {
        factionUnits.addAll(terrainList);
      }
    }

    if (includeAirstrikeTokens && faction != FactionType.Airstrike) {
      final airstrikeTokens = _factionFrames[FactionType.Airstrike];
      if (airstrikeTokens != null) {
        factionUnits.addAll(airstrikeTokens);
      }
    }

    List<UnitCore> results = [];
    factionUnits.forEach((f) {
      filter != null
          ? results.addAll(f.variants.where(filter))
          : results.addAll(f.variants);
    });

    if (role != null && role.isNotEmpty) {
      results = results.where((uc) {
        if (uc.role != null) {
          return uc.role!.includesRole(role);
        }
        return false;
      }).toList();
    }

    return characterFilter == null
        ? results
        : results.where((uc) => uc.contains(characterFilter)).toList();
  }

  /// This function loads all needed data resources.
  ///
  /// This function will not return/complete until all resources have been loaded.
  Future<void> load() async {
    this._factions = _loadFactions();

    await Future.forEach<FactionType>(_factionUnitFiles.keys, (key) async {
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

  List<Faction> _loadFactions() {
    return [
      Faction.blackTalons(this),
      Faction.caprice(this),
      Faction.cef(this),
      Faction.eden(this),
      Faction.north(this),
      Faction.nucoal(this),
      Faction.peaceRiver(this),
      Faction.south(this),
      Faction.utopia(this),
    ];
  }

  Future<List<Frame>> _loadFrames(String filename) async {
    var jsonData = await rootBundle.loadString(filename);
    var decodedData = json.decode(jsonData)['frames'] as List;
    return decodedData.map((f) => Frame.fromJson(f)).toList();
  }
}
