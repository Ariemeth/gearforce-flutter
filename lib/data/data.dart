import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/frame.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const Map<FactionType, String> _factionUnitFiles = {
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
  FactionType.Utopia: 'assets/data/units/utopia.json',
};

class Data {
  late List<Faction> _factions = [];

  final Map<FactionType, List<Frame>> _factionFrames = {};

  /// Retrieves a list of factions.
  List<Faction> factions() {
    return _factions;
  }

  /// Returns a list of Modifications for a specific [faction]'s [frame]
  ///
  /// If no frames are found for a [faction] or there are no modifications
  /// found, the returned list will be empty.
  List<Modification> availableUnitMods(FactionType faction, String frame) {
    var l = _factionFrames[faction];
    return l == null
        ? []
        : l.where((element) => element.name == frame).first.availableUpgrades;
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
    List<String>? filters,
  }) {
    List<Frame>? factionUnit = _factionFrames[faction]!.toList();

    switch (faction) {
      case FactionType.North:
      case FactionType.South:
      case FactionType.NuCoal:
      case FactionType.PeaceRiver:
      case FactionType.BlackTalon:
        var uniList = _factionFrames[FactionType.Universal];
        if (uniList != null) {
          factionUnit.addAll(uniList.toList());
        }
        break;
      case FactionType.CEF:
        break;
      case FactionType.Caprice:
        break;
      case FactionType.Utopia:
        break;
      case FactionType.Eden:
        break;
      case FactionType.Universal:
        break;
      case FactionType.Terrain:
        break;
    }

    var terrainList = _factionFrames[FactionType.Terrain];
    if (terrainList != null) {
      factionUnit.addAll(terrainList.toList());
    }
    List<UnitCore> ulist = [];

    factionUnit.forEach((f) {
      ulist.addAll(f.variants);
    });

    var results = (role == null || role.isEmpty)
        ? ulist
        : ulist.where((element) {
            if (element.role != null) {
              return element.role!.includesRole(role);
            }
            return false;
          }).toList();

    return filters == null
        ? results
        : results.where((element) => element.contains(filters)).toList();
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
    List<Faction> factions = [];

    factions.add(Faction(factionType: FactionType.BlackTalon, subFactions: [
      'None',
    ]));
    factions.add(Faction(factionType: FactionType.CEF, subFactions: [
      'None',
      'CEF Line Formation',
      'GREL/FLAIL Infantry Battalion',
      'Tank Battalion',
    ]));
    factions.add(Faction(factionType: FactionType.Caprice, subFactions: [
      'None',
      'Caprice Corporate Security Detachment',
      'Caprice Invasion Detachment',
      'Caprice Liberati Resistance Cell',
    ]));
    factions.add(Faction(factionType: FactionType.Eden, subFactions: [
      'None',
      'Eden Invasion Militia',
      'Eden Noble House',
    ]));
    factions.add(Faction(factionType: FactionType.North, subFactions: [
      'None',
      'Northern Guard',
      'Northern Lights Confederacy',
      'United Mercantile Federation',
      'Western Frontier Protectorate',
    ]));
    factions.add(Faction(factionType: FactionType.NuCoal, subFactions: [
      'None',
      'Humanist Alliance Protection Force',
      'Hard Scrabbled City State Armies',
      'Khayr Ad-Din',
      'NuCoal Self Defense Force',
      'Port Arthur Korps',
      'Temple Heights',
    ]));
    factions.add(Faction(factionType: FactionType.PeaceRiver, subFactions: [
      'None',
      'Combined Task Force',
      'Home Guard Security Forces',
      'Peace River Defense Force',
      'Peace Officer Corps',
    ]));
    factions.add(Faction(factionType: FactionType.South, subFactions: [
      'None',
      'Eastern Sun Emirates',
      'MILitary Intervention and Counter Insurgency Army',
      'Mekong Dominion',
      'Southern Republic Army',
    ]));
    factions.add(Faction(factionType: FactionType.Utopia, subFactions: [
      'None',
      'Other Utopian Forces',
      'Utopian Combined Armiger Force',
    ]));
    return factions;
  }

  Future<List<Frame>> _loadFrames(String filename) async {
    var jsonData = await rootBundle.loadString(filename);
    var decodedData = json.decode(jsonData)['frames'] as List;
    return decodedData.map((f) => Frame.fromJson(f)).toList();
  }
}
