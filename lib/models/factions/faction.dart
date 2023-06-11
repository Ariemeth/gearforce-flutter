import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_faction.dart';
import 'package:gearforce/models/rules/black_talons/black_talons.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart';
import 'package:gearforce/models/rules/cef/cef.dart';
import 'package:gearforce/models/rules/eden/eden.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/nucoal/nucoal.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/models/rules/south/south.dart';
import 'package:gearforce/models/rules/utopia/utopia.dart';

const String _emptySubFactionName = '';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<SubFaction> subFactions;
  final SubFaction defaultSubFaction;

  const Faction(this.factionType, this.subFactions, this.defaultSubFaction);

  factory Faction.blackTalons(Data data) {
    final defaultSub =
        SubFaction(ruleSet: BlackTalons(data, name: '$_emptySubFactionName'));
    return Faction(
        FactionType.BlackTalon,
        [
          defaultSub,
          SubFaction(
              ruleSet: BlackTalons(data, name: 'Black Talon Recon Team')),
          SubFaction(
              ruleSet: BlackTalons(data, name: 'Black Talon Insertion Team')),
          SubFaction(
              ruleSet: BlackTalons(data, name: 'Black Talon Strike Team')),
          SubFaction(
              ruleSet: BlackTalons(data, name: 'Black Talon Assault Team')),
        ],
        defaultSub);
  }
  factory Faction.caprice(Data data) {
    final defaultSub =
        SubFaction(ruleSet: Caprice(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.Caprice,
      [
        defaultSub,
        SubFaction(ruleSet: Caprice(data, name: 'Caprice Invasion Detachment')),
        SubFaction(ruleSet: Caprice(data, name: 'Corporate Security Element')),
        SubFaction(ruleSet: Caprice(data, name: 'Liberati Resistance Cell')),
      ],
      defaultSub,
    );
  }
  factory Faction.cef(Data data) {
    final defaultSub =
        SubFaction(ruleSet: CEF(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.CEF,
      [
        defaultSub,
        SubFaction(ruleSet: CEF(data, name: 'CEF Frame Formation')),
        SubFaction(ruleSet: CEF(data, name: 'CEF Tank Formation')),
        SubFaction(ruleSet: CEF(data, name: 'CEF Infantry Formation')),
      ],
      defaultSub,
    );
  }
  factory Faction.eden(Data data) {
    final defaultSub =
        SubFaction(ruleSet: Eden(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.Eden,
      [
        defaultSub,
        SubFaction(ruleSet: Eden(data, name: 'Edenite Invasion Force')),
        SubFaction(ruleSet: Eden(data, name: 'Edenite Noble Houses')),
        SubFaction(ruleSet: Eden(data, name: 'Ad-Hoc Edenite Force')),
      ],
      defaultSub,
    );
  }
  factory Faction.north(Data data) {
    final defaultSub =
        SubFaction(ruleSet: North(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.North,
      [
        defaultSub,
        SubFaction(ruleSet: North(data, name: 'Norguard')),
        SubFaction(ruleSet: North(data, name: 'Western Frontier Protectorate')),
        SubFaction(ruleSet: North(data, name: 'United Mercantile Federation')),
        SubFaction(ruleSet: North(data, name: 'Northern Lights Confederacy')),
      ],
      defaultSub,
    );
  }
  factory Faction.nucoal(Data data) {
    final defaultSub =
        SubFaction(ruleSet: Nucoal(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.NuCoal,
      [
        defaultSub,
        SubFaction(ruleSet: Nucoal(data, name: 'NuCoal Self Defense Force')),
        SubFaction(ruleSet: Nucoal(data, name: 'Port Arthur Korps')),
        SubFaction(
            ruleSet: Nucoal(data, name: 'Humanist Alliance Protection Force')),
        SubFaction(ruleSet: Nucoal(data, name: 'Khayr ad-Dine')),
        SubFaction(ruleSet: Nucoal(data, name: 'Temple Heights')),
        SubFaction(
            ruleSet: Nucoal(data, name: 'Hardscrabble City-State Armies')),
      ],
      defaultSub,
    );
  }
  factory Faction.peaceRiver(Data data) {
    final defaultSub =
        SubFaction(ruleSet: PeaceRiver(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.PeaceRiver,
      [
        defaultSub,
        SubFaction(ruleSet: PeaceRiver.PRDF(data)),
        SubFaction(ruleSet: PeaceRiver.POC(data)),
        SubFaction(ruleSet: PeaceRiver.PPS(data)),
      ],
      defaultSub,
    );
  }
  factory Faction.south(Data data) {
    final defaultSub =
        SubFaction(ruleSet: South(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.South,
      [
        defaultSub,
        SubFaction(
            ruleSet: South(data,
                name: 'Military Intervention and Counter Insurgency Army')),
        SubFaction(ruleSet: South(data, name: 'Mekong Dominion')),
        SubFaction(ruleSet: South(data, name: 'Eastern Sun Emirates')),
        SubFaction(ruleSet: South(data, name: 'Free Humanist Alliance')),
      ],
      defaultSub,
    );
  }
  factory Faction.utopia(Data data) {
    final defaultSub =
        SubFaction(ruleSet: Utopia(data, name: '$_emptySubFactionName'));
    return Faction(
      FactionType.Utopia,
      [
        defaultSub,
        SubFaction(ruleSet: Utopia(data, name: 'Combined Armiger Force')),
        SubFaction(ruleSet: Utopia(data, name: 'Other Utopian Forces')),
      ],
      defaultSub,
    );
  }

  factory Faction.fromType(FactionType faction, Data data) {
    switch (faction) {
      case FactionType.North:
        return Faction.north(data);
      case FactionType.South:
        return Faction.south(data);
      case FactionType.PeaceRiver:
        return Faction.peaceRiver(data);
      case FactionType.NuCoal:
        return Faction.nucoal(data);
      case FactionType.CEF:
        return Faction.cef(data);
      case FactionType.Caprice:
        return Faction.caprice(data);
      case FactionType.Utopia:
        return Faction.utopia(data);
      case FactionType.Eden:
        return Faction.eden(data);
      case FactionType.Universal:
        break;
      case FactionType.Universal_TerraNova:
        break;
      case FactionType.Universal_Non_TerraNova:
        break;
      case FactionType.Terrain:
        break;
      case FactionType.BlackTalon:
        return Faction.blackTalons(data);
      case FactionType.Airstrike:
        break;
    }
    throw FormatException('Cannot create a faction from ${faction.name}');
  }

  bool hasSubFaction(String name) {
    return this.subFactions.any((element) => element.name == name);
  }
}
