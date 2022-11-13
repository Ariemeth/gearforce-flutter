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
import 'package:gearforce/models/rules/peace_river/poc.dart';
import 'package:gearforce/models/rules/peace_river/pps.dart';
import 'package:gearforce/models/rules/peace_river/prdf.dart';
import 'package:gearforce/models/rules/south/south.dart';
import 'package:gearforce/models/rules/utopia/utopia.dart';

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
          SubFaction('Black Talon Recon Team', ruleSet: BlackTalons(data)),
          SubFaction('Black Talon Insertion Team', ruleSet: BlackTalons(data)),
          SubFaction('Black Talon Strike Team', ruleSet: BlackTalons(data)),
          SubFaction('Black Talon Assault Team', ruleSet: BlackTalons(data)),
        ],
        defaultSub);
  }
  factory Faction.caprice(Data data) {
    final defaultSub = SubFaction('', ruleSet: Caprice(data));
    return Faction(
      FactionType.Caprice,
      [
        defaultSub,
        SubFaction('Caprice Invasion Detachment', ruleSet: Caprice(data)),
        SubFaction('Corporate Security Element', ruleSet: Caprice(data)),
        SubFaction('Liberati Resistance Cell', ruleSet: Caprice(data)),
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
        SubFaction('CEF Frame Formation', ruleSet: CEF(data)),
        SubFaction('CEF Tank Formation', ruleSet: CEF(data)),
        SubFaction('CEF Infantry Formation', ruleSet: CEF(data)),
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
        SubFaction('Edenite Invasion Force', ruleSet: Eden(data)),
        SubFaction('Edenite Noble Houses', ruleSet: Eden(data)),
        SubFaction('Ad-Hoc Edenite Force', ruleSet: Eden(data)),
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
        SubFaction('Norguard', ruleSet: North(data)),
        SubFaction('Western Frontier Protectorate', ruleSet: North(data)),
        SubFaction('United Mercantile Federation', ruleSet: North(data)),
        SubFaction('Northern Lights Confederacy', ruleSet: North(data)),
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
        SubFaction('NuCoal Self Defense Force', ruleSet: Nucoal(data)),
        SubFaction('Port Arthur Korps', ruleSet: Nucoal(data)),
        SubFaction('Humanist Alliance Protection Force', ruleSet: Nucoal(data)),
        SubFaction('Khayr ad-Dine', ruleSet: Nucoal(data)),
        SubFaction('Temple Heights', ruleSet: Nucoal(data)),
        SubFaction('Hardscrabble City-State Armies', ruleSet: Nucoal(data)),
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
        SubFaction(
          'Peace River Defense Force',
          description: PRDFDescription,
          ruleSet: PRDF(data),
        ),
        SubFaction('Peace Officer Corps', ruleSet: POC(data)),
        SubFaction('Paxton Private Securities', ruleSet: PPS(data)),
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
            ruleSet: South(data)),
        SubFaction('Mekong Dominion', ruleSet: South(data)),
        SubFaction('Eastern Sun Emirates', ruleSet: South(data)),
        SubFaction('Free Humanist Alliance', ruleSet: South(data)),
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
        SubFaction('Combined Armiger Force', ruleSet: Utopia(data)),
        SubFaction('Other Utopian Forces', ruleSet: Utopia(data)),
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

const PRDFDescription =
    'To be a soldier in the PRDF is to know a deep and abiding' +
        'hatred of Earth. CEF agents were responsible for the destruction of' +
        'Peace River City and countless lives. When this information came to ' +
        'light, a sleeping beast awoke. PRDF recruitment has never been ' +
        'better. With the full might of the manufacturing giant of Paxton ' +
        'Arms behind them, the PRDF is a powerful force to face on the ' +
        'battlefield.';
