import 'package:flutter/material.dart';

class UnitSelectionTextCell extends StatelessWidget {
  const UnitSelectionTextCell.content(
    this.text, {
    super.key,
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

  const UnitSelectionTextCell.columnTitle(
    this.text, {
    super.key,
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    this.alignment = Alignment.center,
    this.maxLines,
    this.softWrap = true,
    this.border,
  });

  const UnitSelectionTextCell.draggableFeedback(
    this.text, {
    super.key,
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
    this.maxLines = 1,
    this.softWrap = true,
    this.border,
  });

  const UnitSelectionTextCell.childWhenDragging(
    this.text, {
    super.key,
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.fromLTRB(0, 3, 3, 3),
    this.textStyle = const TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
    ),
    this.alignment = Alignment.centerLeft,
    this.maxLines = 1,
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
        color: backgroundColor,
        border: border,
      ),
      alignment: alignment,
      padding: padding,
      child: Text(
        text,
        overflow: TextOverflow.clip,
        style: textStyle,
        softWrap: softWrap,
        maxLines: maxLines,
        textAlign: textAlignment,
      ),
    );
  }
}
