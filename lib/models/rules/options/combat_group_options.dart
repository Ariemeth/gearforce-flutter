import 'package:flutter/widgets.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';

class Option extends ChangeNotifier {
  Option({
    required this.name,
    required this.id,
    this.requirementCheck = alwaysTrue,
  });

  final String name;
  final String id;
  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;
  set isEnabled(bool newState) {
    if (newState != _isEnabled) {
      _isEnabled = newState;
      notifyListeners();
    }
  }

  final bool Function(CombatGroup?, UnitRoster?) requirementCheck;
}

bool alwaysTrue(CombatGroup? cg, UnitRoster? r) => true;
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
