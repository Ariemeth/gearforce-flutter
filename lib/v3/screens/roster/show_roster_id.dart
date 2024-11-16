import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/widgets/api/api_service.dart';

Future showRosterIdDialog(BuildContext context, UnitRoster roster) async {
  final results = await ApiService.saveV3Roster(roster);

  await showDialog<String>(
      context: context.mounted ? context : context,
      builder: (BuildContext context) {
        if (results.$1 == null) {
          return UnableToSaveRosterDialog(
            reason: results.$2,
          );
        }

        return RosterIdDialog(
          rosterId: results.$1!,
        );
      });
}

class RosterIdDialog extends StatelessWidget {
  final String rosterId;

  const RosterIdDialog({super.key, required this.rosterId});

  @override
  Widget build(BuildContext context) {
    final link = 'https://gearforce.app/?id=$rosterId';
    return SimpleDialog(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: rosterId),
                );
              },
              icon: const Icon(
                Icons.copy_all_outlined,
                color: Colors.green,
              ),
              tooltip: 'Copy to the clipboard',
            ),
            SelectableText(rosterId),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: link),
                );
              },
              icon: const Icon(
                Icons.copy_all_outlined,
                color: Colors.green,
              ),
              tooltip: 'Copy to the clipboard',
            ),
            SelectableText(link),
          ],
        ),
      ],
    );
  }
}

class UnableToSaveRosterDialog extends StatelessWidget {
  final String? reason;

  const UnableToSaveRosterDialog({super.key, required this.reason});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: Text('Unable to save roster to the online database'),
              ),
              Center(
                child: Text('Reason: ${reason ?? 'unknown'}'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
