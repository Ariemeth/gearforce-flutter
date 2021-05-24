import 'package:gearforce/models/combatGroups/group.dart';

class CombatGroup {
  final Group primary = Group();
  final Group secondary = Group();
  final String name;

  CombatGroup(this.name);

  int totalTV() {
    return primary.totalTV() + secondary.totalTV();
  }

  @override
  String toString() {
    return 'CombatGroup: {Name: $name, PrimaryCG: $primary, SecondaryCG: $secondary}';
  }
}
