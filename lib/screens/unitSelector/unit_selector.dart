import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

const _numColumns = 14;

class UnitSelector extends StatefulWidget {
  UnitSelector({
    Key? key,
    required this.title,
    required this.faction,
    required this.role,
  }) : super(key: key);

  final String? title;
  final Factions? faction;
  final RoleType? role;

  @override
  _UnitSelectorState createState() => _UnitSelectorState();
}

class _UnitSelectorState extends State<UnitSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the Roster object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: InteractiveViewer(
        child: _generateTable(context, widget.faction),
      ),
    );
  }

  StickyHeadersTable _generateTable(BuildContext context, Factions? faction) {
    final data = Provider.of<Data>(context);

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
      rowsLength: data.unitList(faction, role: widget.role).length,
      columnsTitleBuilder: _buildColumnTitles,
      rowsTitleBuilder: _buildRowTitles(faction, data),
      contentCellBuilder: _buildCellContent(faction, data),
      onContentCellPressed: _contentPressed(faction, data),
      onRowTitlePressed: _rowTitlePressed(faction, data),
    );
    return table;
  }

  Widget _buildColumnTitles(int i) {
    return buildUnitTitleCell(i);
  }

  Widget Function(int) _buildRowTitles(Factions f, Data data) {
    return (int i) {
      return UnitTextCell.content(
        data.unitList(f, role: widget.role)[i].name,
        backgroundColor: ((i + 1) % 2 == 0) ? Colors.blue[100] : null,
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      );
    };
  }

  Widget Function(int, int) _buildCellContent(Factions f, Data data) {
    return (int i, int j) {
      Unit unit = data.unitList(f, role: widget.role)[j];
      return buildUnitCell(i, j, unit);
    };
  }

  dynamic Function(int, int) _contentPressed(Factions f, Data data) {
    return (int i, int j) {
      Unit unit = data.unitList(f, role: widget.role)[j];
      Navigator.pop(context, unit);
    };
  }

  dynamic Function(int) _rowTitlePressed(Factions f, Data data) {
    return (int i) {
      Unit unit = data.unitList(f, role: widget.role)[i];
      Navigator.pop(context, unit);
    };
  }
}
