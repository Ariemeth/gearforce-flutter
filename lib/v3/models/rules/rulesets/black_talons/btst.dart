import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/duelist/duelist_modification.dart'
    as duelist;
import 'package:gearforce/v3/models/rules/rulesets/black_talons/black_talons.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';

const String _baseRuleId = 'rule::blackTalon::btst';
const String _ruleAlliesId = '$_baseRuleId::10';
const String _ruleBestAndBrightestId = '$_baseRuleId::20';
const String _ruleShowoffsId = '$_baseRuleId::30';

/*
  BTST - Black Talon Strike Team
  As BTSTs specialize in asymmetric warfare on the conventional Terra Novan battlefield,
  they are frequently found operating with collocated forces. BTST operatives are trained
  in the many intricacies of all the Terra Novan militaries. They know their capabilities,
  policies and doctrines like the back of their hand. This enables them to speak to any
  Terra Novan force in their native lingo and procedures. Even Badland forces have been
  known to take part in BTST operations.
  * Allies: You may select models from North, South, Peace River and NuCoal (may
  include a mix). Commanders must choose a Black Talon model.
  * Best and Brightest: Any number of allies may purchase the Vet trait without
  counting against the veteran limitations.
  * Showoffs: One gear in each combat group may
*/
class BTST extends BlackTalons {
  BTST(super.data, super.settings)
      : super(
          name: 'Black Talon Strike Team',
          subFactionRules: [ruleAllies, ruleBestAndBrightest, ruleShowoffs],
        );
}

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies',
      filters: [
        UnitFilter(FactionType.north),
        UnitFilter(FactionType.south),
        UnitFilter(FactionType.peaceRiver),
        UnitFilter(FactionType.nuCoal),
      ],
      id: _ruleAlliesId),
  availableCommandLevelOverride: (u) {
    if (u.faction == FactionType.north ||
        u.faction == FactionType.south ||
        u.faction == FactionType.peaceRiver ||
        u.faction == FactionType.nuCoal) {
      return [CommandLevel.none];
    }
    return null;
  },
  description: 'You may select models from North, South, Peace River and' +
      ' NuCoal (may include a mix). Commanders must choose a Black Talon model.',
);

final Rule ruleBestAndBrightest = Rule(
  name: 'Best and Brightest',
  id: _ruleBestAndBrightestId,
  veteranCheckOverride: (u, cg) {
    if (u.traits.any((t) => Trait.conscript().isSameType(t))) {
      return null;
    }
    if (u.faction == FactionType.north ||
        u.faction == FactionType.south ||
        u.faction == FactionType.peaceRiver ||
        u.faction == FactionType.nuCoal) {
      return true;
    }
    return null;
  },
  description: 'Any number of allies may purchase the Vet trait without' +
      ' counting against the veteran limitations.',
);

final Rule ruleShowoffs = Rule(
  name: 'Showoffs',
  id: _ruleShowoffsId,
  duelistModCheck: (u, cg, {required modID}) {
    if (modID == duelist.independentOperatorId) {
      return false;
    }
    return null;
  },
  duelistMaxNumberOverride: (roster, cg, u) {
    if (u.type != ModelType.gear) {
      return null;
    }
    final numOtherDuelist = cg.duelists.where((unit) => unit != u).length;

    if (numOtherDuelist == 0) {
      return roster.duelistCount + 1;
    }

    return null;
  },
  description: 'One gear in each combat group may be a duelist. This force' +
      ' cannot use the Independent Operator rule for duelists.',
);
