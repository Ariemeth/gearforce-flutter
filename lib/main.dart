import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/screens/roster/roster.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //final myUrl = Uri.base.toString();

  final idParam = Uri.base.queryParameters['id'];

  if (idParam != null && idParam.isNotEmpty) {
    print('loading id: $idParam');
  }

  var data = Data();
  data.load().whenComplete(() {
    runApp(MultiProvider(
      providers: [
        Provider(create: (_) => data),
        Provider(create: (_) => Settings()),
      ],
      child: GearForce(data: data, rosterId: RosterId(idParam)),
    ));
  });
}

class GearForce extends StatefulWidget {
  const GearForce({
    Key? key,
    required this.data,
    required this.rosterId,
  }) : super(key: key);

  final Data data;
  final RosterId rosterId;
  @override
  _GearForceState createState() => _GearForceState();
}

class _GearForceState extends State<GearForce> {
  _GearForceState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gearforce',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          background: Colors.white,
          primary: Colors.blue,
        ),
      ),
      home: RosterWidget(
        title: 'Gearforce',
        data: widget.data,
        rosterId: widget.rosterId,
      ),
    );
  }
}
