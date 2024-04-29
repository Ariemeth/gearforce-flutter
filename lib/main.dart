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
  }) : super(key: key);

  final Data data;
  final RosterId rosterId;
  final String version;
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
