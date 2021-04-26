import 'package:flutter/widgets.dart';

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
