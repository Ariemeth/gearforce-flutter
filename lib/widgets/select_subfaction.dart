import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class SelectSubFaction extends StatefulWidget {
  const SelectSubFaction({Key? key}) : super(key: key);

  @override
  _SelectSubFactionState createState() => _SelectSubFactionState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectSubFactionState extends State<SelectSubFaction> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Text('Select sub-faction'),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: SizedBox(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['sub 1', 'sub 2', 'sub 3', 'sub 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
