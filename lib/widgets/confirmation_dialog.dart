import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String text;
  final void Function(ConfirmationResult) onOptionSelected;

  const ConfirmationDialog({
    super.key,
    required this.text,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            onOptionSelected(ConfirmationResult.yes);
            Navigator.pop(context);
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
            onOptionSelected(ConfirmationResult.no);
            Navigator.pop(context);
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
  }
}

enum ConfirmationResult { yes, no }
