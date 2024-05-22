import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_group_options_dialog.dart';

const _splashRadius = 20.0;

class CombatGroupOptionsButton extends StatelessWidget {
  final CombatGroup cg;
  final RuleSet ruleSet;

  const CombatGroupOptionsButton({
    super.key,
    required this.cg,
    required this.ruleSet,
  });

  @override
  Widget build(BuildContext context) {
    final settingsIcon = ruleSet.combatGroupSettings().length > 0
        ? Icons.settings_suggest
        : Icons.settings;

    final widget = IconButton(
      constraints: BoxConstraints.tightForFinite(),
      onPressed: () => {_showOptionsDialog(context)},
      icon: Icon(
        settingsIcon,
        color: Colors.green,
      ),
      splashRadius: _splashRadius,
      padding: EdgeInsets.zero,
      tooltip: 'Options for ${cg.name}',
    );

    return widget;
  }

  void _showOptionsDialog(BuildContext context) {
    final settingsDialog = CombatGroupOptionsDialog(
      cg: cg,
      ruleSet: ruleSet,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return settingsDialog;
        });
  }
}
