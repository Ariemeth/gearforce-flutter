import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/widgets/display_value.dart';

const _maxPrimaryActions = 6;
const _minPrimaryActions = 4;

class GroupHeader extends StatelessWidget {
  const GroupHeader({
    Key? key,
    required this.cg,
    required this.isPrimary,
  }) : super(key: key);

  final CombatGroup cg;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final group = isPrimary ? cg.primary : cg.secondary;
    final actions = group.totalActions();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              isPrimary ? 'Primary' : 'Secondary',
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
            message: isPrimary
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
                  : isPrimary
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
          isPrimary
              ? SizedBox(
                  height: 35,
                  child: Align(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 5, left: 5, top: 5, bottom: 5),
                          child: Text(
                            'Vet Group',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 10, left: 5, top: 5, bottom: 5),
                            child: Checkbox(
                              onChanged: (bool? newValue) {
                                cg.isVeteran =
                                    newValue != null ? newValue : false;
                              },
                              value: cg.isVeteran,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
