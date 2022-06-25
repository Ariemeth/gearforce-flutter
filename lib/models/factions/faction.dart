import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_factions.dart/sub_faction.dart';
import 'package:gearforce/models/rules/factions/black_talons.dart';
import 'package:gearforce/models/rules/factions/caprice.dart';
import 'package:gearforce/models/rules/factions/cef.dart';
import 'package:gearforce/models/rules/factions/eden.dart';
import 'package:gearforce/models/rules/factions/north.dart';
import 'package:gearforce/models/rules/factions/nucoal.dart';
import 'package:gearforce/models/rules/factions/peace_river.dart';
import 'package:gearforce/models/rules/factions/south.dart';
import 'package:gearforce/models/rules/factions/utopia.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<SubFaction> subFactions;
  final SubFaction defaultSubFaction;

  const Faction(this.factionType, this.subFactions, this.defaultSubFaction);

  factory Faction.blackTalons(Data data) {
    final defaultSub = SubFaction('', ruleSet: BlackTalons(data));
    return Faction(
        FactionType.BlackTalon,
        [
          defaultSub,
          SubFaction('Black Talon Recon Team', ruleSet: null),
          SubFaction('Black Talon Insertion Team', ruleSet: null),
          SubFaction('Black Talon Strike Team', ruleSet: null),
          SubFaction('Black Talon Assault Team', ruleSet: null),
        ],
        defaultSub);
  }
  factory Faction.caprice(Data data) {
    final defaultSub = SubFaction('', ruleSet: Caprice(data));
    return Faction(
      FactionType.Caprice,
      [
        defaultSub,
        SubFaction('Caprice Invasion Detachment', ruleSet: null),
        SubFaction('Corporate Security Element', ruleSet: null),
        SubFaction('Liberati Resistance Cell', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.cef(Data data) {
    final defaultSub = SubFaction('', ruleSet: CEF(data));
    return Faction(
      FactionType.CEF,
      [
        defaultSub,
        SubFaction('CEF Frame Formation', ruleSet: null),
        SubFaction('CEF Tank Formation', ruleSet: null),
        SubFaction('CEF Infantry Formation', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.eden(Data data) {
    final defaultSub = SubFaction('', ruleSet: Eden(data));
    return Faction(
      FactionType.Eden,
      [
        defaultSub,
        SubFaction('Edenite Invasion Force', ruleSet: null),
        SubFaction('Edenite Noble Houses', ruleSet: null),
        SubFaction('Ad-Hoc Edenite Force', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.north(Data data) {
    final defaultSub = SubFaction('', ruleSet: North(data));
    return Faction(
      FactionType.North,
      [
        defaultSub,
        SubFaction('Norguard', ruleSet: null),
        SubFaction('Western Frontier Protectorate', ruleSet: null),
        SubFaction('United Mercantile Federation', ruleSet: null),
        SubFaction('Northern Lights Confederacy', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.nucoal(Data data) {
    final defaultSub = SubFaction('', ruleSet: Nucoal(data));
    return Faction(
      FactionType.NuCoal,
      [
        defaultSub,
        SubFaction('NuCoal Self Defense Force', ruleSet: null),
        SubFaction('Port Arthur Korps', ruleSet: null),
        SubFaction('Humanist Alliance Protection Force', ruleSet: null),
        SubFaction('Khayr ad-Dine', ruleSet: null),
        SubFaction('Temple Heights', ruleSet: null),
        SubFaction('Hardscrabble City-State Armies', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.peaceRiver(Data data) {
    final defaultSub = SubFaction('', ruleSet: PeaceRiver(data));
    return Faction(
      FactionType.PeaceRiver,
      [
        defaultSub,
        SubFaction('Peace River Defense Force', ruleSet: null),
        SubFaction('Peace Officer Corps', ruleSet: null),
        SubFaction('Paxton Private Securities', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.south(Data data) {
    final defaultSub = SubFaction('', ruleSet: South(data));
    return Faction(
      FactionType.South,
      [
        defaultSub,
        SubFaction('Military Intervention and Counter Insurgency Army',
            ruleSet: null),
        SubFaction('Mekong Dominion', ruleSet: null),
        SubFaction('Eastern Sun Emirates', ruleSet: null),
        SubFaction('Free Humanist Alliance', ruleSet: null),
      ],
      defaultSub,
    );
  }
  factory Faction.utopia(Data data) {
    final defaultSub = SubFaction('', ruleSet: Utopia(data));
    return Faction(
      FactionType.Utopia,
      [
        defaultSub,
        SubFaction('Combined Armiger Force', ruleSet: null),
        SubFaction('Other Utopian Forces', ruleSet: null),
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
