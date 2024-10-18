import 'package:flutter/material.dart';
import 'package:gearforce/v3/screens/unitSelector/unit_selection_text_Cell.dart';

class SelectedUnitModelCell extends StatelessWidget {
  const SelectedUnitModelCell({
    Key? key,
    required this.text,
    this.hasBorder = false,
    this.borderSize = 0,
  })  : assert(borderSize <= 5),
        super(key: key);

  final String text;
  final bool hasBorder;
  final double borderSize;

  @override
  Widget build(BuildContext context) {
    return UnitSelectionTextCell.content(
      this.text,
      maxLines: 1,
      alignment: Alignment.centerLeft,
      padding: this.hasBorder
          ? EdgeInsets.fromLTRB(5, 5 - this.borderSize, 5, 5 - this.borderSize)
          : const EdgeInsets.all(5),
    );
  }
}
