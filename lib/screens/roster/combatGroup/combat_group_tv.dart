import 'package:flutter/material.dart';

class CombatGroupTVTotal extends StatelessWidget {
  CombatGroupTVTotal(
      {Key? key, required this.totalTV, this.textColor = Colors.black})
      : super(key: key);

  final int totalTV;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        totalTV.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: this.textColor),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border(
          top: BorderSide(color: const Color.fromARGB(255, 158, 158, 158)),
          bottom: BorderSide(color: const Color.fromARGB(255, 158, 158, 158)),
          right: BorderSide(color: const Color.fromARGB(255, 158, 158, 158)),
          left: BorderSide(color: const Color.fromARGB(255, 158, 158, 158)),
        ),
      ),
    );
  }
}
