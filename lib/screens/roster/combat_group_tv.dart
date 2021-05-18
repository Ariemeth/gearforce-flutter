import 'package:flutter/material.dart';

class CombatGroupTVTotal extends StatefulWidget {
  CombatGroupTVTotal({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<int> _totalTV = ValueNotifier<int>(102);

  updateTotal(int newValue) => this._totalTV.value = newValue;

  @override
  _CombatGroupTVTotalState createState() => _CombatGroupTVTotalState();
}

class _CombatGroupTVTotalState extends State<CombatGroupTVTotal> {
  @override
  Widget build(BuildContext context) {
    widget._totalTV.addListener(() {
      setState(() {});
    });
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          widget._totalTV.value.toString(),
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
