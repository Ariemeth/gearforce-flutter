import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/screens/roster/roster.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var data = Data();
  data.load().whenComplete(() {
    runApp(GearForce(
      data: data,
    ));
  });
}

class GearForce extends StatefulWidget {
  final Data data;

  const GearForce({Key? key, required this.data}) : super(key: key);

  @override
  _GearForceState createState() => _GearForceState(data);
}

class _GearForceState extends State<GearForce> {
  final Data dataBundle;

  _GearForceState(this.dataBundle);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gear Force',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RosterWidget(
        title: 'Gear roster creator',
        data: this.dataBundle,
      ),
    );
  }
}
