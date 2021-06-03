import 'package:flutter/cupertino.dart';
import 'package:gearforce/models/combatGroups/group.dart';

class CombatGroup extends ChangeNotifier {
  final Group primary = Group();
  final Group secondary = Group();
  final String name;

  CombatGroup(this.name) {
    primary.addListener(() {
      notifyListeners();
    });
    secondary.addListener(() {
      notifyListeners();
    });
  }

  int totalTV() {
    return primary.totalTV() + secondary.totalTV();
  }

  bool hasDuelist() {
    return this.primary.hasDuelist() || this.secondary.hasDuelist();
  }

  void clear() {
    this.primary.reset();
    this.secondary.reset();
  }

  @override
  String toString() {
    return 'CombatGroup: {Name: $name, PrimaryCG: $primary, SecondaryCG: $secondary}';
  }
}
