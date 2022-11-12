import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';

class CombatGroupOption {
  const CombatGroupOption({
    required this.name,
    required this.options,
  });

  final String name;
  final List<Option> options;
}

class Option {
  const Option({
    required this.name,
    this.requirementCheck = alwaysTrue,
  });

  final String name;
  final bool Function(CombatGroup?, UnitRoster?) requirementCheck;
}

bool alwaysTrue(CombatGroup? cg, UnitRoster? r) => true;
bool Function(CombatGroup?, UnitRoster?) onlyOneCG(String name) {
  return (combatGroup, roster) {
    if (roster == null) {
      return false;
    }
    return roster.getCGs().where((cg) => cg.tags.contains(name)).length == 0;
  };
}
