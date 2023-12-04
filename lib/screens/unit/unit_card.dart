import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

const _horizontalBorder = const BorderSide();
const _primaryStatSectionWidth = 70.0;
const _primaryStatNameWidth = 35.0;
const _secondaryStatNameWidth = 35.0;
const _secondaryStatRightStatValueWidth = 25.0;
const _weaponCodeWidth = 50.0;
const _weaponRangeWidth = 60.0;
const _weaponDamageWidth = 15.0;
const _reactSymbol = '»';

class UnitCard extends StatelessWidget {
  final Unit unit;

  const UnitCard(this.unit, {super.key});
  @override
  Widget build(BuildContext context) {
    var card = Container(
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
    );

    return card;
  }

  Widget _nameRow(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 2.5),
            child: Text(
              unit.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
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
            width: _primaryStatSectionWidth,
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

    const statValuePadding = const EdgeInsets.only(left: 5.0);

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
      child: Column(
        children: [
          Table(
            children: [
              TableRow(children: [
                Text('Gu:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(gunnery),
                ),
              ]),
              TableRow(children: [
                Text('Pi:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(piloting),
                ),
              ]),
              TableRow(children: [
                Text('Ew:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(ew),
                ),
              ]),
              TableRow(children: [
                Text('A:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(actions),
                ),
              ]),
              TableRow(children: [
                Text('Arm:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(armor),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(_primaryStatNameWidth),
            },
          )
        ],
      ),
    );
  }

  Widget _SecondaryStats(BuildContext context) {
    const statValuePadding = const EdgeInsets.only(left: 5.0);

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            children: [
              TableRow(children: [
                Text('Gear:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text('${unit.height}"'),
                ),
              ]),
              TableRow(children: [
                Text('Cmd:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(
                      '${unit.commandLevel == CommandLevel.none ? '-' : '${unit.commandLevel.name}'}'),
                ),
              ]),
              TableRow(children: [
                Text('MR:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text('${unit.movement}'),
                ),
              ]),
              TableRow(children: [
                Text('H:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text('${unit.hull == null ? '-' : '${unit.hull}'}'),
                ),
              ]),
              TableRow(children: [
                Text('S:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(
                      '${unit.structure == null ? '-' : '${unit.structure}'}'),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(_secondaryStatNameWidth),
              1: IntrinsicColumnWidth(),
            },
          ),
          Spacer(),
          Table(
            children: [
              TableRow(children: [
                Text('TV:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text('${unit.tv}'),
                ),
              ]),
              TableRow(children: [
                Text(
                  '${unit.commandLevel == CommandLevel.none ? 'SP' : 'CP'}:',
                  textAlign: TextAlign.right,
                ),
                Padding(
                  padding: statValuePadding,
                  child: Text(
                      '${unit.commandLevel == CommandLevel.none ? unit.skillPoints : unit.commandPoints}'),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(_secondaryStatNameWidth),
              1: FixedColumnWidth(_secondaryStatRightStatValueWidth),
            },
          ),
        ],
      ),
    );
  }

// TODO Add tooltips with trait info
  Widget _TraitsRow(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
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

// TODO Add tooltips with weapon trait info
// TODO Add tooltips for weapon modes
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
        0: FixedColumnWidth(_weaponCodeWidth),
        1: FixedColumnWidth(_weaponRangeWidth),
        2: FixedColumnWidth(_weaponDamageWidth),
        3: FlexColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
    );

    unit.weapons.forEach((w) {
      weaponTable.children.add(TableRow(
        children: [
          _buildWeaponCode(w),
          _buildWeaponRange(w),
          _buildWeaponDamage(w),
          _buildWeaponTraits(w),
          _buildWeaponMode(w),
        ],
      ));
      if (w.isCombo && w.combo != null) {
        weaponTable.children.add(TableRow(
          children: [
            _buildWeaponCode(w.combo!),
            _buildWeaponRange(w.combo!),
            _buildWeaponDamage(w.combo!),
            _buildWeaponTraits(w.combo!),
            _buildWeaponMode(w.combo!),
          ],
        ));
      }
    });

    final layout = Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        child: weaponTable);

    return layout;
  }
}

Widget _buildWeaponCode(Weapon w) {
  return Text(
    '${w.hasReact ? _reactSymbol : ''}${w.numberOf >= 2 ? '2 x ' : ''}${w.abbreviation}',
  );
}

Widget _buildWeaponRange(Weapon w) {
  return Text('${w.range}');
}

Widget _buildWeaponDamage(Weapon w) {
  return Text('${w.damage}');
}

Widget _buildWeaponTraits(Weapon w) {
  final traits1 = w.traits.join(', ');
  final traits2 = w.alternativeTraits.join(', ');
  return Text('${traits2.isEmpty ? traits1 : '[$traits1] or [$traits2]'}');
}

Widget _buildWeaponMode(Weapon w) {
  return Text(
    '${w.modes.map((m) => getWeaponModeName(m)[0]).toList().join(', ')}',
    textAlign: TextAlign.center,
  );
}
