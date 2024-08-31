import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _maxCGNameLength = 25;
const _minCGNameLength = 1;

class RenameCombatGroupDialog extends StatefulWidget {
  final String currentName;

  RenameCombatGroupDialog({
    super.key,
    required this.currentName,
  });

  @override
  State<RenameCombatGroupDialog> createState() =>
      _RenameCombatGroupDialogState();
}

class _RenameCombatGroupDialogState extends State<RenameCombatGroupDialog> {
  String? newName;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: [
          Text(
            'Renaming',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            widget.currentName,
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a new name for the CG.',
            ),
            onChanged: (String newValue) {
              setState(() {
                newName = newValue;
              });
            },
            onSubmitted: (String newValue) {
              if (newValue.length >= _minCGNameLength) {
                Navigator.pop(
                    context,
                    RenameCGOptionResult(
                      RenameCGOptionResultType.Rename,
                      newName: newValue,
                    ));
              }

              Navigator.pop(
                  context,
                  RenameCGOptionResult(
                    RenameCGOptionResultType.Cancel,
                  ));
            },
            maxLength: _maxCGNameLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 -'_\(\)]"))
            ],
            autofocus: true,
          ),
        ),
        Row(
          children: [
            SimpleDialogOption(
              onPressed: newName != null && newName!.length >= _minCGNameLength
                  ? () {
                      Navigator.pop(
                          context,
                          RenameCGOptionResult(
                            RenameCGOptionResultType.Rename,
                            newName: newName,
                          ));
                    }
                  : null,
              child: Center(
                child: Text(
                  'Rename',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                    decoration:
                        newName != null && newName!.length >= _minCGNameLength
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(
                    context,
                    RenameCGOptionResult(
                      RenameCGOptionResultType.Cancel,
                    ));
              },
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RenameCGOptionResult {
  const RenameCGOptionResult(this.resultType, {this.newName});

  final String? newName;
  final RenameCGOptionResultType resultType;
}

enum RenameCGOptionResultType { Rename, Cancel }
