import 'package:flutter/material.dart';

class UnitSelectionTextCell extends StatelessWidget {
  UnitSelectionTextCell.content(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 14),
    this.alignment = Alignment.center,
    this.maxLines,
    this.softWrap = true,
  });

  UnitSelectionTextCell.columnTitle(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    this.alignment = Alignment.center,
    this.maxLines,
    this.softWrap = true,
  });

  final String text;
  final TextAlign textAlignment;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Alignment alignment;
  final int? maxLines;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backgroundColor,
      ),
      alignment: this.alignment,
      padding: this.padding,
      child: Text(
        text,
        overflow: TextOverflow.clip,
        style: this.textStyle,
        softWrap: this.softWrap,
        maxLines: this.maxLines,
        textAlign: this.textAlignment,
      ),
    );
  }
}
