import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/data/unit_filter.dart';
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

  /// Returns a list of UnitCore's for the specified [baseFactionFilters] using
  /// the optional [roleFilter], [characterFilters], and [unitFilters] if
  /// available.
  ///
  /// If no UnitCore's are available to match the specified [baseFactionFilters] and [roleFilter]
  /// the returned list will be empty.  If [roleFilter] is null or not specified all
  /// UnitCore's of the specified [baseFactionFilters] will be returned.
  List<UnitCore> getUnits({
    required List<FactionType> baseFactionFilters,
    List<RoleType?>? roleFilter,
    List<String>? characterFilters,
  }) {
    assert(baseFactionFilters.length > 0);

    final List<Frame> availableFrames = [];

    baseFactionFilters.forEach((factionType) {
      final frames = _factionFrames[factionType];
      if (frames != null) {
        availableFrames.addAll(frames);
      }
    });

    List<UnitCore> results = [];

    // adding each variant of the already selected frames to the results to be
    // returned.
    availableFrames.forEach((frame) {
      results.addAll(frame.variants);
    });

    if (roleFilter != null && roleFilter.isNotEmpty) {
      results = results.where((uc) {
        if (uc.role != null) {
          return uc.role!.includesRole(roleFilter);
        }
        return false;
      }).toList();
    }

    if (characterFilters != null) {
      results = results.where((uc) => uc.contains(characterFilters)).toList();
    }

    return results;
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
