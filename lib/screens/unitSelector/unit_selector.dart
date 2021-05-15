import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class UnitSelector extends StatefulWidget {
  UnitSelector({
    Key? key,
    required this.title,
    required this.data,
    required this.faction,
  }) : super(key: key);

  final String? title;
  final Data data;
  final String faction;

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
        child: _generateTable(widget.data, widget.faction),
      ),
    );
  }

  StickyHeadersTable _generateTable(Data data, String faction) {
    // using a switch until the faction string is refactored to the enum
    switch (faction) {
      case "North":
        var table = StickyHeadersTable(
          legendCell: UnitTextCell.columnTitle(
            "Model Name",
            backgroundColor: Colors.blueGrey[100],
            textAlignment: TextAlign.left,
          ),
          columnsLength: 12,
          rowsLength: data.unitList(Factions.North).length,
          columnsTitleBuilder: _buildColumnTitles,
          rowsTitleBuilder: _buildRowTitles(Factions.North, widget.data),
          contentCellBuilder: _buildCellContent(Factions.North, widget.data),
          onContentCellPressed: _contentPressed(Factions.North, widget.data),
          onRowTitlePressed: _rowTitlePressed(Factions.North, widget.data),
        );
        return table;
      case "Peace River":
        var table = StickyHeadersTable(
          legendCell: UnitTextCell.columnTitle(
            "Model Name",
            backgroundColor: Colors.blueGrey[100],
            textAlignment: TextAlign.left,
          ),
          columnsLength: 12,
          rowsLength: data.unitList(Factions.PeaceRiver).length,
          columnsTitleBuilder: _buildColumnTitles,
          rowsTitleBuilder: _buildRowTitles(Factions.PeaceRiver, widget.data),
          contentCellBuilder:
              _buildCellContent(Factions.PeaceRiver, widget.data),
          onContentCellPressed:
              _contentPressed(Factions.PeaceRiver, widget.data),
          onRowTitlePressed: _rowTitlePressed(Factions.PeaceRiver, widget.data),
        );
        return table;
      default:
    }

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

  Widget _buildColumnTitles(int i) {
    return buildUnitTitleCell(i);
  }

  Widget Function(int) _buildRowTitles(Factions f, Data data) {
    return (int i) {
      return UnitTextCell.content(
        data.unitList(f)[i].name,
        backgroundColor: ((i + 1) % 2 == 0) ? Colors.blueGrey[100] : null,
      );
    };
  }

  Widget Function(int, int) _buildCellContent(Factions f, Data data) {
    return (int i, int j) {
      Unit unit = data.unitList(f)[j];
      return buildUnitCell(i, j, unit);
    };
  }

  dynamic Function(int, int) _contentPressed(Factions f, Data data) {
    return (int i, int j) {
      Unit unit = data.unitList(f)[j];
      Navigator.pop(context, unit);
    };
  }

  dynamic Function(int) _rowTitlePressed(Factions f, Data data) {
    return (int i) {
      Unit unit = data.unitList(f)[i];
      Navigator.pop(context, unit);
    };
  }
}
