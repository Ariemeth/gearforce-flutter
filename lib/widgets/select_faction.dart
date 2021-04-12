import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is the stateful widget that the main application instantiates.
class SelectFaction extends StatefulWidget {
  const SelectFaction({Key? key}) : super(key: key);

  @override
  _SelectFactionState createState() => _SelectFactionState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectFactionState extends State<SelectFaction> {
  String? dropdownValue;

  List<String> factions = [];
  Future<String>? futureFactions;

  final String factionFile = 'data/factions.json';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: this.futureFactions,
        builder: (context, snapshot) {
          return DropdownButton<String>(
            value: dropdownValue,
            hint: Text('Select faction'),
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
            items: this.factions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.loadFactions();
  }

  Future<List<String>> loadFactions() async {
    var jsonData = await rootBundle.loadString(this.factionFile);
    var decodedData = json.decode(jsonData);
    List<String> factions = decodedData != null ? List.from(decodedData) : [''];
    setState(() {
      this.factions = factions;
    });
    return factions;
  }
}
