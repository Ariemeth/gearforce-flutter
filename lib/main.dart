import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/screens/roster/roster.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var data = Data();
  data.load().whenComplete(() {
    runApp(
      Provider(
        create: (_) => data,
        child: GearForce(),
      ),
    );
  });
}

class GearForce extends StatefulWidget {
  const GearForce({Key? key}) : super(key: key);

  @override
  _GearForceState createState() => _GearForceState();
}

class _GearForceState extends State<GearForce> {
  _GearForceState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gear Force',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RosterWidget(
        title: 'Gear roster creator',
      ),
      
    );
  }
}
