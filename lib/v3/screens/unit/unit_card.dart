import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

const _horizontalBorder = BorderSide();
const _primaryStatSectionWidth = 70.0;
const _primaryStatNameWidth = 35.0;
const _secondaryStatNameWidth = 38.0;
const _secondaryStatRightStatValueWidth = 25.0;
const _weaponCodeWidth = 50.0;
const _weaponRangeWidth = 60.0;
const _weaponDamageWidth = 20.0;
const _reactSymbol = '»';

class UnitCard extends StatelessWidget {
  final Unit unit;

  const UnitCard(this.unit, {super.key});
  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();

    var card = Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadiusDirectional.circular(5.0)),
      child: Column(
        children: [
          _nameRow(context),
          _statsRow(context),
          _traitsRow(settings),
          _weaponsRow(settings),
        ],
      ),
    );

    return card;
  }

  Widget _nameRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadiusDirectional.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 2.5),
            child: Text(
              unit.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        top: _horizontalBorder,
        bottom: _horizontalBorder,
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: _primaryStatSectionWidth,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(),
              ),
            ),
            child: _primaryStats(context),
          ),
          Flexible(
            child: _secondaryStats(context),
          ),
        ],
      ),
    );
  }

  Widget _primaryStats(BuildContext context) {
    final gunnery = unit.gunnery == null ? '-' : '${unit.gunnery}+';
    final piloting = unit.piloting == null ? '-' : '${unit.piloting}+';
    final ew = unit.ew == null ? '-' : '${unit.ew}+';
    final actions = unit.actions == null ? '-' : '${unit.actions}';
    final armor = unit.armor == null ? '-' : '${unit.armor}';

    const statValuePadding = EdgeInsets.only(left: 5.0);

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
      child: Column(
        children: [
          Table(
            children: [
              TableRow(children: [
                const Text('GU:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(gunnery),
                ),
              ]),
              TableRow(children: [
                const Text('PI:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(piloting),
                ),
              ]),
              TableRow(children: [
                const Text('EW:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(ew),
                ),
              ]),
              TableRow(children: [
                const Text('A:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(actions),
                ),
              ]),
              TableRow(children: [
                const Text('ARM:', textAlign: TextAlign.right),
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

  Widget _secondaryStats(BuildContext context) {
    const statValuePadding = EdgeInsets.only(left: 5.0);

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            children: [
              TableRow(children: [
                const Text('Type:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(
                      '${unit.type.name} ${unit.height != '-' ? '${unit.height}"' : ''}'),
                ),
              ]),
              TableRow(children: [
                const Text('Cmd:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(unit.commandLevel == CommandLevel.none
                      ? '-'
                      : unit.commandLevel.name),
                ),
              ]),
              TableRow(children: [
                const Text('MR:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text('${unit.movement}'),
                ),
              ]),
              TableRow(children: [
                const Text('H:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child: Text(unit.hull == null ? '-' : '${unit.hull}'),
                ),
              ]),
              TableRow(children: [
                const Text('S:', textAlign: TextAlign.right),
                Padding(
                  padding: statValuePadding,
                  child:
                      Text(unit.structure == null ? '-' : '${unit.structure}'),
                ),
              ]),
            ],
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(_secondaryStatNameWidth),
              1: IntrinsicColumnWidth(),
            },
          ),
          const Spacer(),
          Table(
            children: [
              TableRow(children: [
                const Text('TV:', textAlign: TextAlign.right),
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

  Widget _traitsRow(Settings settings) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3.0),
      child: _buildTraitList(settings, unit.traits),
    );
  }

  Widget _weaponsRow(Settings settings) {
    final weaponRows = <TableRow>[];
    for (var w in unit.weapons) {
      weaponRows.add(TableRow(
        children: [
          _buildWeaponCode(settings, w),
          _buildWeaponRange(w),
          _buildWeaponDamage(w),
          _buildWeaponTraits(settings, w),
          _buildWeaponMode(settings, w),
        ],
      ));
      if (w.isCombo && w.combo != null) {
        weaponRows.add(TableRow(
          children: [
            _buildWeaponCode(settings, w.combo!),
            _buildWeaponRange(w.combo!),
            _buildWeaponDamage(w.combo!),
            _buildWeaponTraits(settings, w.combo!),
            _buildWeaponMode(settings, w.combo!),
          ],
        ));
      }
    }

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
        ...weaponRows
      ],
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(_weaponCodeWidth),
        1: FixedColumnWidth(_weaponRangeWidth),
        2: FixedColumnWidth(_weaponDamageWidth),
        3: FlexColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
    );

    final layout = Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        child: weaponTable);

    return Container(
      decoration: const BoxDecoration(
          border: Border(
        top: _horizontalBorder,
      )),
      child: layout,
    );
  }
}

Widget _buildWeaponCode(Settings settings, Weapon w) {
  final weaponSize = switch (w.size) {
    'L' => 'Light',
    'M' => 'Medium',
    'H' => 'Heavy',
    _ => '',
  };
  return Tooltip(
    message: '$weaponSize ${w.name}',
    waitDuration: settings.tooltipDelay,
    child: Text(
      '${w.hasReact ? _reactSymbol : ''}${w.numberOf >= 2 ? '2 x ' : ''}${w.abbreviation}',
    ),
  );
}

Widget _buildWeaponRange(Weapon w) {
  return Text('${w.range}');
}

Widget _buildWeaponDamage(Weapon w) {
  return Text('${w.damage}');
}

Widget _buildWeaponTraits(Settings settings, Weapon w) {
  final traits1 = _buildTraitList(settings, w.traits);
  final traits2 = _buildTraitList(settings, w.alternativeTraits);
  return Wrap(
    children: [
      w.alternativeTraits.isEmpty ? Container() : const Text('['),
      traits1,
      w.alternativeTraits.isEmpty ? Container() : const Text(']'),
      w.alternativeTraits.isNotEmpty
          ? Tooltip(
              message: Trait.or().description,
              child: const Text(' or '),
            )
          : Container(),
      w.alternativeTraits.isEmpty ? Container() : const Text('['),
      w.alternativeTraits.isNotEmpty ? traits2 : Container(),
      w.alternativeTraits.isEmpty ? Container() : const Text(']'),
    ],
  );
}

Widget _buildWeaponMode(Settings settings, Weapon w) {
  return Tooltip(
    message: w.modes.map((m) => m.name).toList().join('\n'),
    waitDuration: settings.tooltipDelay,
    child: Text(
      w.modes.map((m) => m.abbr).toList().join(', '),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildTraitList(Settings settings, List<Trait> traits) {
  if (traits.isEmpty) {
    return const Row();
  }

  final List<Widget> traitList = [];

  for (var i = 0; i < traits.length; i++) {
    final isLast = i == traits.length - 1;
    final trait = traits[i];
    var traitStr = trait.toString() + (isLast ? '' : ', ');
    traitList.add(Tooltip(
      message: trait.description ?? '',
      waitDuration: settings.tooltipDelay,
      child: Text(
        traitStr,
        style: trait.isDisabled
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
    ));
  }
  return Wrap(
    children: traitList,
  );
}
