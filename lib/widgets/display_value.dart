import 'package:flutter/material.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_group_tv.dart';

class DisplayValue extends StatelessWidget {
  const DisplayValue({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    required this.value,
  }) : super(key: key);

  final int value;
  final Color textColor;
  final String text;

  final double _widgetHeight = 35.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _widgetHeight,
      child: Align(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2, left: 5, top: 5, bottom: 5),
              child: Text(
                text,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 50,
              height: _widgetHeight,
              child: Padding(
                padding: EdgeInsets.only(right: 5, left: 2, top: 5, bottom: 5),
                child: CombatGroupTVTotal(
                  totalTV: value,
                  textColor: textColor,
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
