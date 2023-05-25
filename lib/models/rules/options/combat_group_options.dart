import 'package:flutter/widgets.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/roster/roster.dart';

class CombatGroupOption extends ChangeNotifier {
  CombatGroupOption(
    this.factionRule, {
    required this.name,
    required this.id,
    this.requirementCheck = alwaysTrueCG,
    this.canBeToggled = true,
    bool initialState = false,
  }) {
    _isEnabled = initialState;
  }

  final String name;
  final String id;
  final FactionRule factionRule;
  final bool canBeToggled;

  late bool _isEnabled;
  bool get isEnabled => _isEnabled;
  set isEnabled(bool newState) {
    if (!canBeToggled) {
      return;
    }
    if (newState != _isEnabled) {
      _isEnabled = newState;
      notifyListeners();
    }
  }

  final bool Function(CombatGroup?, UnitRoster?) requirementCheck;
}

bool alwaysTrueCG(CombatGroup? cg, UnitRoster? r) => true;
bool Function(CombatGroup?, UnitRoster?) onlyOneCG(String id) {
  return (combatGroup, roster) {
    assert(roster != null);
    assert(combatGroup != null);

    if (roster == null || combatGroup == null) {
      return false;
    }

    final cgsWithOptionCount =
        roster.getCGs().where((cg) => cg.isOptionEnabled(id)).length;

    // Either there is currently no cg with this option or the selected
    // cg already has the option
    return cgsWithOptionCount == 0
        ? true
        : cgsWithOptionCount == 1 && combatGroup.isOptionEnabled(id);
  };
}
