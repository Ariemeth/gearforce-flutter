import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/screens/roster/faction_rules_line.dart';

const double _optionSectionWidth = 400;
const double _optionSectionHeight = 33;
const int _maxItemsToDisplay = 10;
const int _minItemsToDisplay = 4;

class FactionRulesDialog extends StatefulWidget {
  const FactionRulesDialog({
    super.key,
    required this.upgrades,
    required this.roster,
    this.isCore = true,
  });

  final List<FactionRule> upgrades;
  final bool isCore;
  final UnitRoster roster;

  @override
  State<FactionRulesDialog> createState() => _FactionRulesDialogState();
}

class _FactionRulesDialogState extends State<FactionRulesDialog> {
  @override
  Widget build(BuildContext context) {
    final headerString = widget.isCore ? 'Faction' : 'Sub-List';
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
            _factionOptions(
                widget.upgrades, widget.roster, widget.isCore, _refresh),
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

  void _refresh() {
    setState(() {});
  }
}

Widget _factionOptions(
  List<FactionRule> upgrades,
  UnitRoster roster,
  bool isCore,
  Function() notifyParent,
) {
  if (upgrades.isEmpty) {
    return const Text('No Faction Rules');
  }

  final rules = isCore
      ? upgrades
      : roster.rulesetNotifer.value
          .allFactionRules(factions: roster.allModelFactions());

  final _scrollController = ScrollController();

  return Container(
    width: _optionSectionWidth,
    height: _optionSectionHeight +
        _optionSectionHeight *
            min(max(upgrades.length, _minItemsToDisplay), _maxItemsToDisplay),
    child: Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              itemCount: upgrades.length,
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final option = upgrades[index];
                if (option.options != null && option.options!.isNotEmpty) {
                  return Column(
                    children: [
                      FactionRulesLine(
                        upgrade: option,
                        rules: rules,
                        notifyParent: notifyParent,
                      ),
                      ...option.options!
                          .map((o) => FactionRulesLine(
                                upgrade: o,
                                leftOffset: 25.0,
                                rules: rules,
                                notifyParent: notifyParent,
                              ))
                          .toList()
                    ],
                  );
                } else {
                  return FactionRulesLine(
                    upgrade: option,
                    rules: rules,
                    notifyParent: notifyParent,
                  );
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}
