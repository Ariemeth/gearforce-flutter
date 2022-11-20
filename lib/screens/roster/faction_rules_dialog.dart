import 'package:flutter/material.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/screens/roster/faction_rules_line.dart';

const double _optionSectionWidth = 400;
const double _optionSectionHeight = 33;

class FactionRulesDialog extends StatelessWidget {
  const FactionRulesDialog({
    super.key,
    required this.upgrades,
    this.isCore = true,
  });

  final List<FactionRule> upgrades;
  final bool isCore;

  @override
  Widget build(BuildContext context) {
    final headerString = isCore ? 'Faction' : 'Sub-List';
    var dialog = SimpleDialog(
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Column(
          children: [
            Text(
              '$headerString Rules',
              style: TextStyle(fontSize: 24),
              maxLines: 1,
            ),
            Text(''),
            _factionOptions(upgrades, isCore),
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

Widget _factionOptions(List<FactionRule> options, bool isCore) {
  if (options.isEmpty) {
    return const Text('No Faction Rules');
  }

  final _scrollController = ScrollController();

  return Container(
    width: _optionSectionWidth,
    height: _optionSectionHeight + _optionSectionHeight * options.length,
    child: Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              itemCount: options.length,
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final option = options[index];
                if (option.options != null && option.options!.isNotEmpty) {
                  return Column(
                    children: [
                      FactionRulesLine(upgrade: option),
                      ...option.options!
                          .map((o) => FactionRulesLine(
                                upgrade: o,
                                leftOffset: 25.0,
                              ))
                          .toList()
                    ],
                  );
                } else {
                  return FactionRulesLine(upgrade: option);
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}
