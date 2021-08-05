import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:uuid/uuid.dart';

abstract class BaseModification {
  BaseModification({required this.name, String? id}) {
    _id = id ?? Uuid().v4();
  }

  final String name;
  final List<String> _description = [];
  late final String _id;
  String get id => _id;

  List<String> get description => this._description.toList();

  final Map<UnitAttribute, dynamic Function(dynamic)> _mods = Map();

  void addMod(UnitAttribute att, dynamic Function(dynamic) mod,
      {String? description}) {
    this._mods[att] = mod;
    if (description != null) {
      this._description.add(description);
    }
  }

  dynamic applyMods(UnitAttribute att, dynamic startingValue) {
    var mod = this._mods[att];
    if (mod != null) {
      return mod(startingValue);
    }

    return startingValue;
  }
}
