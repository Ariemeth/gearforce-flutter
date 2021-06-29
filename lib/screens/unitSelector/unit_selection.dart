import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/screens/unitSelector/unit_selection_text_Cell.dart';
import 'package:provider/provider.dart';

class UnitSelection extends StatefulWidget {
  final Map<RoleType, bool> _filters = <RoleType, bool>{};

  UnitSelection() {
    RoleType.values.forEach((element) {
      _filters.addAll({element: false});
    });
  }

  @override
  _UnitSelectionState createState() => _UnitSelectionState();
}

class _UnitSelectionState extends State<UnitSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionFilters(
          filters: widget._filters,
          onChanged: (RoleType role, bool newValue) {
            setState(() {
              widget._filters[role] = newValue;
            });
          },
        ),
        Expanded(child: SelectionList(filters: widget._filters)),
      ],
    );
  }
}

class SelectionList extends StatelessWidget {
  const SelectionList({
    Key? key,
    required this.filters,
  }) : super(key: key);

  final Map<RoleType, bool> filters;
  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();
    final data = context.watch<Data>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            child: SingleChildScrollView(
              child: buildTable(data, roster.faction.value),
              scrollDirection: Axis.horizontal,
            ),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

  Table buildTable(Data data, Factions? faction) {
    if (faction == null) {
      return Table();
    }
    var d = data.unitList(
      faction,
      role: this
          .filters
          .entries
          .where((filterMap) => filterMap.value)
          .map((filterMap) => filterMap.key)
          .toList(),
    );
    var table = Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        5: IntrinsicColumnWidth(),
        6: IntrinsicColumnWidth(),
        7: IntrinsicColumnWidth(),
        8: IntrinsicColumnWidth(),
        9: IntrinsicColumnWidth(),
        10: IntrinsicColumnWidth(),
        11: IntrinsicColumnWidth(),
        12: IntrinsicColumnWidth(),
        13: IntrinsicColumnWidth(),
        14: IntrinsicColumnWidth(),
      },
      children: <TableRow>[
        buildTitleRow(),
        ...d.map((e) => buildRow(e)).toList()
      ],
    );
    return table;
  }

  TableRow buildTitleRow() {
    return TableRow(children: <Widget>[
      UnitSelectionTextCell.columnTitle(
        'Model',
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(3, 5, 5, 5),
      ),
      UnitSelectionTextCell.columnTitle('TV'),
      UnitSelectionTextCell.columnTitle('Roles'),
      UnitSelectionTextCell.columnTitle('MR'),
      UnitSelectionTextCell.columnTitle('Arm'),
      UnitSelectionTextCell.columnTitle('H/S'),
      UnitSelectionTextCell.columnTitle('Actions'),
      UnitSelectionTextCell.columnTitle('GU'),
      UnitSelectionTextCell.columnTitle('PI'),
      UnitSelectionTextCell.columnTitle('EW'),
      UnitSelectionTextCell.columnTitle(
        'React Weapons',
        maxLines: 1,
      ),
      UnitSelectionTextCell.columnTitle(
        'Mounted Weapons',
        maxLines: 1,
      ),
      UnitSelectionTextCell.columnTitle('Traits'),
      UnitSelectionTextCell.columnTitle('Type'),
      UnitSelectionTextCell.columnTitle('Height'),
    ]);
  }

  TableRow buildRow(UnitCore uc) {
    return TableRow(children: <Widget>[
      Draggable<UnitCore>(
        //TODO add constructor to UnitSelectionTextCell for this case
        childWhenDragging: UnitSelectionTextCell.content(
          '${uc.name}',
          //backgroundColor: Colors.blue[600],
          border: Border.all(
            color: Colors.green,
            width: 2.0,
          ),
          maxLines: 1,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
          // textStyle: TextStyle(fontSize: 14, decoration: TextDecoration.none),
        ),
        feedback: Container(
          color: Colors.blue[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO add constructor to UnitSelectionTextCell for this case
              UnitSelectionTextCell.content(
                'Model: ${uc.name}',
                maxLines: 1,
                alignment: Alignment.centerLeft,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                ),
              ),
              UnitSelectionTextCell.content('TV: ${uc.tv}',
                  maxLines: 1,
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  )),
              UnitSelectionTextCell.content(
                  'Roles: ${uc.role!.roles.join(', ')}',
                  maxLines: 1,
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  )),
            ],
          ),
        ),
        data: uc,
        child: UnitSelectionTextCell.content(
          '${uc.name}',
          maxLines: 1,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(3, 5, 5, 5),
        ),
      ),
      UnitSelectionTextCell.content('${uc.tv}'),
      UnitSelectionTextCell.content(
        '${uc.role!.roles.join(', ')}',
        maxLines: 2,
        softWrap: false,
      ),
      UnitSelectionTextCell.content('${uc.movement}'),
      UnitSelectionTextCell.content('${uc.armor}'),
      UnitSelectionTextCell.content('${uc.hull}/${uc.structure}'),
      UnitSelectionTextCell.content('${uc.actions}'),
      UnitSelectionTextCell.content('${uc.gunnery}+'),
      UnitSelectionTextCell.content('${uc.piloting}+'),
      UnitSelectionTextCell.content('${uc.ew}+'),
      UnitSelectionTextCell.content(
        '${uc.reactWeapons.join(', ')}',
        maxLines: 2,
      ),
      UnitSelectionTextCell.content(
        '${uc.mountedWeapons.join(', ')}',
        maxLines: 2,
      ),
      UnitSelectionTextCell.content('${uc.traits.join(', ')}'),
      UnitSelectionTextCell.content('${uc.type}'),
      UnitSelectionTextCell.content('${uc.height}'),
    ]);
  }
}

class SelectionFilters extends StatelessWidget {
  const SelectionFilters({
    Key? key,
    required this.filters,
    required this.onChanged,
  }) : super(key: key);

  final Map<RoleType, bool> filters;
  final void Function(RoleType, bool) onChanged;

  @override
  Widget build(BuildContext context) {
    var f = this
        .filters
        .entries
        .map((e) => FilterSelection(
            isChecked: e.value, onChanged: this.onChanged, role: e.key))
        .toList();

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Filters:  ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Text(
              'Roles:  ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...f
          ],
        ),
      ],
    );
  }
}

class FilterSelection extends StatelessWidget {
  const FilterSelection({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.role,
  }) : super(key: key);
  final bool isChecked;
  final void Function(RoleType, bool) onChanged;
  final RoleType role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          this.role.toString().split('.').last,
          style: TextStyle(fontSize: 16),
        ),
        Checkbox(
          value: this.isChecked,
          onChanged: (bool? value) => onChanged(this.role, value!),
        )
      ],
    );
  }
}
