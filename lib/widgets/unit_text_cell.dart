import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gearforce/models/unit/unit.dart';

class UnitTextCell extends StatelessWidget {
  UnitTextCell.content(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 16),
    this.alignment = Alignment.center,
  });

  UnitTextCell.columnTitle(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    this.alignment = Alignment.center,
  });

  final String text;
  final TextAlign textAlignment;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: this.backgroundColor,
            ),
            alignment: this.alignment,
            padding: this.padding,
            child: Text(
              text,
              style: this.textStyle,
              softWrap: true,
              // maxLines: 5,
              textAlign: this.textAlignment,
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildUnitTitleCell(int i) {
  String text = "";
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
  return UnitTextCell.columnTitle(
    text,
    backgroundColor: Colors.blue[100],
  );
}

Widget buildUnitCell(int column, int row, Unit unit) {
  String text = '';

  switch (column) {
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
  return UnitTextCell.content(
    text,
    backgroundColor: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
  );
}
