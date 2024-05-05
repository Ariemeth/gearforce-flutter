import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart'
    as duelistMod;
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/south/milicia.dart' as milicia;
import 'package:gearforce/models/rules/south/south.dart';
import 'package:gearforce/models/validation/validations.dart';

const String _baseRuleId = 'rule::south::fha';
const String _ruleWroteTheBookId = '$_baseRuleId::10';
const String _ruleExpertsId = '$_baseRuleId::20';
const String _ruleAlliesId = '$_baseRuleId::30';

/*
  FHA - Free Humanist Alliance
  While eight percent of the original Humanists were able to escape to NuCoal after a
  failed revolt against the Republic, the Humanists that could not get out were brutally
  taken over and occupied, loosing all autonomy to self-govern. In the aftermath of
  the Southern Republic civil war, the Humanists were given back their autonomy
  as a gesture of good will. This new Humanist Alliance is called the Free Humanist
  Alliance. The ties between the Free Humanist Alliance within the South and the
  Humanist Alliance in NuCoal are generally friendly.
  * Wrote the Book: Two models per combat group may purchase the Vet trait
  without counting against the veteran limitations.
  * Experts: Veteran Sagittariuses, veteran Fire Dragons and veteran Hetairoi may
  purchase the Stable and/or Precise duelist upgrades, without having to be
  duelists.
  * Conscription: You may add the Conscript trait to any non-commander,
  non-veteran and non-duelist in the force if they do not already possess the trait.
  Reduce the TV of these models by 1 TV per action.
  * Allies: You may select models from NuCoal for secondary units. GREL models
  may not be selected.
*/
class FHA extends South {
  FHA(super.data)
      : super(
          name: 'Free Humanist Alliance',
          subFactionRules: [
            ruleWroteTheBook,
            ruleExperts,
            milicia.ruleConscription,
            ruleAllies,
          ],
        );
}

final Rule ruleWroteTheBook = Rule(
  name: 'Wrote the Book',
  id: _ruleWroteTheBookId,
  veteranCheckOverride: (u, cg) {
    if (cg.isVeteran) {
      return null;
    }

    if (cg.roster?.rulesetNotifer.value == null) {
      return null;
    }
    final vetsNeedingRule = cg.veterans.where((unit) =>
        !cg.roster!.rulesetNotifer.value
            .vetCheck(cg, u, ruleExclusions: [_ruleWroteTheBookId]) &&
        unit != u);

    if (vetsNeedingRule.length < 2) {
      return true;
    }
    return null;
  },
  description: 'Two models per combat group may purchase the Vet trait' +
      ' without counting against the veteran limitations.',
);

final Rule ruleExperts = Rule(
  name: 'Experts',
  id: _ruleExpertsId,
  duelistModCheck: (u, cg, {required modID}) {
    if (!(modID == duelistMod.stableId || modID == duelistMod.preciseId)) {
      return null;
    }

    final frame = u.core.frame;
    if (!(frame == 'Sagittarius' ||
        frame == 'Fire Dragon' ||
        frame == 'Hetairoi')) {
      return null;
    }

    if (!u.isVeteran) {
      return null;
    }

    return true;
  },
  description: 'Veteran Sagittariuses, veteran Fire Dragons and veteran' +
      ' Hetairoi may purchase the Stable and/or Precise duelist upgrades,' +
      ' without having to be duelists.',
);

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.NuCoal) {
      return null;
    }
    if (group.groupType != GroupType.Primary) {
      return null;
    }
    return Validation(
      false,
      issue: 'NuCoal units can only be added to secondary groups; See Allies' +
          ' rule.',
    );
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies',
      filters: [
        UnitFilter(
          FactionType.NuCoal,
          matcher: matchNoGREL,
        ),
        ...SouthFilters,
      ],
      id: _ruleAlliesId),
  description: 'You may select models from NuCoal for secondary units. GREL' +
      ' models may not be selected.',
);
