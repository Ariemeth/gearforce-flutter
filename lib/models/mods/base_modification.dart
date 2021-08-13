import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:uuid/uuid.dart';

abstract class BaseModification {
  BaseModification({
    required this.name,
    String? id,
    this.options,
  }) {
    _id = id ?? Uuid().v4();
  }

  final String name;
  final List<String> _description = [];
  late final String _id;
  String get id => _id;
  final List<ModificationOption>? options;
  bool get hasOptions => this.options != null && this.options!.isNotEmpty;

  List<String> get description => this._description.toList();

  final Map<UnitAttribute, List<dynamic Function(dynamic)>> _mods = Map();

  void addMod(UnitAttribute att, dynamic Function(dynamic) mod,
      {String? description}) {
    if (this._mods[att] == null) {
      this._mods[att] = [];
    }
    this._mods[att]!.add(mod);
    if (description != null) {
      this._description.add(description);
    }
  }

  dynamic applyMods(UnitAttribute att, dynamic startingValue) {
    var mods = this._mods[att];
    if (mods == null) {
      return startingValue;
    }
    dynamic result = startingValue;
    mods.forEach((element) {
      result = element(result);
    });

    return result;
  }
}
