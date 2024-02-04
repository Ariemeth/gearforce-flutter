import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_group_settings_dialog.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/widgets/display_value.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

const _groupHeaderHeight = 35.0;

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
    final settings = context.read<Settings>();
    final actions = group.totalActions();
    final maxPrimaryActions = roster.rulesetNotifer.value.maxPrimaryActions;
    final minPrimaryActions = roster.rulesetNotifer.value.minPrimaryActions;
    final maxSecondaryAction = roster.rulesetNotifer.value
        .maxSecondaryActions(cg.primary.totalActions());
    final settingsIcon =
        roster.rulesetNotifer.value.combatGroupSettings().length > 0
            ? Icons.settings_suggest
            : Icons.settings;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              group.groupType.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Role: ",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            child: SelectRole(
              group: group,
              roster: roster,
            ),
            width: 75,
          ),
          SizedBox(
            width: 20,
          ),
          DisplayValue(text: 'TV:', value: group.totalTV()),
          Tooltip(
            waitDuration: settings.tooltipDelay,
            message: group.groupType == GroupType.Primary
                // a cg is only valid if the number of actions is greater then 4 and
                // less then or equal to 6
                ? actions > maxPrimaryActions || actions < minPrimaryActions
                    ? 'must have between $minPrimaryActions and $maxPrimaryActions actionss'
                    : 'valid number of actions'
                : actions > maxSecondaryAction
                    ? 'cannot have more then $maxSecondaryAction actions'
                    : 'valid number of actions',
            child: DisplayValue(
              text: 'Actions',
              value: actions,
              textColor: cg.modCount(independentOperatorId) != 0
                  ? Colors.green
                  : group.groupType == GroupType.Primary
                      // a cg is only valid if the number of actions is greater then 4 and
                      // less then or equal to 6
                      ? actions > maxPrimaryActions ||
                              actions < minPrimaryActions
                          ? Colors.red
                          : Colors.green
                      : actions > maxSecondaryAction
                          ? Colors.red
                          : Colors.green,
            ),
          ),
          group.groupType == GroupType.Primary
              ? SizedBox(
                  height: _groupHeaderHeight,
                  child: Align(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 0, left: 5, top: 5, bottom: 5),
                          child: Text(
                            'Vet Group',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 35,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 5, left: 5, top: 5, bottom: 5),
                            child: Tooltip(
                              child: Checkbox(
                                onChanged: (bool? newValue) {
                                  cg.isVeteran =
                                      newValue != null ? newValue : false;
                                },
                                value: cg.isVeteran,
                              ),
                              message:
                                  'Check to make this squad a veteran squad',
                              waitDuration: settings.tooltipDelay,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                )
              : Container(),
          group.groupType == GroupType.Primary
              ? Expanded(
                  child: SizedBox(
                    height: _groupHeaderHeight,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => {_showSettingsDialog(context)},
                        icon: Icon(
                          settingsIcon,
                          color: Colors.green,
                        ),
                        splashRadius: 20.0,
                        padding: EdgeInsets.zero,
                        tooltip: 'Options for ${cg.name}',
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final settingsDialog = CombatGroupSettingsDialog(
      cg: cg,
      ruleSet: roster.rulesetNotifer.value,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return settingsDialog;
        });
  }
}
