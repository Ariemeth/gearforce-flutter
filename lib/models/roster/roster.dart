import 'package:flutter/foundation.dart';

class Roster {
  String? player;
  String? name;
  final faction = ValueNotifier<String>("");
  final subFaction = ValueNotifier<String>("");
}
