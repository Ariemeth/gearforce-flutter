import 'package:flutter/material.dart';
import 'package:gearforce/v3/screens/unitSelector/unit_selector_text_cell.dart';

class SelectedUnitModelCell extends StatelessWidget {
  const SelectedUnitModelCell({
    super.key,
    required this.text,
    this.hasBorder = false,
    this.borderSize = 0,
  }) : assert(borderSize <= 5);

  final String text;
  final bool hasBorder;
  final double borderSize;

  @override
  Widget build(BuildContext context) {
    return UnitSelectorTextCell.content(
      text,
      maxLines: 1,
      alignment: Alignment.centerLeft,
      padding: hasBorder
          ? EdgeInsets.fromLTRB(5, 5 - borderSize, 5, 5 - borderSize)
          : const EdgeInsets.all(5),
    );
  }
}
