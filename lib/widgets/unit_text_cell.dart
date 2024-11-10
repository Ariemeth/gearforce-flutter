import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UnitTextCell extends StatelessWidget {
  const UnitTextCell.content(
    this.text, {
    super.key,
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 14),
    this.alignment = Alignment.center,
  });

  const UnitTextCell.columnTitle(
    this.text, {
    super.key,
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
              color: backgroundColor,
            ),
            alignment: alignment,
            padding: padding,
            child: Text(
              text,
              style: textStyle,
              softWrap: true,
              // maxLines: 5,
              textAlign: textAlignment,
            ),
          ),
        ),
      ],
    );
  }
}
