import 'package:flutter/widgets.dart';

class CGTextCell extends StatelessWidget {
  const CGTextCell(
    this.text, {
    this.textAlignment = TextAlign.center,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(5),
  });

  final String text;
  final TextAlign textAlignment;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          this.text,
          textAlign: this.textAlignment,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
