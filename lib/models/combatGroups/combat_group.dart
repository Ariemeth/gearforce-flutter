import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/sub_faction.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/validation/validations.dart';

class CombatGroup extends ChangeNotifier {
  Group _primary = Group(GroupType.Primary);
  Group _secondary = Group(GroupType.Secondary);
  final String name;
  bool _isVeteran = false;
  UnitRoster? roster;
  List<CombatGroupOption> _options = [];

  /// Retrieve the options associated with this [CombatGroup].
  List<CombatGroupOption> get options => _options.toList();
  bool hasOption(String id) => _options.any((o) => o.id == id);
  bool isOptionEnabled(String id) {
    return _options.any((o) => o.id == id) &&
        _options.firstWhere((o) => o.id == id).isEnabled;
  }

  /// Retrieve a list of all units in this [CombatGroup].
  List<Unit> get units => _primary.allUnits()..addAll(_secondary.allUnits());

  bool unitHasTag(String tag) =>
      _primary.unitHasTag(tag) || _secondary.unitHasTag(tag);

  Group get primary => _primary;
  set primary(Group group) {
    if (_primary.hasListeners) {
      _primary.removeListener(() {
        notifyListeners();
      });
    }
    _primary.combatGroup = null;

    group.combatGroup = this;
    group.addListener(() {
      notifyListeners();
    });
    _primary = group;
  }

  Group get secondary => _secondary;
  set secondary(Group group) {
    if (_secondary.hasListeners) {
      _secondary.removeListener(() {
        notifyListeners();
      });
    }
    _secondary.combatGroup = null;

    group.combatGroup = this;
    group.addListener(() {
      notifyListeners();
    });
    _secondary = group;
  }

  bool get isVeteran => _isVeteran || isEliteForce;
  set isVeteran(bool value) {
    if (value == _isVeteran) {
      return;
    }
    if (value) {
      if ((roster != null && roster!.getCGs().any((cg) => cg._isVeteran))) {
        return;
      }
    }
    _isVeteran = value;
    if (!value) {
      _primary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
      _secondary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
    }
    notifyListeners();
  }

  bool get isEliteForce => roster != null && roster!.isEliteForce;
  set isEliteForce(bool newValue) {
    if (!newValue && !_isVeteran) {
      _primary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
      _secondary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
    }
  }

  CombatGroup(this.name, {Group? primary, Group? secondary, this.roster}) {
    this.primary = primary == null ? Group(GroupType.Primary) : primary;
    this.secondary = secondary == null ? Group(GroupType.Secondary) : secondary;
    _resetOptions();
  }

  Map<String, dynamic> toJson() => {
        'primary': _primary.toJson(),
        'secondary': _secondary.toJson(),
        'name': '$name',
        'isVet': _isVeteran,
        'enabledOptions':
            _options.where((o) => o.isEnabled).map((o) => o.id).toList(),
      };

  factory CombatGroup.fromJson(
    dynamic json,
    Data data,
    Faction faction,
    SubFaction subfaction,
    UnitRoster roster,
  ) {
    final cg = CombatGroup(
      json['name'] as String,
      roster: roster,
    ).._isVeteran = json['isVet'] != null ? json['isVet'] as bool : false;

    final p = Group.fromJson(
        json['primary'], faction, subfaction, cg, roster, GroupType.Primary);
    final s = Group.fromJson(json['secondary'], faction, subfaction, cg, roster,
        GroupType.Secondary);
    cg.primary = p;
    cg.secondary = s;

    final enabledOptions = json['enabledOptions'] as List;
    enabledOptions.forEach((optionId) {
      cg._options
          .where((oo) => oo.id == optionId)
          .forEach((o) => o.isEnabled = true);
    });

    return cg;
  }

  int totalTV() {
    return _primary.totalTV() + _secondary.totalTV();
  }

  bool hasDuelist() {
    return this._primary.hasDuelist() || this._secondary.hasDuelist();
  }

  int modCount(String id) {
    return _primary.modCount(id) + _secondary.modCount(id);
  }

  Unit? getUnitWithCommand(CommandLevel cl) {
    return _primary.getUnitWithCommand(cl) ?? _secondary.getUnitWithCommand(cl);
  }

  List<Unit> unitsWithMod(String id) {
    return _primary.unitsWithMod(id).toList()
      ..addAll(_secondary.unitsWithMod(id).toList());
  }

  int numUnitsWithMod(String id) {
    return _primary.unitsWithMod(id).length +
        _secondary.unitsWithMod(id).length;
  }

  int numberUnitsWithTag(String tag) {
    return unitsWithTag(tag).length;
  }

  List<Unit> unitsWithTag(String tag) {
    return primary.unitsWithTag(tag)..addAll(secondary.unitsWithTag(tag));
  }

  // Retrieve the total number of units in the combat group
  int numberOfUnits() {
    return _primary.numberOfUnits() + _secondary.numberOfUnits();
  }

  List<Validation> validate({bool tryFix = false}) {
    final List<Validation> validationErrors = [];

    final options = roster?.subFaction.value.ruleSet.combatGroupSettings();
    if (options != null) {
      // if the new options and current _options are the same size and both contain all the same ids, it is good to go
      if (!(options.every((o) => _options.any((oe) => oe.id == o.id)) &&
          options.length == _options.length)) {
        // Options are not the same

        // remove any options from _options that are not in the updated options
        _options.removeWhere((o) => !options.any((uo) => uo.id == o.id));

        //add any new options
        _options.addAll(
            options.where((ou) => !_options.any((oe) => oe.id == ou.id)));
      }
    } else {
      _options.clear();
    }

    final pve = primary.validate(tryFix: tryFix);
    if (pve.isNotEmpty) {
      validationErrors.addAll(pve);
    }
    final sve = secondary.validate(tryFix: tryFix);
    if (sve.isNotEmpty) {
      validationErrors.addAll(pve);
    }

    return validationErrors;
  }

  void _resetOptions() {
    _options.clear();
    final settings = roster?.subFaction.value.ruleSet.combatGroupSettings();
    if (settings != null) {
      _options = settings;
    }
  }

  void clear() {
    _primary.reset();
    _secondary.reset();
    _isVeteran = false;
    _resetOptions();
  }

  @override
  String toString() {
    return 'CombatGroup: {Name: $name, PrimaryCG: $_primary, SecondaryCG: $_secondary}';
  }
}
