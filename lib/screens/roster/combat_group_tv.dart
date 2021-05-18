import 'package:flutter/material.dart';

class CombatGroupTVTotal extends StatelessWidget {
  CombatGroupTVTotal({Key? key, required this.totalTV}) : super(key: key);

  final int totalTV;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          totalTV.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
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
