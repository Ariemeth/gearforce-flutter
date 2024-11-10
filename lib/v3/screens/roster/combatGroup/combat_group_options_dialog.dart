import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/delete_combat_group_dialog.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/option_line.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/rename_combat_group_dialog.dart';
import 'package:gearforce/widgets/options_section_title.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

const double _optionSectionWidth = 400;
const double _optionSectionHeight = 33;
const int _maxVisibleOptions = 4;
const String _optionText = 'Rules Options';

class CombatGroupOptionsDialog extends StatefulWidget {
  const CombatGroupOptionsDialog({
    super.key,
    required this.cg,
    required this.ruleSet,
  });

  final CombatGroup cg;
  final RuleSet ruleSet;

  @override
  State<CombatGroupOptionsDialog> createState() =>
      _CombatGroupOptionsDialogState();
}

class _CombatGroupOptionsDialogState extends State<CombatGroupOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    final options = widget.cg.options;
    final settings = context.read<Settings>();

    onLineUpdate() {
      setState(() {});
    }

    var dialog = SimpleDialog(
      clipBehavior: Clip.antiAlias,
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Column(
          children: [
            Text(
              '${widget.cg.name} options',
              style: const TextStyle(fontSize: 24),
              maxLines: 1,
            ),
            const Text(''),
            ElevatedButton(
              onPressed: () {
                Future<RenameCGOptionResult?> futureResult =
                    showDialog<RenameCGOptionResult>(
                        context: context,
                        builder: (BuildContext context) {
                          return RenameCombatGroupDialog(
                            currentName: widget.cg.name,
                          );
                        });

                futureResult.then((value) {
                  switch (value?.resultType) {
                    case RenameCGOptionResultType.rename:
                      final newName = value?.newName;
                      if (newName != null) {
                        setState(() {
                          widget.cg.name = newName;
                        });
                      }
                      break;
                    default:
                  }
                });
              },
              child: const Text('Rename'),
            ),
            const Text(''),
            options.isNotEmpty
                ? combatGroupOptions(options, widget.cg, onLineUpdate)
                : Container(),
            const Text(''),
            ElevatedButton(
              onPressed: () {
                if (settings.requireConfirmationToDeleteCG) {
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
                      case DeleteCGOptionResult.remove:
                        widget.cg.roster!.removeCG(widget.cg.name);
                        Navigator.pop(context);
                        break;
                      default:
                    }
                  });
                } else {
                  widget.cg.roster!.removeCG(widget.cg.name);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 12.0,
                backgroundColor: Colors.red.shade700,
              ),
              child: Text(
                'Delete ${widget.cg.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(''),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Center(
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

  final ScrollController scrollController = ScrollController();

  return Column(
    children: [
      optionsSectionTitle(_optionText),
      SizedBox(
        width: _optionSectionWidth,
        height: _optionSectionHeight +
            _optionSectionHeight *
                (options.length > _maxVisibleOptions
                    ? _maxVisibleOptions
                    : options.length.toDouble()),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: scrollController,
          interactive: true,
          child: ListView.builder(
            itemCount: options.length,
            controller: scrollController,
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
