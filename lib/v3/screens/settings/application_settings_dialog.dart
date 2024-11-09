import 'package:flutter/material.dart';
import 'package:gearforce/v3/screens/settings/settings_checkbox_option_line.dart';
import 'package:gearforce/v3/screens/settings/settings_value_option_line.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            AppLocalizations.of(context)!.menuSettingsTitle,
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
        SettingsCheckboxOptionLine(
          text: 'Require confirm for unit removal',
          value: settings.requireConfirmationToDeleteUnit,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                settings.requireConfirmationToDeleteUnit = newValue;
              }
            });
          },
        ),
        SettingsCheckboxOptionLine(
          text: 'Require confirm for combat group removal',
          value: settings.requireConfirmationToDeleteCG,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                settings.requireConfirmationToDeleteCG = newValue;
              }
            });
          },
        ),
        SettingsCheckboxOptionLine(
          text: 'Require confirm for roster reset',
          value: settings.requireConfirmationToResetRoster,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                settings.requireConfirmationToResetRoster = newValue;
              }
            });
          },
        ),
        SettingsSectionHeading('Content Settings'),
        SettingsCheckboxOptionLine(
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
          text: 'Allow Custom Points',
          value: settings.allowCustomPoints,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue != null) {
                settings.allowCustomPoints = newValue;
              }
            });
          },
          tooltipMessage: 'Allows adding a custom tv modifier upgrade to units',
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
