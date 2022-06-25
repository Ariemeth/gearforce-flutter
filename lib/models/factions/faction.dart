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
import 'package:gearforce/models/rules/rule_set.dart';

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
          SubFaction('Black Talon Recon Team', ruleSet: DefaultRuleSet(data)),
          SubFaction('Black Talon Insertion Team',
              ruleSet: DefaultRuleSet(data)),
          SubFaction('Black Talon Strike Team', ruleSet: DefaultRuleSet(data)),
          SubFaction('Black Talon Assault Team', ruleSet: DefaultRuleSet(data)),
        ],
        defaultSub);
  }
  factory Faction.caprice(Data data) {
    final defaultSub = SubFaction('', ruleSet: Caprice(data));
    return Faction(
      FactionType.Caprice,
      [
        defaultSub,
        SubFaction('Caprice Invasion Detachment',
            ruleSet: DefaultRuleSet(data)),
        SubFaction('Corporate Security Element', ruleSet: DefaultRuleSet(data)),
        SubFaction('Liberati Resistance Cell', ruleSet: DefaultRuleSet(data)),
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
        SubFaction('CEF Frame Formation', ruleSet: DefaultRuleSet(data)),
        SubFaction('CEF Tank Formation', ruleSet: DefaultRuleSet(data)),
        SubFaction('CEF Infantry Formation', ruleSet: DefaultRuleSet(data)),
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
        SubFaction('Edenite Invasion Force', ruleSet: DefaultRuleSet(data)),
        SubFaction('Edenite Noble Houses', ruleSet: DefaultRuleSet(data)),
        SubFaction('Ad-Hoc Edenite Force', ruleSet: DefaultRuleSet(data)),
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
        SubFaction('Norguard', ruleSet: DefaultRuleSet(data)),
        SubFaction('Western Frontier Protectorate',
            ruleSet: DefaultRuleSet(data)),
        SubFaction('United Mercantile Federation',
            ruleSet: DefaultRuleSet(data)),
        SubFaction('Northern Lights Confederacy',
            ruleSet: DefaultRuleSet(data)),
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
        SubFaction('NuCoal Self Defense Force', ruleSet: DefaultRuleSet(data)),
        SubFaction('Port Arthur Korps', ruleSet: DefaultRuleSet(data)),
        SubFaction('Humanist Alliance Protection Force',
            ruleSet: DefaultRuleSet(data)),
        SubFaction('Khayr ad-Dine', ruleSet: DefaultRuleSet(data)),
        SubFaction('Temple Heights', ruleSet: DefaultRuleSet(data)),
        SubFaction('Hardscrabble City-State Armies',
            ruleSet: DefaultRuleSet(data)),
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
        SubFaction('Peace River Defense Force', ruleSet: DefaultRuleSet(data)),
        SubFaction('Peace Officer Corps', ruleSet: DefaultRuleSet(data)),
        SubFaction('Paxton Private Securities', ruleSet: DefaultRuleSet(data)),
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
            ruleSet: DefaultRuleSet(data)),
        SubFaction('Mekong Dominion', ruleSet: DefaultRuleSet(data)),
        SubFaction('Eastern Sun Emirates', ruleSet: DefaultRuleSet(data)),
        SubFaction('Free Humanist Alliance', ruleSet: DefaultRuleSet(data)),
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
        SubFaction('Combined Armiger Force', ruleSet: DefaultRuleSet(data)),
        SubFaction('Other Utopian Forces', ruleSet: DefaultRuleSet(data)),
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
