import 'package:flutter/material.dart';
import 'package:gearforce/v3/gearforce_v3.dart';
import 'package:gearforce/v4/gearforce_v4.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:gearforce/widgets/version_selector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

const _title = 'Gearforce';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final baseUri = Uri.base;
  final idParam = baseUri.queryParameters['id'];
  final appInfo = await PackageInfo.fromPlatform();

  final Settings settings = Settings();

  final app = MaterialApp(
    title: _title,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        surface: Colors.white,
        primary: Colors.blue,
      ),
    ),
    initialRoute: '/${VersionSelector.defaultSelectedVersion}',
    routes: {
      '/${VersionSelector.v3_1}': (context) => GearForceV3(
            rosterId: RosterId(idParam),
            version: appInfo.version,
            versionSelector: VersionSelector(VersionSelector.v3_1),
            settings: settings,
          ),
      '/${VersionSelector.v4_0}': (context) => GearForceV4(
            rosterId: RosterId(idParam),
            version: appInfo.version,
            versionSelector: VersionSelector(VersionSelector.v4_0),
            settings: settings,
          ),
    },
  );

  runApp(MultiProvider(
    providers: [
      Provider<Settings>(create: (_) => settings),
    ],
    child: app,
  ));
}
