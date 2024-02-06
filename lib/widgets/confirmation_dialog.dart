import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String text;
  final void Function(ConfirmationResult) onOptionSelected;

  const ConfirmationDialog({
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            onOptionSelected(ConfirmationResult.Yes);
            Navigator.pop(context);
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
            onOptionSelected(ConfirmationResult.No);
            Navigator.pop(context);
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
  }
}

enum ConfirmationResult { Yes, No }
