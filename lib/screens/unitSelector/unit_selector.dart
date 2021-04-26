import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/unit/unit.dart';
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
          child: buildStickyTable(widget.data, widget.faction)),
    );
  }

  StickyHeadersTable buildStickyTable(Data data, String faction) {
    // using a switch until the faction string is refactored to the enum
    switch (faction) {
      case "North":
        var table = StickyHeadersTable(
          legendCell: Text(
            'Model Name',
            textAlign: TextAlign.left,
          ),
          columnsLength: 12,
          rowsLength: data.unitList(Factions.North).length,
          columnsTitleBuilder: buildColumnHeaders,
          rowsTitleBuilder: buildRowTitles(Factions.North, widget.data),
          contentCellBuilder: buildCellContent(Factions.North, widget.data),
        );
        return table;
      case "Peace River":
        var table = StickyHeadersTable(
          legendCell: Text(
            'Model Name',
            textAlign: TextAlign.left,
          ),
          columnsLength: 12,
          rowsLength: data.unitList(Factions.PeaceRiver).length,
          columnsTitleBuilder: buildColumnHeaders,
          rowsTitleBuilder: buildRowTitles(Factions.PeaceRiver, widget.data),
          contentCellBuilder:
              buildCellContent(Factions.PeaceRiver, widget.data),
        );
        return table;
      default:
    }

    return StickyHeadersTable(
        legendCell: Text("No units to display",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 36)),
        columnsLength: 0,
        rowsLength: 0,
        cellDimensions: CellDimensions.uniform(width: 300, height: 40),
        columnsTitleBuilder: (i) => Text(''),
        rowsTitleBuilder: (i) => Text(''),
        contentCellBuilder: (i, j) => Text(''));
  }

  Widget buildColumnHeaders(int i) {
    String text = "";
    TextAlign alignment = TextAlign.center;
    switch (i) {
      case 0:
        text = 'TV';
        break;
      case 1:
        text = 'UA';
        break;
      case 2:
        text = 'MR';
        break;
      case 3:
        text = 'AR';
        break;
      case 4:
        text = 'H/S';
        break;
      case 5:
        text = 'A';
        break;
      case 6:
        text = 'GU';
        break;
      case 7:
        text = 'PI';
        break;
      case 8:
        text = 'EW';
        break;
      case 9:
        text = 'Weapons';
        break;
      case 10:
        text = 'Traits';
        break;
      case 11:
        text = 'Type / Height';
        break;
      case 12:
        text = 'Height';
        break;
    }
    return Text(
      text,
      textAlign: alignment,
    );
  }

  Widget Function(int) buildRowTitles(Factions f, Data data) {
    return (int i) {
      return Text(data.unitList(f)[i].name, textAlign: TextAlign.left);
    };
  }

  Widget Function(int, int) buildCellContent(Factions f, Data data) {
    return (int i, int j) {
      Unit unit = data.unitList(f)[j];
      String text = '';

      switch (i) {
        case 0:
          // TV
          text = unit.tv.toString();
          break;
        case 1:
          // UA
          text = unit.ua.toString();
          break;
        case 2:
          // MR
          text = unit.movement.toString();
          break;
        case 3:
          // AR
          text = unit.armor.toString();
          break;
        case 4:
          // H/S
          text = unit.hull.toString() + '/' + unit.structure.toString();
          break;
        case 5:
          // A(ctions)
          text = unit.actions.toString();
          break;
        case 6:
          // Gu(nnery)
          text = unit.gunnery.toString() + '+';
          break;
        case 7:
          // Pi(loting)
          text = unit.piloting.toString() + '+';
          break;
        case 8:
          // EW
          text = unit.ew.toString() + '+';
          break;
        case 9:
          // Weapons
          text = unit.weapons.toString();
          break;
        case 10:
          // Traits
          text = unit.traits.toString();
          break;
        case 11:
          // Type
          text = unit.type + ' ' + unit.height;
          break;
        case 12:
          // Height
          text = unit.height;
          break;
      }
      return Text(text);
    };
  }
}
