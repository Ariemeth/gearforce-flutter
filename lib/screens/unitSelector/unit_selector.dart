import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

const _numColumns = 14;

class UnitSelector extends StatefulWidget {
  UnitSelector({
    Key? key,
  }) : super(key: key);

  @override
  _UnitSelectorState createState() => _UnitSelectorState();
}

class _UnitSelectorState extends State<UnitSelector> {
  @override
  Widget build(BuildContext context) {
    return _generateTable(context);
  }

  StickyHeadersTable _generateTable(BuildContext context) {
    final data = Provider.of<Data>(context);
    final roster = context.watch<UnitRoster>();

    final faction = roster.faction.value;

    if (faction == null) {
      return StickyHeadersTable(
        legendCell: UnitTextCell.columnTitle(
          "No units to display",
          textStyle: TextStyle(fontSize: 36),
          padding: EdgeInsets.zero,
        ),
        columnsLength: 0,
        rowsLength: 0,
        cellDimensions: CellDimensions.uniform(width: 300, height: 40),
        columnsTitleBuilder: (i) => Text(''),
        rowsTitleBuilder: (i) => Text(''),
        contentCellBuilder: (i, j) => Text(''),
      );
    }
    var table = StickyHeadersTable(
      legendCell: UnitTextCell.columnTitle(
        "Model Name",
        backgroundColor: Colors.blue[100],
        textAlignment: TextAlign.left,
      ),
      columnsLength: _numColumns,
      rowsLength: data.unitList(faction, role: null).length,
      columnsTitleBuilder: _buildColumnTitles,
      rowsTitleBuilder: _buildRowTitles(faction, data),
      contentCellBuilder: _buildCellContent(faction, data),
      onContentCellPressed: _contentPressed(faction, roster, data),
      onRowTitlePressed: _rowTitlePressed(faction, roster, data),
    );
    return table;
  }

  Widget _buildColumnTitles(int i) {
    return buildUnitTitleCell(i);
  }

  Widget Function(int) _buildRowTitles(Factions f, Data data) {
    return (int i) {
      return UnitTextCell.content(
        data.unitList(f, role: null)[i].name,
        backgroundColor: ((i + 1) % 2 == 0) ? Colors.blue[100] : null,
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      );
    };
  }

  Widget Function(int, int) _buildCellContent(Factions f, Data data) {
    return (int i, int j) {
      UnitCore unit = data.unitList(f, role: null)[j];
      return buildUnitCell(i, j, unit);
    };
  }

  dynamic Function(int, int) _contentPressed(
      Factions f, UnitRoster roster, Data data) {
    return (int i, int j) {
      UnitCore unit = data.unitList(f, role: null)[j];
      roster.activeCG()!.primary.addUnit(unit);
    };
  }

  dynamic Function(int) _rowTitlePressed(
      Factions f, UnitRoster roster, Data data) {
    return (int i) {
      UnitCore unit = data.unitList(f, role: null)[i];
      roster.activeCG()!.primary.addUnit(unit);
    };
  }
}
