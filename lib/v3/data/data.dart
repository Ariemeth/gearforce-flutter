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
  FactionType.airstrike: 'assets/data/units/air_strike.json',
  FactionType.blackTalon: 'assets/data/units/black_talon.json',
  FactionType.cef: 'assets/data/units/cef.json',
  FactionType.caprice: 'assets/data/units/caprice.json',
  FactionType.eden: 'assets/data/units/eden.json',
  FactionType.north: 'assets/data/units/north.json',
  FactionType.nuCoal: 'assets/data/units/nucoal.json',
  FactionType.peaceRiver: 'assets/data/units/peace_river.json',
  FactionType.south: 'assets/data/units/south.json',
  FactionType.terrain: 'assets/data/units/terrain.json',
  FactionType.universal: 'assets/data/units/universal.json',
  FactionType.universalTerraNova: 'assets/data/units/universal_terranova.json',
  FactionType.universalNonTerraNova:
      'assets/data/units/universal_non_terranova.json',
  FactionType.utopia: 'assets/data/units/utopia.json',
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
    assert(baseFactionFilters.isNotEmpty);

    final List<Frame> availableFrames = [];

    for (var factionType in baseFactionFilters) {
      final frames = _factionFrames[factionType];
      if (frames != null) {
        availableFrames.addAll(frames);
      }
    }

    List<UnitCore> results = [];

    // adding each variant of the already selected frames to the results to be
    // returned.
    for (var frame in availableFrames) {
      results.addAll(frame.variants);
    }

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
    if (filters.isEmpty) {
      return [];
    }

    List<Unit> results = [];

    for (var filter in filters) {
      final frames = _factionFrames[filter.faction];
      frames?.forEach((frame) {
        final units = frame.variants
            .where((uc) => filter.matcher(uc))
            .map((u) => Unit(core: u)..factionOverride = filter.factionOverride)
            .toList();
        results.addAll(units);
      });
    }

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
    _factions = _loadFactions(settings);

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
