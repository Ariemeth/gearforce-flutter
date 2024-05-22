import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart'
    as duelist;
import 'package:gearforce/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/models/rules/rulesets/nucoal/nucoal.dart';
import 'package:gearforce/models/rules/rulesets/nucoal/pak.dart' as pak;
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::nucoal::th';

const String _ruleJannitePilotsId = '$_baseRuleId::10';
const String _ruleJanniteWardensId = '$_baseRuleId::20';
const String _ruleLocalMilitiaId = '$_baseRuleId::30';

/*
  TH - Temple Heights
  The city of Temple Heights is an enigma. It has gone from an obscure city in the Badlands to a
  thriving refugee center and tourist destination. From liberated GRELs to the mysterious Sandriders,
  all types now call the crescent mesa city home. Reports about the Sandriders themselves are very
  minimal. Every recon mission sent to observe Sandrider camps have mysteriously disappeared. The
  popular rumor is that the desert itself swallowed them whole.
  * Jannite Pilots: Veteran gears in this force with one action may upgrade to having two actions
  for +2 TV each.
  * Jannite Wardens: You may select 2 gears in this force to become duelists. All duelists must take
  the Jannite Pilot upgrade if able.
  * Local Militia: Combat groups made entirely of infantry and/or cavalry may use the GP, SK,
  FS, RC or SO roles. A combat group of all infantry and/or cavalry may deploy using the special
  operations deployment rule.
  * Something to Prove: GREL infantry may increase their GU skill by one for 1 TV each.
*/
class TH extends NuCoal {
  TH(super.data, super.settings)
      : super(
          name: 'Temple Heights',
          subFactionRules: [
            ruleJannitePilots,
            ruleJanniteWardens,
            ruleLocalMilitia,
            pak.ruleSomethingToProve,
          ],
        );
}

final Rule ruleJannitePilots = Rule(
  name: 'Jannite Pilots',
  id: _ruleJannitePilotsId,
  factionMods: (ur, cg, u) => [NuCoalFactionMods.jannitePilots()],
  description: 'Veteran gears in this force with one action may upgrade to' +
      ' having two actions for +2 TV each.',
);

final Rule ruleJanniteWardens = Rule(
  name: 'Jannite Wardens',
  id: _ruleJanniteWardensId,
  duelistMaxNumberOverride: (roster, cg, u) => 2,
  onModAdded: (unit, modId) {
    if (modId != duelist.duelistId) {
      return;
    }

    final rules = unit.group?.combatGroup?.roster?.rulesetNotifer.value;

    if (rules == null) {
      return;
    }

    final jannitePilotsMod = NuCoalFactionMods.jannitePilots();
    final canAddMod = jannitePilotsMod.requirementCheck(
        rules, unit.group?.combatGroup?.roster, unit.group?.combatGroup, unit);
    if (canAddMod) {
      unit.addUnitMod(jannitePilotsMod);
    }
  },
  onModRemoved: (unit, modId) {
    if (modId != jannitePilotsId) {
      return;
    }

    if (unit.isDuelist) {
      unit.addUnitMod(NuCoalFactionMods.jannitePilots());
    }
  },
  description: 'You may select 2 gears in this force to become duelists. All' +
      ' duelists must take the Jannite Pilot upgrade if able.',
);

final Rule ruleLocalMilitia = Rule(
  name: 'Local Militia',
  id: _ruleLocalMilitiaId,
  hasGroupRole: (unit, target, group) {
    if (!(unit.type == ModelType.Infantry || unit.type == ModelType.Cavalry)) {
      return null;
    }
    final areOtherTypesInUnit = group.combatGroup?.units.any(
        (u) => !(u.type == ModelType.Infantry || u.type == ModelType.Cavalry));

    if (areOtherTypesInUnit != null && !areOtherTypesInUnit) {
      return target == RoleType.GP ||
          target == RoleType.SK ||
          target == RoleType.FS ||
          target == RoleType.RC ||
          target == RoleType.SO;
    }
    return null;
  },
  description: 'Combat groups made entirely of infantry and/or cavalry may' +
      ' use the GP, SK, FS, RC or SO roles. A combat group of all infantry' +
      ' and/or cavalry may deploy using the special operations deployment' +
      ' rule.',
);
