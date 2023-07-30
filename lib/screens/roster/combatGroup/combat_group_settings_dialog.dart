import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/screens/roster/combatGroup/delete_combat_group_dialog.dart';
import 'package:gearforce/screens/roster/combatGroup/option_line.dart';
import 'package:gearforce/widgets/options_section_title.dart';

const double _optionSectionWidth = 400;
const double _optionSectionHeight = 33;
const int _maxVisibleOptions = 4;
const String _optionText = 'Rules Options';

class CombatGroupSettingsDialog extends StatefulWidget {
  const CombatGroupSettingsDialog({
    super.key,
    required this.cg,
    required this.ruleSet,
  });

  final CombatGroup cg;
  final RuleSet ruleSet;

  @override
  State<CombatGroupSettingsDialog> createState() =>
      _CombatGroupSettingsDialogState();
}

class _CombatGroupSettingsDialogState extends State<CombatGroupSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    final options = widget.cg.options;

    final onLineUpdate = () {
      setState(() {});
    };

    var dialog = SimpleDialog(
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Column(
          children: [
            Text(
              '${widget.cg.name} settings',
              style: TextStyle(fontSize: 24),
              maxLines: 1,
            ),
            Text(''),
            options.isNotEmpty
                ? combatGroupOptions(options, widget.cg, onLineUpdate)
                : Container(),
            Text(''),
            ElevatedButton(
              onPressed: () {
                final optionsDialog =
                    DeleteCombatGroupDialog(cgName: widget.cg.name);

                Future<DeleteCGOptionResult?> futureResult =
                    showDialog<DeleteCGOptionResult>(
                        context: context,
                        builder: (BuildContext context) {
                          return optionsDialog;
                        });

                futureResult.then((value) {
                  switch (value) {
                    case DeleteCGOptionResult.Remove:
                      widget.cg.roster!.removeCG(widget.cg.name);
                      Navigator.pop(context);
                      break;
                    default:
                  }
                });
              },
              child: Text('Delete ${widget.cg.name}'),
              style: ElevatedButton.styleFrom(
                elevation: 12.0,
                textStyle: const TextStyle(color: Colors.white),
                backgroundColor: Color.fromARGB(255, 200, 28, 28),
              ),
            ),
            Text(''),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 24, color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return dialog;
  }
}

Widget combatGroupOptions(
  List<CombatGroupOption> options,
  CombatGroup cg,
  void Function() onLineUpdated,
) {
  if (options.isEmpty) {
    return const Center(
      child: Text(
        'no upgrades available',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  return Column(
    children: [
      optionsSectionTitle(_optionText),
      Container(
        width: _optionSectionWidth,
        height: _optionSectionHeight +
            _optionSectionHeight *
                (options.length > _maxVisibleOptions
                    ? _maxVisibleOptions
                    : options.length.toDouble()),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: _scrollController,
          interactive: true,
          child: ListView.builder(
            itemCount: options.length,
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return OptionLine(
                cg: cg,
                cgOption: options[index],
                onLineUpdated: onLineUpdated,
              );
            },
          ),
        ),
      ),
    ],
  );
}
