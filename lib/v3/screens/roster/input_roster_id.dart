import 'package:flutter/material.dart';
import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/widgets/api/api_service.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

Future<UnitRoster?> showInputRosterId(BuildContext context, DataV3 data) async {
  final settings = context.read<Settings>();

  var result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const RosterIdInputDialog();
      });

  if (result == null) {
    return null;
  }

  return await ApiService.getV3Roster(data, result, settings);
}

class RosterIdInputDialog extends StatefulWidget {
  const RosterIdInputDialog({super.key});

  @override
  State<RosterIdInputDialog> createState() => _RosterIdInputDialogState();
}

class _RosterIdInputDialogState extends State<RosterIdInputDialog> {
  String input = '';

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
            decoration: const InputDecoration(
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
          child: const Center(
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
