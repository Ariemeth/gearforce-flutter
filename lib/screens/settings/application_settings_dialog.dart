import 'package:flutter/material.dart';
import 'package:gearforce/screens/settings/settings_checkbox_option_line.dart';
import 'package:gearforce/screens/settings/settings_value_option_line.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

import 'settings_section_heading.dart';

class ApplicationSettingsDialog extends StatefulWidget {
  const ApplicationSettingsDialog({super.key});

  @override
  State<ApplicationSettingsDialog> createState() =>
      _ApplicationSettingsDialogState();
}

class _ApplicationSettingsDialogState extends State<ApplicationSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();

    return SimpleDialog(
      title: Stack(children: [
        Align(
          child: Text(
            'Settings',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        IconButton(
          onPressed: () => {
            setState(() {
              settings.reset();
            })
          },
          icon: const Icon(
            Icons.refresh,
            color: Colors.green,
          ),
          splashRadius: 20.0,
          padding: const EdgeInsets.only(),
          tooltip: 'Reset to default settings',
        ),
      ]),
      children: [
        SettingsSectionHeading('Application Settings'),
        SettingsValueOptionLine(
            text: 'Tooltip Delay in milliseconds',
            value: settings.tooltipDelay.inMilliseconds,
            onChanged: (int? newValue) {
              setState(() {
                if (newValue != null) {
                  settings.tooltipDelay = Duration(milliseconds: newValue);
                }
              });
            }),
        SettingsSectionHeading('Content Settings'),
        SettingsCheckboxOptionLine(
          // TODO: Enable when ready
          isEnabled: false,
          tooltipMessage: 'Coming soon!',
          text: 'Allow Alpha/Beta Content',
          value: settings.isAlphaBetaAllowed,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                settings.isAlphaBetaAllowed = newValue;
              }
            });
          },
        ),
        SettingsCheckboxOptionLine(
          // TODO: Enable when ready
          isEnabled: false,
          tooltipMessage: 'Coming soon!',
          text: 'Allow Extended Content',
          value: settings.isExtendedContentAllowed,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                settings.isExtendedContentAllowed = newValue;
              }
            });
          },
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Text(
              'Close',
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
