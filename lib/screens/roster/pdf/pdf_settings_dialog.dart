import 'package:flutter/material.dart';
import 'package:gearforce/widgets/pdf_settings.dart';

class PDFSettingsDialog extends StatelessWidget {
  final String type;

  const PDFSettingsDialog(this.type, {super.key});
  @override
  Widget build(BuildContext context) {
    PDFSettings settings = PDFSettings();

    return SimpleDialog(
      title: Align(
        child: Text('$type Settings', style: TextStyle(fontSize: 24)),
      ),
      children: [
        Text('Select the sections to include',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )),
        SettingsOptionLine(
            text: 'Record Sheet',
            onChanged: (bool? newValue) {
              settings.sections.recordSheet = newValue!;
            }),
        SettingsOptionLine(
            text: 'Unit Cards',
            onChanged: (bool? newValue) {
              settings.sections.unitCards = newValue!;
            }),
        SettingsOptionLine(
            text: 'Traits',
            onChanged: (bool? newValue) {
              settings.sections.traitReference = newValue!;
            }),
        SettingsOptionLine(
            text: 'Faction Rules',
            onChanged: (bool? newValue) {
              settings.sections.factionRules = newValue!;
            }),
        SettingsOptionLine(
            text: 'Sub-Faction Rules',
            onChanged: (bool? newValue) {
              settings.sections.subFactionRules = newValue!;
            }),
        SettingsOptionLine(
            text: 'Alpha/Beta Rules',
            onChanged: (bool? newValue) {
              settings.sections.alphaBetaRules = newValue!;
            }),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, settings);
          },
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
        ),
      ],
      contentPadding: EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
      titlePadding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
    );
  }
}

class SettingsOptionLine extends StatefulWidget {
  final String text;
  final ValueChanged<bool?> onChanged;

  SettingsOptionLine({
    required this.text,
    required this.onChanged,
  });

  @override
  State<SettingsOptionLine> createState() => _SettingsOptionLineState();
}

class _SettingsOptionLineState extends State<SettingsOptionLine> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.text),
        Spacer(),
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            setState(() {
              value = newValue!;
            });
            widget.onChanged(newValue);
          },
        ),
      ],
    );
  }
}
