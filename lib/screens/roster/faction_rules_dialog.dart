import 'package:flutter/material.dart';
import 'package:gearforce/models/factions/faction_upgrades.dart';

const double _optionSectionWidth = 400;
const double _optionSectionHeight = 33;

class FactionRulesDialog extends StatelessWidget {
  const FactionRulesDialog({
    super.key,
    required this.upgrades,
    this.isCore = true,
  });

  final List<FactionUpgrade> upgrades;
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

Widget _factionOptions(List<FactionUpgrade> options, bool isCore) {
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
                return OptionLine(upgrade: options[index]);
              },
            ),
          ),
        ),
      ],
    ),
  );
}

const int _maxOptionNameLines = 2;

class OptionLine extends StatefulWidget {
  const OptionLine({super.key, required this.upgrade});
  final FactionUpgrade upgrade;

  @override
  State<OptionLine> createState() => _OptionLineState();
}

class _OptionLineState extends State<OptionLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.upgrade.isAutoEnabled,
            onChanged: (bool? newValue) {
              setState(() {
                // TODO add functionality
              });
            }),
        Tooltip(
          child: Text(
            '${widget.upgrade.name} ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
            maxLines: _maxOptionNameLines,
          ),
          richMessage: WidgetSpan(
            baseline: TextBaseline.alphabetic,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250.0),
              child: Text(
                widget.upgrade.description,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
              padding: EdgeInsets.all(5),
            ),
          ),
          preferBelow: true,
          waitDuration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}
