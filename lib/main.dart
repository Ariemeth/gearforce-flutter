import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/screens/roster/roster.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final baseUri = Uri.base;
  final idParam = baseUri.queryParameters['id'];

  if (idParam != null && idParam.isNotEmpty) {
    print('loading id: $idParam');
  }

  final appInfo = await PackageInfo.fromPlatform();
  final settings = Settings();
  await settings.load();

  var data = Data();
  data.load(settings).whenComplete(() {
    runApp(MultiProvider(
      providers: [
        Provider(create: (_) => data),
        Provider(create: (_) => settings),
      ],
      child: GearForce(
        data: data,
        rosterId: RosterId(idParam),
        version: appInfo.version,
        settings: settings,
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
    required this.settings,
  }) : super(key: key);

  final Data data;
  final RosterId rosterId;
  final String version;
  final Settings settings;
  @override
  _GearForceState createState() => _GearForceState();
}

class _GearForceState extends State<GearForce> {
  _GearForceState();

  @override
  Widget build(BuildContext context) {
    final title = 'Gearforce';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          surface: Colors.white,
          primary: Colors.blue,
        ),
      ),
      home: RosterWidget(
        title: title,
        data: widget.data,
        rosterId: widget.rosterId,
        version: widget.version,
        settings: widget.settings,
      ),
    );
  }
}
