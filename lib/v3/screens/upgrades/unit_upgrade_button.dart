import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/combat_group.dart';
import 'package:gearforce/v3/screens/upgrades/upgrades_dialog.dart';
import 'package:provider/provider.dart';

class UnitUpgradeButton extends StatelessWidget {
  const UnitUpgradeButton(
    this.unit,
    this.group,
    this.cg,
    this.roster, {
    super.key,
  });

  final Unit unit;
  final Group group;
  final CombatGroup cg;
  final UnitRoster roster;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showUnitUpgradeDialog(context, unit, group, cg, roster);
        },
        icon: const Icon(
          Icons.add_task,
          color: Colors.green,
        ),
        splashRadius: 20.0,
        tooltip: 'Add upgrades to this unit',
      ),
    );
  }
}

void showUnitUpgradeDialog(
  BuildContext context,
  Unit unit,
  Group group,
  CombatGroup cg,
  UnitRoster roster,
) {
  var result = showDialog<OptionResult>(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: unit,
          child: UpgradesDialog(
            roster: roster,
            cg: cg,
            unit: unit,
          ),
        );
      });

  result.whenComplete(() {
    if (!kReleaseMode) {
      print(
          'unit weapons after returning from upgrade screen for ${unit.name}');
      print('react weapons: ${unit.reactWeapons.toString()}');
      print('mount weapons: ${unit.mountedWeapons.toString()}');
      print('       traits: ${unit.traits.toString()}');
      print('         mods: ${unit.modNames.toString()}');
      print('      actions: ${unit.actions}');
      print('           tv: ${unit.tv}');
      print('         hash: ${unit.hashCode}');
    }
  });
}
