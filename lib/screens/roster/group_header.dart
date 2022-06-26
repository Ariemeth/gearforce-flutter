import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/widgets/display_value.dart';

const _maxPrimaryActions = 6;
const _minPrimaryActions = 4;
const _groupHeaderHeight = 35.0;

class GroupHeader extends StatelessWidget {
  const GroupHeader({
    Key? key,
    required this.cg,
    required this.group,
    this.roster,
  }) : super(key: key);

  final CombatGroup cg;
  final Group group;
  final UnitRoster? roster;

  @override
  Widget build(BuildContext context) {
    final actions = group.totalActions();
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
            ),
            width: 75,
          ),
          SizedBox(
            width: 20,
          ),
          DisplayValue(text: 'TV:', value: group.totalTV()),
          Tooltip(
            message: group.groupType == GroupType.Primary
                // a cg is only valid if the number of actions is greater then 4 and
                // less then or equal to 6
                ? actions > _maxPrimaryActions || actions < _minPrimaryActions
                    ? 'too many or too few actions'
                    : 'valid number of actions'
                : actions > (cg.primary.totalActions() / 2).ceil()
                    ? 'too many actions or too few actions'
                    : 'valid number of actions',
            child: DisplayValue(
              text: 'Actions',
              value: actions,
              textColor: cg.modCount(independentOperatorId) != 0
                  ? Colors.green
                  : group.groupType == GroupType.Primary
                      // a cg is only valid if the number of actions is greater then 4 and
                      // less then or equal to 6
                      ? actions > _maxPrimaryActions ||
                              actions < _minPrimaryActions
                          ? Colors.red
                          : Colors.green
                      : actions > (cg.primary.totalActions() / 2).ceil()
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
                        onPressed: () =>
                            {_showConfirmDelete(context, cg.name, roster!)},
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Color.fromARGB(255, 200, 28, 28),
                        ),
                        splashRadius: 20.0,
                        padding: EdgeInsets.zero,
                        tooltip: 'Delete combat group ${cg.name}',
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _showConfirmDelete(
    BuildContext context,
    String combatGroupName,
    UnitRoster roster,
  ) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Column(
        children: [
          Text(
            'Are you sure you want to remove',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            '$combatGroupName?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Remove);
          },
          child: Center(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Cancel);
          },
          child: Center(
            child: Text(
              'No',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );

    Future<OptionResult?> futureResult = showDialog<OptionResult>(
        context: context,
        builder: (BuildContext context) {
          return optionsDialog;
        });

    futureResult.then((value) {
      switch (value) {
        case OptionResult.Remove:
          roster.removeCG(combatGroupName);
          break;
        default:
      }
    });
  }
}

enum OptionResult { Remove, Cancel }
