import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/screens/roster/delete_combat_group_dialog.dart';

class CombatGroupSettingsDialog extends StatelessWidget {
  const CombatGroupSettingsDialog({
    super.key,
    required this.cg,
    required this.ruleSet,
  });

  final CombatGroup cg;
  final RuleSet ruleSet;

  @override
  Widget build(BuildContext context) {
    // TODO create options sections
    var dialog = SimpleDialog(
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Column(
          children: [
            Text(
              '${cg.name} settings',
              style: TextStyle(fontSize: 24),
              maxLines: 1,
            ),
            Text(''),
            ElevatedButton(
              onPressed: () {
                final optionsDialog = DeleteCombatGroupDialog(cgName: cg.name);

                Future<DeleteCGOptionResult?> futureResult =
                    showDialog<DeleteCGOptionResult>(
                        context: context,
                        builder: (BuildContext context) {
                          return optionsDialog;
                        });

                futureResult.then((value) {
                  switch (value) {
                    case DeleteCGOptionResult.Remove:
                      cg.roster!.removeCG(cg.name);
                      Navigator.pop(context);
                      break;
                    default:
                  }
                });
              },
              child: Text('Delete ${cg.name}'),
              style: ElevatedButton.styleFrom(
                elevation: 12.0,
                textStyle: const TextStyle(color: Colors.white),
                backgroundColor: Color.fromARGB(255, 200, 28, 28),
              ),
            ),
            Text(''),
          ],
        ),
      ),
    );

    return dialog;
  }
}
