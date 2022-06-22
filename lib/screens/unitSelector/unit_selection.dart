import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/screens/unitSelector/selected_unit_feedback.dart';
import 'package:gearforce/screens/unitSelector/selected_unit_model_cell.dart';
import 'package:gearforce/screens/unitSelector/selection_filters.dart';
import 'package:gearforce/screens/unitSelector/unit_selection_text_Cell.dart';
import 'package:provider/provider.dart';

const _reactSymbol = '»';

class UnitSelection extends StatefulWidget {
  final Map<RoleType, bool> _roleFilter = <RoleType, bool>{};

  UnitSelection() {
    RoleType.values.forEach((element) {
      _roleFilter.addAll({element: false});
    });
  }

  @override
  _UnitSelectionState createState() => _UnitSelectionState();
}

class _UnitSelectionState extends State<UnitSelection> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectionFilters(
            roleFilter: widget._roleFilter,
            onChanged: (RoleType role, bool newValue) {
              setState(() {
                widget._roleFilter[role] = newValue;
              });
            },
            onFilterChanged: (String text) {
              setState(() {
                _filter = text;
              });
            },
          ),
        ),
        Expanded(
            child: SelectionList(
          roleFilters: widget._roleFilter,
          filter: _filter,
        )),
      ],
    );
  }
}

class SelectionList extends StatelessWidget {
  const SelectionList({
    Key? key,
    required this.roleFilters,
    required this.filter,
  }) : super(key: key);

  final Map<RoleType, bool> roleFilters;
  final String? filter;
  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();
    final data = context.watch<Data>();

    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            child: _buildTable(data, roster.faction.value),
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
      primary: false,
    );
  }

  Widget _buildTable(Data data, Faction? faction) {
    if (faction == null) {
      return DataTable(
        columns: _createTableColumns(),
        rows: [],
        columnSpacing: 2.0,
        horizontalMargin: 0.0,
        headingRowHeight: 30.0,
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => Color.fromARGB(255, 187, 222, 251),
        ),
      );
    }

    var d = data.unitList(
      faction.factionType,
      role: this
          .roleFilters
          .entries
          .where((filterMap) => filterMap.value)
          .map((filterMap) => filterMap.key)
          .toList(),
      filters:
          this.filter?.split(',').where((element) => element != '').toList(),
    );

    var table = DataTable(
      columns: _createTableColumns(),
      rows: d.map((uc) => _createTableRow(uc)).toList(),
      columnSpacing: 2.0,
      horizontalMargin: 0.0,
      headingRowHeight: 30.0,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Color.fromARGB(255, 187, 222, 251),
      ),
    );

    return table;
  }

  List<DataColumn> _createTableColumns() {
    return <DataColumn>[
      _createTableColumn('Model',
          alignment: Alignment.centerLeft, textAlign: TextAlign.left),
      _createTableColumn('TV'),
      _createTableColumn('Roles'),
      _createTableColumn('Movement'),
      _createTableColumn('Armor'),
      _createTableColumn('H/S'),
      _createTableColumn('Actions'),
      _createTableColumn('GU'),
      _createTableColumn('PI'),
      _createTableColumn('EW'),
      _createTableColumn('Weapons', alignment: Alignment.centerLeft),
      _createTableColumn('Traits', alignment: Alignment.centerLeft),
      _createTableColumn('Type'),
      _createTableColumn('Height'),
    ];
  }

  DataRow _createTableRow(UnitCore uc) {
    return DataRow(cells: [
      DataCell(
        Draggable<UnitCore>(
          childWhenDragging: Container(
              decoration: BoxDecoration(
                color: null,
                border: Border.all(
                  color: Colors.green,
                  width: 2.0,
                ),
              ),
              child: SelectedUnitModelCell(
                text: uc.name,
                hasBorder: true,
                borderSize: 2.0,
              )),
          feedback: SelectedUnitFeedback(
            uc: uc,
          ),
          data: uc,
          child: SelectedUnitModelCell(text: uc.name),
        ),
      ),
      DataCell(UnitSelectionTextCell.content('${uc.tv}')),
      DataCell(
        UnitSelectionTextCell.content(
          uc.role != null ? '${uc.role!.roles.join(', ')}' : 'N/A',
          maxLines: 2,
          softWrap: false,
        ),
      ),
      DataCell(UnitSelectionTextCell.content(
          '${uc.movement == null ? '-' : uc.movement}')),
      DataCell(UnitSelectionTextCell.content(
          '${uc.armor == null ? '-' : uc.armor}')),
      DataCell(UnitSelectionTextCell.content(
          '${uc.hull == null ? '-' : uc.hull}/${uc.structure == null ? '-' : uc.structure}')),
      DataCell(UnitSelectionTextCell.content(
          '${uc.actions == null ? '-' : uc.actions}')),
      DataCell(UnitSelectionTextCell.content(
          uc.gunnery == null ? '-' : '${uc.gunnery}+')),
      DataCell(UnitSelectionTextCell.content(
          uc.piloting == null ? '-' : '${uc.piloting}+')),
      DataCell(
          UnitSelectionTextCell.content(uc.ew == null ? '-' : '${uc.ew}+')),
      DataCell(
        UnitSelectionTextCell.content(
          '${(uc.reactWeapons.toList()..addAll(uc.mountedWeapons.toList())).map((e) => e.hasReact ? '$_reactSymbol${e}' : '${e}').toList().join(', ')}',
          maxLines: 3,
          alignment: Alignment.centerLeft,
          textAlignment: TextAlign.left,
        ),
      ),
      DataCell(UnitSelectionTextCell.content(
        '${uc.traits.join(', ')}',
        maxLines: 3,
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      )),
      DataCell(UnitSelectionTextCell.content('${uc.type}')),
      DataCell(UnitSelectionTextCell.content('${uc.height}')),
    ]);
  }

  DataColumn _createTableColumn(
    String text, {
    double? width,
    Alignment alignment = Alignment.center,
    TextAlign textAlign = TextAlign.center,
  }) {
    return DataColumn(
      label: Expanded(
        child: Container(
          width: width,
          child: UnitSelectionTextCell.columnTitle(
            text,
            textAlignment: textAlign,
            alignment: alignment,
          ),
        ),
      ),
    );
  }
}
