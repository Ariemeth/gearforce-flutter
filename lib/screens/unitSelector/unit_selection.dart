import 'package:flutter/material.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
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
  SpecialUnitFilter? _specialUnitFilter;

  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();
    final vScrollController = ScrollController();

    // Populate the dropdown with the first filter if it hasn't already been set
    // or if the current filter isn't part of the available filters for this
    // ruleset.
    if (_specialUnitFilter == null ||
        !roster.rulesetNotifer.value
            .availableUnitFilters(roster.activeCG()?.options)
            .contains(_specialUnitFilter)) {
      _specialUnitFilter = roster.rulesetNotifer.value
          .availableUnitFilters(roster.activeCG()?.options)
          .first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: ScrollController(),
          child: SelectionFilters(
            roleFilter: widget._roleFilter,
            onRoleFilterChanged: (RoleType role, bool newValue) {
              setState(() {
                widget._roleFilter[role] = newValue;
              });
            },
            onFilterChanged: (String text) {
              setState(() {
                _filter = text;
              });
            },
            onSpecialUnitFilterChanged: (SpecialUnitFilter filter) {
              setState(() {
                _specialUnitFilter = filter;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            'Drag desired units below into CG Primary and Secondary areas on the left.',
          ),
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            controller: vScrollController,
            child: SingleChildScrollView(
              controller: vScrollController,
              primary: false,
              child: SelectionList(
                roleFilters: widget._roleFilter,
                filter: _filter,
                specialUnitFilter: _specialUnitFilter!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectionList extends StatelessWidget {
  const SelectionList({
    Key? key,
    required this.roleFilters,
    required this.filter,
    required this.specialUnitFilter,
  }) : super(key: key);

  final Map<RoleType, bool> roleFilters;
  final String? filter;
  final SpecialUnitFilter specialUnitFilter;
  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();

    return Column(
      children: [
        _buildTable(context, roster.rulesetNotifer.value),
      ],
    );
  }

  Widget _buildTable(BuildContext context, RuleSet ruleSet) {
    final availableUnits = ruleSet.availableUnits(
        role: this
            .roleFilters
            .entries
            .where((filterMap) => filterMap.value)
            .map((filterMap) => filterMap.key)
            .toList(),
        characterFilters:
            this.filter?.split(',').where((element) => element != '').toList(),
        specialUnitFilter: this.specialUnitFilter);

    final table = DataTable(
      columns: _createTableColumns(),
      rows: availableUnits.map((u) => _createTableRow(u)).toList(),
      columnSpacing: 2.0,
      horizontalMargin: 0.0,
      headingRowHeight: 30.0,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Theme.of(context).primaryColorLight,
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

  DataRow _createTableRow(Unit unit) {
    return DataRow(cells: [
      DataCell(
        Draggable<Unit>(
          childWhenDragging: Container(
              decoration: BoxDecoration(
                color: null,
                border: Border.all(
                  color: Colors.green,
                  width: 2.0,
                ),
              ),
              child: SelectedUnitModelCell(
                text: unit.name,
                hasBorder: true,
                borderSize: 2.0,
              )),
          feedback: SelectedUnitFeedback(
            unit: unit,
          ),
          data: unit,
          child: SelectedUnitModelCell(text: unit.name),
        ),
      ),
      DataCell(UnitSelectionTextCell.content('${unit.tv}')),
      DataCell(
        UnitSelectionTextCell.content(
          unit.role != null ? '${unit.role!.roles.join(', ')}' : 'N/A',
          maxLines: 2,
          softWrap: true,
        ),
      ),
      DataCell(UnitSelectionTextCell.content(
          '${unit.movement == null ? '-' : unit.movement}')),
      DataCell(UnitSelectionTextCell.content(
          '${unit.armor == null ? '-' : unit.armor}')),
      DataCell(UnitSelectionTextCell.content(
          '${unit.hull == null ? '-' : unit.hull}/${unit.structure == null ? '-' : unit.structure}')),
      DataCell(UnitSelectionTextCell.content(
          '${unit.actions == null ? '-' : unit.actions}')),
      DataCell(UnitSelectionTextCell.content(
          unit.gunnery == null ? '-' : '${unit.gunnery}+')),
      DataCell(UnitSelectionTextCell.content(
          unit.piloting == null ? '-' : '${unit.piloting}+')),
      DataCell(
          UnitSelectionTextCell.content(unit.ew == null ? '-' : '${unit.ew}+')),
      DataCell(
        UnitSelectionTextCell.content(
          '${(unit.reactWeapons.toList()..addAll(unit.mountedWeapons.toList())).map((e) => e.hasReact ? '$_reactSymbol${e}' : '${e}').toList().join(', ')}',
          maxLines: 3,
          alignment: Alignment.centerLeft,
          textAlignment: TextAlign.left,
        ),
      ),
      DataCell(UnitSelectionTextCell.content(
        '${unit.traits.join(', ')}',
        maxLines: 3,
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      )),
      DataCell(UnitSelectionTextCell.content('${unit.type}')),
      DataCell(UnitSelectionTextCell.content('${unit.height}')),
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
