import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/rules/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/screens/roster/combatGroup/option_line.dart';
import 'package:gearforce/widgets/options_section_title.dart';

const double _optionSectionWidth = 400;
const double _optionSectionHeight = 33;
const int _maxVisibleOptions = 3;

class RosterSettingsDialog extends StatelessWidget {
  const RosterSettingsDialog({
    super.key,
    required this.ruleSet,
  });

  final RuleSet ruleSet;

  @override
  Widget build(BuildContext context) {
    var dialog = SimpleDialog(
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Column(
          children: [
            Text(
              'Faction settings',
              style: TextStyle(fontSize: 24),
              maxLines: 1,
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

Widget combatGroupOptions(CombatGroupOption? cgo, CombatGroup cg) {
  if (cgo == null || cgo.options.isEmpty) {
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

  return Container(
    width: _optionSectionWidth,
    height: _optionSectionHeight +
        _optionSectionHeight *
            (cgo.options.length > _maxVisibleOptions
                ? _maxVisibleOptions
                : cgo.options.length.toDouble()),
    child: Column(
      children: [
        optionsSectionTitle(cgo.name),
        Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: _scrollController,
          interactive: true,
          child: ListView.builder(
            itemCount: cgo.options.length,
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return OptionLine(
                cg: cg,
                cgOption: cgo.options[index],
              );
            },
          ),
        ),
      ],
    ),
  );
}
