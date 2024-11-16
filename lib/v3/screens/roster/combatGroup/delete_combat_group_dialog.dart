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
          const Text(
            'Are you sure you want to remove',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            '$cgName?',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, DeleteCGOptionResult.remove);
          },
          child: const Center(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, DeleteCGOptionResult.cancel);
          },
          child: const Center(
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

enum DeleteCGOptionResult { remove, cancel }
