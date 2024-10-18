import 'package:flutter/material.dart';

class DeleteCombatGroupDialog extends StatelessWidget {
  const DeleteCombatGroupDialog({
    super.key,
    required this.cgName,
  });

  final String cgName;

  @override
  Widget build(BuildContext context) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Column(
        children: [
          Text(
            'Are you sure you want to remove',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            '$cgName?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, DeleteCGOptionResult.Remove);
          },
          child: Center(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, DeleteCGOptionResult.Cancel);
          },
          child: Center(
            child: Text(
              'No',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
    return optionsDialog;
  }
}

enum DeleteCGOptionResult { Remove, Cancel }
