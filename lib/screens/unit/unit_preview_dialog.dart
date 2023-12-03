import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

const _horizontalBorder = const BorderSide();
const _primaryStatWidth = 70.0;
const _reactSymbol = '»';

class UnitPreviewDialog extends StatelessWidget {
  final Unit unit;

  const UnitPreviewDialog({super.key, required this.unit});
  @override
  Widget build(BuildContext context) {
    var dialog = SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(5.0, 12.0, 5.0, 12.0),
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadiusDirectional.circular(5.0)),
          child: Column(
            children: [
              _nameRow(context),
              _StatsRow(context),
              _TraitsRow(context),
              _WeaponsRow(context),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Done',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
    return dialog;
  }

  Widget _nameRow(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unit.name),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(bottom: _horizontalBorder),
      ),
    );
  }

  Widget _StatsRow(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: _primaryStatWidth,
            child: _PrimaryStats(context),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(),
              ),
            ),
          ),
          Flexible(
            child: _SecondaryStats(context),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
        bottom: _horizontalBorder,
      )),
    );
  }

  Widget _PrimaryStats(BuildContext context) {
    final gunnery = unit.gunnery == null ? '-' : '${unit.gunnery}+';
    final piloting = unit.piloting == null ? '-' : '${unit.piloting}+';
    final ew = unit.ew == null ? '-' : '${unit.ew}+';
    final actions = unit.actions == null ? '-' : '${unit.actions}';
    final armor = unit.armor == null ? '-' : '${unit.armor}';

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        children: [
          Table(
            children: [
              TableRow(children: [
                Text('Gu:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(gunnery),
                ),
              ]),
              TableRow(children: [
                Text('Pi:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(piloting),
                ),
              ]),
              TableRow(children: [
                Text('Ew:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(ew),
                ),
              ]),
              TableRow(children: [
                Text('A:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(actions),
                ),
              ]),
              TableRow(children: [
                Text('Arm:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(armor),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(35),
            },
          )
        ],
      ),
    );
  }

  Widget _SecondaryStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            children: [
              TableRow(children: [
                Text('Gear:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('${unit.height}"'),
                ),
              ]),
              TableRow(children: [
                Text('Cmd:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('-'),
                ),
              ]),
              TableRow(children: [
                Text('MR:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('${unit.movement}'),
                ),
              ]),
              TableRow(children: [
                Text('H:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('${unit.hull == null ? '-' : '${unit.hull}'}'),
                ),
              ]),
              TableRow(children: [
                Text('S:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                      '${unit.structure == null ? '-' : '${unit.structure}'}'),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(35),
              1: IntrinsicColumnWidth(),
            },
          ),
          Spacer(),
          Table(
            children: [
              TableRow(children: [
                Text('TV:', textAlign: TextAlign.right),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('${unit.tv}'),
                ),
              ]),
              TableRow(children: [
                Text(
                  '${unit.commandLevel == CommandLevel.none ? 'SP' : 'CP'}:',
                  textAlign: TextAlign.right,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                      '${unit.commandLevel == CommandLevel.none ? unit.skillPoints : unit.commandPoints}'),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(35),
              1: IntrinsicColumnWidth(),
            },
          ),
        ],
      ),
    );
  }

  Widget _TraitsRow(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          children: [Text(unit.traits.join(', '))],
        ),
      ),
      decoration: BoxDecoration(
          border: Border(
        bottom: _horizontalBorder,
      )),
    );
  }

  Widget _WeaponsRow(BuildContext context) {
    final weaponTable = Table(
      children: [
        const TableRow(
          children: [
            Text('Code'),
            Text('Range'),
            Text('D'),
            Text('Traits'),
            Text('Mode')
          ],
        ),
      ],
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(50),
        1: FixedColumnWidth(60),
        2: FixedColumnWidth(15),
        3: FlexColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
    );

    // TODO Handle combo weapons
    unit.weapons.forEach((w) {
      weaponTable.children.add(TableRow(children: [
        Text('${w.hasReact ? '$_reactSymbol' : ''}${w.abbreviation}'),
        Text('${w.range}'),
        Text('${w.damage}'),
        Text('${w.traits.join(', ')}'),
        Text(
          '${w.modes.map((m) => getWeaponModeName(m)[0]).toList().join(', ')}',
          textAlign: TextAlign.center,
        )
      ]));
    });

    final layout = Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        child: weaponTable);

    return layout;
  }
}
