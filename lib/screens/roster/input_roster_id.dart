import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/widgets/api/api_service.dart';

Future<UnitRoster?> showInputRosterId(BuildContext context, Data data) async {
  var result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return RosterIdInputDialog();
      });

  if (result == null) {
    return null;
  }

  return await ApiService.getRoster(data, result);
}

class RosterIdInputDialog extends StatefulWidget {
  @override
  State<RosterIdInputDialog> createState() => _RosterIdInputDialogState();
}

class _RosterIdInputDialogState extends State<RosterIdInputDialog> {
  String input = "";

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: TextField(
            autofocus: true,
            autocorrect: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              constraints: BoxConstraints(minWidth: 320.0),
              border: OutlineInputBorder(),
              hintText: 'Enter an ID to load',
              contentPadding: EdgeInsets.symmetric(
                vertical: 2.5,
                horizontal: 4.0,
              ),
            ),
            onChanged: (value) {
              input = value;
            },
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, input);
          },
          child: Center(
            child: Text(
              'Load Roster',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        )
      ],
    );
  }
}
