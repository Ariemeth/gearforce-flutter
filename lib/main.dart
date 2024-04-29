import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/screens/roster/roster.dart';
import 'package:gearforce/widgets/api/api_service.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final baseUri = Uri.base;
  final idParam = baseUri.queryParameters['id'];

  if (idParam != null && idParam.isNotEmpty) {
    print('loading id: $idParam');
  }

  final appInfo = await PackageInfo.fromPlatform();
  final latestVersionStr = await ApiService.getLatestVersion(baseUri);
  final latestVersion =
      latestVersionStr != null ? Version.parse(latestVersionStr) : null;

  final currentVersion = Version.parse(appInfo.version);

  var data = Data();
  data.load().whenComplete(() {
    runApp(MultiProvider(
      providers: [
        Provider(create: (_) => data),
        Provider(create: (_) => Settings()),
      ],
      child: GearForce(
        data: data,
        rosterId: RosterId(idParam),
        version: appInfo.version,
        latestVersion: latestVersion,
        currentVersion: currentVersion,
      ),
    ));
  });
}

class GearForce extends StatefulWidget {
  const GearForce({
    Key? key,
    required this.data,
    required this.rosterId,
    required this.version,
    required this.latestVersion,
    required this.currentVersion,
  }) : super(key: key);

  final Data data;
  final RosterId rosterId;
  final String version;
  final Version? latestVersion;
  final Version currentVersion;
  @override
  _GearForceState createState() => _GearForceState();
}

class _GearForceState extends State<GearForce> {
  _GearForceState();

  @override
  Widget build(BuildContext context) {
    final isOutdated = widget.latestVersion != null &&
        widget.currentVersion < widget.latestVersion!;

    var baseTitle = 'Gearforce';
    final title = isOutdated ? '$baseTitle (Outdated)' : baseTitle;
    // final title = baseTitle;

    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          background: Colors.white,
          primary: Colors.blue,
        ),
      ),
      home: RosterWidget(
        title: title,
        data: widget.data,
        rosterId: widget.rosterId,
        version: widget.version,
      ),
    );
  }
}
