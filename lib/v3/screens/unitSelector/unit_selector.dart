import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/unitSelector/selected_unit_feedback.dart';
import 'package:gearforce/v3/screens/unitSelector/selected_unit_model_cell.dart';
import 'package:gearforce/v3/screens/unitSelector/selection_filters.dart';
import 'package:gearforce/v3/screens/unitSelector/unit_preview_button.dart';
import 'package:gearforce/v3/screens/unitSelector/unit_selector_text_cell.dart';
import 'package:provider/provider.dart';

const _reactSymbol = '»';

class UnitSelector extends StatefulWidget {
  final Map<RoleType, bool> _roleFilter = <RoleType, bool>{};

  UnitSelector({super.key}) {
    for (var element in RoleType.values) {
      _roleFilter.addAll({element: false});
    }
  }

  @override
  _UnitSelectorState createState() => _UnitSelectorState();
}

class _UnitSelectorState extends State<UnitSelector> {
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
        const Padding(
          padding: EdgeInsets.all(2.0),
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
    super.key,
    required this.roleFilters,
    required this.filter,
    required this.specialUnitFilter,
  });

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
        role: roleFilters.entries
            .where((filterMap) => filterMap.value)
            .map((filterMap) => filterMap.key)
            .toList(),
        characterFilters:
            filter?.split(',').where((element) => element != '').toList(),
        specialUnitFilter: specialUnitFilter);

    final table = DataTable(
      columns: _createTableColumns(),
      rows: availableUnits.map((u) => _createTableRow(u)).toList(),
      columnSpacing: 2.0,
      horizontalMargin: 0.0,
      headingRowHeight: 30.0,
      headingRowColor: WidgetStateColor.resolveWith(
        (states) => Theme.of(context).primaryColorLight,
      ),
    );

    return table;
  }

  List<DataColumn> _createTableColumns() {
    return <DataColumn>[
      _createTableColumn(''),
      _createTableColumn(
        'Model',
        alignment: Alignment.centerLeft,
        textAlign: TextAlign.left,
      ),
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
      DataCell(UnitPreviewButton(unit: unit)),
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
      DataCell(UnitSelectorTextCell.content('${unit.tv}')),
      DataCell(
        UnitSelectorTextCell.content(
          unit.role != null ? unit.role!.roles.join(', ') : 'N/A',
          maxLines: 2,
          softWrap: true,
        ),
      ),
      DataCell(UnitSelectorTextCell.content('${unit.movement ?? '-'}')),
      DataCell(UnitSelectorTextCell.content('${unit.armor ?? '-'}')),
      DataCell(UnitSelectorTextCell.content(
          '${unit.hull ?? '-'}/${unit.structure ?? '-'}')),
      DataCell(UnitSelectorTextCell.content('${unit.actions ?? '-'}')),
      DataCell(UnitSelectorTextCell.content(
          unit.gunnery == null ? '-' : '${unit.gunnery}+')),
      DataCell(UnitSelectorTextCell.content(
          unit.piloting == null ? '-' : '${unit.piloting}+')),
      DataCell(
          UnitSelectorTextCell.content(unit.ew == null ? '-' : '${unit.ew}+')),
      DataCell(
        UnitSelectorTextCell.content(
          (unit.reactWeapons.toList()..addAll(unit.mountedWeapons.toList()))
              .map((e) => e.hasReact ? '$_reactSymbol$e' : '$e')
              .toList()
              .join(', '),
          maxLines: 3,
          alignment: Alignment.centerLeft,
          textAlignment: TextAlign.left,
        ),
      ),
      DataCell(UnitSelectorTextCell.content(
        unit.traits.join(', '),
        maxLines: 3,
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      )),
      DataCell(UnitSelectorTextCell.content('${unit.type}')),
      DataCell(UnitSelectorTextCell.content(unit.height)),
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
        child: SizedBox(
          width: width,
          child: UnitSelectorTextCell.columnTitle(
            text,
            textAlignment: textAlign,
            alignment: alignment,
          ),
        ),
      ),
    );
  }
}
