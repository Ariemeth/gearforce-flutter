import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction.dart';

class CombatGroup extends ChangeNotifier {
  late final Group primary;
  late final Group secondary;
  final String name;

  CombatGroup(this.name, {Group? primary, Group? secondary}) {
    this.primary = primary == null ? Group() : primary;
    this.secondary = secondary == null ? Group() : secondary;

    this.primary.addListener(() {
      notifyListeners();
    });
    this.secondary.addListener(() {
      notifyListeners();
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary.toJson(),
      'secondary': secondary.toJson(),
      'name': '$name',
    };
  }

  factory CombatGroup.fromJson(
      dynamic json, Data data, Factions? faction, String? subfaction) {
    //TODO remove prints
    print('CombatGroup.fromJson');
    print(json);
    var cg = CombatGroup(
      json['name'] as String,
      primary:
          Group.fromJson(json['groups']['primary'], data, faction, subfaction),
      secondary: Group.fromJson(
          json['groups']['secondary'], data, faction, subfaction),
    );
    return cg;
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
