import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/factions/faction.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/unit/frame.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:gearforce/widgets/settings.dart';

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

class DataV3 {
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

  List<Unit> getUnitsByFilter({
    required List<UnitFilter> filters,
    List<RoleType>? roleFilter,
    List<String>? characterFilters,
  }) {
    if (filters.length == 0) {
      return [];
    }

    List<Unit> results = [];

    filters.forEach((filter) {
      final frames = _factionFrames[filter.faction];
      frames?.forEach((frame) {
        final units = frame.variants
            .where((uc) => filter.matcher(uc))
            .map((u) => Unit(core: u)..factionOverride = filter.factionOverride)
            .toList();
        results.addAll(units);
      });
    });

    // filter the selection based on role
    if (roleFilter != null && roleFilter.isNotEmpty) {
      results = results.where((uc) {
        if (uc.role != null) {
          return uc.role!.includesRole(roleFilter);
        }
        return false;
      }).toList();
    }

    if (characterFilters != null) {
      results =
          results.where((uc) => uc.core.contains(characterFilters)).toList();
    }

    return results;
  }

  /// This function loads all needed data resources.
  ///
  /// This function will not return/complete until all resources have been loaded.
  Future<void> load(Settings settings) async {
    this._factions = _loadFactions(settings);

    await Future.forEach<MapEntry<FactionType, String>>(
        _factionUnitFiles.entries.map((me) => me).toList(), (me) async {
      final String filename = me.value;
      final FactionType key = me.key;

      try {
        await _loadFrames(filename, faction: key)
            .then((frames) => _factionFrames[key] = frames);
      } catch (e) {
        print('Exception caught loading $key from $filename: $e');
      }
    });
  }

  List<Faction> _loadFactions(Settings settings) {
    return [
      Faction.blackTalons(this, settings),
      Faction.caprice(this, settings),
      Faction.cef(this, settings),
      Faction.eden(this, settings),
      Faction.leagueless(this, settings),
      Faction.north(this, settings),
      Faction.nucoal(this, settings),
      Faction.peaceRiver(this, settings),
      Faction.south(this, settings),
      Faction.utopia(this, settings),
    ];
  }

  Future<List<Frame>> _loadFrames(
    String filename, {
    required FactionType faction,
  }) async {
    var jsonData = await rootBundle.loadString(filename);
    var decodedData = json.decode(jsonData)['frames'] as List;
    return decodedData.map((f) => Frame.fromJson(f, faction: faction)).toList();
  }
}
