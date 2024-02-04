import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/widgets/display_value.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

class GroupActionsDisplay extends StatelessWidget {
  final Group group;
  final EdgeInsets padding;
  final RuleSet ruleSet;

  const GroupActionsDisplay({
    super.key,
    required this.group,
    required this.padding,
    required this.ruleSet,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();

    final isPrimary = group.groupType == GroupType.Primary;

    final actions = group.totalActions();
    final maxPrimaryActions = ruleSet.maxPrimaryActions;
    final minPrimaryActions = ruleSet.minPrimaryActions;
    final maxSecondaryAction =
        ruleSet.maxSecondaryActions(group.combatGroup!.primary.totalActions());

    final widget = Tooltip(
      waitDuration: settings.tooltipDelay,
      message: isPrimary
          // a cg is only valid if the number of actions is greater then 4 and
          // less then or equal to 6
          ? actions > maxPrimaryActions || actions < minPrimaryActions
              ? 'must have between $minPrimaryActions and $maxPrimaryActions actions'
              : 'valid number of actions'
          : actions > maxSecondaryAction
              ? 'cannot have more then $maxSecondaryAction actions'
              : 'valid number of actions',
      child: DisplayValue(
        text: 'Actions',
        value: actions,
        textColor: group.combatGroup?.modCount(independentOperatorId) != 0
            ? Colors.green
            : isPrimary
                // a cg is only valid if the number of actions is greater then 4 and
                // less then or equal to 6
                ? actions > maxPrimaryActions || actions < minPrimaryActions
                    ? Colors.red
                    : Colors.green
                : actions > maxSecondaryAction
                    ? Colors.red
                    : Colors.green,
        padding: padding,
      ),
    );

    return widget;
  }
}
