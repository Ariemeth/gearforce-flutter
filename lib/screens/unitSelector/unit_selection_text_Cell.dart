import 'package:flutter/material.dart';

class UnitSelectionTextCell extends StatelessWidget {
  UnitSelectionTextCell.content(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
    ),
    this.alignment = Alignment.center,
    this.maxLines,
    this.softWrap = true,
    this.border,
  });

  UnitSelectionTextCell.columnTitle(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    this.alignment = Alignment.center,
    this.maxLines,
    this.softWrap = true,
    this.border,
  });

  UnitSelectionTextCell.draggableFeedback(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none,
    ),
    this.alignment = Alignment.centerLeft,
    this.maxLines=1,
    this.softWrap = true,
    this.border,
  });

    UnitSelectionTextCell.childWhenDragging(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.fromLTRB(0, 3, 3, 3),
    this.textStyle = const TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
    ),
    this.alignment = Alignment.centerLeft,
    this.maxLines =1,
    this.softWrap = true,
    this.border,
  });

  final String text;
  final TextAlign textAlignment;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Alignment alignment;
  final int? maxLines;
  final bool softWrap;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backgroundColor,
        border: this.border,
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
