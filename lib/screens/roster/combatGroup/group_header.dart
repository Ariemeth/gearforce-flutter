import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_group_options_button.dart';
import 'package:gearforce/screens/roster/combatGroup/group_actions_display.dart';
import 'package:gearforce/screens/roster/combatGroup/veteran_group_checkbox_display.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/widgets/display_value.dart';

const _groupTypeNameWidth = 100.0;
const _selectRoleWidth = 75.0;
const _spaceBetweenItems = 15.0;

class GroupHeader extends StatelessWidget {
  const GroupHeader({
    Key? key,
    required this.cg,
    required this.group,
    required this.roster,
  }) : super(key: key);

  final CombatGroup cg;
  final Group group;
  final UnitRoster roster;

  @override
  Widget build(BuildContext context) {
    final isPrimary = group.groupType == GroupType.Primary;

    final heading = Row(
      children: [
        SizedBox(
          width: _groupTypeNameWidth,
          child: Text(
            group.groupType.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SelectRole(
          group: group,
          roster: roster,
          width: _selectRoleWidth,
        ),
        DisplayValue(
          text: 'TV',
          value: group.totalTV(),
          padding: const EdgeInsets.only(left: _spaceBetweenItems),
        ),
        GroupActionsDisplay(
          group: group,
          padding: const EdgeInsets.only(left: _spaceBetweenItems),
          ruleSet: roster.rulesetNotifer.value,
        )
      ],
    );

    if (isPrimary) {
      final vetCheckBox = VeteranGroupCheckboxDisplay(
        cg: cg,
        padding: const EdgeInsets.only(left: _spaceBetweenItems),
      );

      final cgOptions = Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: CombatGroupOptionsButton(
            cg: cg,
            ruleSet: roster.rulesetNotifer.value,
          ),
        ),
      );

      heading.children.add(vetCheckBox);
      heading.children.add(cgOptions);
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: heading,
    );
  }
}
