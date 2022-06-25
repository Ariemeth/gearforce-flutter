import 'package:flutter/material.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class AirStrikeSelectorDialog extends StatefulWidget {
  const AirStrikeSelectorDialog(
    this.roster, {
    Key? key,
  }) : super(key: key);

  final UnitRoster roster;

  @override
  State<AirStrikeSelectorDialog> createState() =>
      _AirStrikeSelectorDialogState();
}

class _AirStrikeSelectorDialogState extends State<AirStrikeSelectorDialog> {
  @override
  Widget build(BuildContext context) {
    //  final data = context.watch<Data>();

    final airstrikes =
        widget.roster.subFaction.value.ruleSet?.airstrikeCounters();

    SimpleDialog optionsDialog = SimpleDialog(
      title: Center(child: const Text('Airstrikes')),
      shape: ContinuousRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      children: [
        Center(child: Text('Total TV: ${widget.roster.airStrikeTV}')),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Table(
            columnWidths: const <int, TableColumnWidth>{},
            defaultColumnWidth: const IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: airstrikes != null
                ? airstrikes
                    .map((uc) => _buildTableRow(uc, widget.roster,
                        count: widget.roster.airStrikes.keys
                                .any((element) => element.name == uc.name)
                            ? widget.roster.airStrikes[
                                widget.roster.airStrikes.keys.firstWhere(
                                    (element) => element.name == uc.name)]!
                            : 0))
                    .toList()
                : [],
          ),
        )
      ],
    );
    return optionsDialog;
  }

  TableRow _buildTableRow(
    UnitCore unit,
    UnitRoster roster, {
    required int count,
  }) {
    return TableRow(children: [
      Tooltip(
        message: 'gu: ${unit.gunnery}\n' +
            'pi: ${unit.piloting}\n' +
            'weapons: ${unit.mountedWeapons.toString()}',
        child: Text(
          '${unit.name}',
          style: const TextStyle(fontSize: 16),
        ),
        textStyle: TextStyle(fontSize: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey,
        ),
      ),
      Text('TV: ${unit.tv} each'),
      Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 5.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: (() {
                setState(() {
                  roster.removeAirStrike(unit.name);
                });
              }),
              child: Text(
                '-',
                style: const TextStyle(fontSize: 20),
              ),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: (() {
                setState(() {
                  roster.addAirStrike(Unit(core: unit));
                });
              }),
              child: Text(
                '+',
                style: const TextStyle(fontSize: 20),
              ),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
