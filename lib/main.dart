import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/screens/roster/roster.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var data = Data();
  data.load().whenComplete(() {
    print(data.factions()?.length);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gear Force',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Roster(title: 'Gear roster creator'),
    );
  }
}
