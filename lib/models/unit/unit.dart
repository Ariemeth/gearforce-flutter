import 'package:flutter/widgets.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/sub_faction.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_upgrades.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_upgrades.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_upgrades.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/models/weapons/weapon.dart';

class Unit extends ChangeNotifier {
  Unit({
    required this.core,
  });

  Map<String, dynamic> toJson() {
    Map<String, List<dynamic>> mods = {};
    _mods.forEach((mod) {
      if (mod is UnitModification) {
        if (mods['unit'] == null) {
          mods['unit'] = [];
        }
        mods['unit']!.add(mod.toJson());
      } else if (mod is StandardModification) {
        if (mods['standard'] == null) {
          mods['standard'] = [];
        }
        mods['standard']!.add(mod.toJson());
      } else if (mod is VeteranModification) {
        if (mods['vet'] == null) {
          mods['vet'] = [];
        }
        mods['vet']!.add(mod.toJson());
      } else if (mod is DuelistModification) {
        if (mods['duelist'] == null) {
          mods['duelist'] = [];
        }
        mods['duelist']!.add(mod.toJson());
      } else if (mod is FactionModification) {
        if (mods['faction'] == null) {
          mods['faction'] = [];
        }
        mods['faction']!.add(mod.toJson());
      }
    });

    return {
      'frame': core.frame,
      'variant': core.name,
      'mods': mods,
      'command': commandLevelString(_commandLevel)
    };
  }

  factory Unit.fromJson(
    dynamic json,
    //  Data data,
    Faction faction,
    SubFaction subfaction,
    CombatGroup? cg,
    UnitRoster roster,
  ) {
    final core = subfaction.ruleSet.availableUnits()
      ..addAll(subfaction.ruleSet.airstrikeCounters());

    Unit u = Unit(
        core: core.firstWhere((element) => element.name == json['variant']));

    u._commandLevel = convertToCommand(json['command']);

    Map<BaseModification, Map<String, dynamic>> modsWithOptions = {};

    final modMap = json['mods'] as Map;
    if (modMap['unit'] != null) {
      final mods = modMap['unit'] as List;
      var availableUnitMods = getUnitMods(u.core.frame, u);
      mods.forEach((loadedMod) {
        try {
          var mod = availableUnitMods
              .firstWhere((unitMod) => unitMod.name == loadedMod['id']);
          u.addUnitMod(mod);
          final selected = loadedMod['selected'];
          if (selected != null) {
            modsWithOptions[mod] = selected;
          }
        } catch (e) {
          print('unit mod $loadedMod not found in available mods, $e');
        }
      });
    }
    if (modMap['standard'] != null && cg != null) {
      final mods = modMap['standard'] as List;

      mods.forEach((loadedMod) {
        try {
          final modId = loadedMod['id'];
          var mod = buildStandardUpgrade(modId, u, cg, roster);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Standard mod $modId not found');
          }
        } catch (e) {
          print('standard mod $loadedMod not found in available mods, $e');
        }
      });
    }
    if (modMap['vet'] != null && cg != null) {
      final mods = modMap['vet'] as List;

      mods.forEach((loadedMod) {
        try {
          final modId = loadedMod['id'];
          var mod = buildVetUpgrade(modId, u, cg);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Vet mod $modId not found');
          }
        } catch (e) {
          print('vet mod $loadedMod not found in available mods, $e');
        }
      });
    }
    if (modMap['duelist'] != null && cg != null) {
      final mods = modMap['duelist'] as List;

      mods.forEach((loadedMod) {
        try {
          final modId = loadedMod['id'];
          var mod = buildDuelistUpgrade(modId, u, cg, roster);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Duelist mod $modId not found');
          }
        } catch (e) {
          print('duelist mod $loadedMod not found in available mods, $e');
        }
      });
    }

    if (modMap['faction'] != null && cg != null) {
      final mods = modMap['faction'] as List;

      mods.forEach((loadedMod) {
        final modId = loadedMod['id'];

        var mod = factionModFromId(modId, roster, u);
        if (mod == null) {
          print('faction mod $modId could not be loaded');
          return;
        }
        u.addUnitMod(mod);
        final selected = loadedMod['selected'];
        if (selected != null) {
          modsWithOptions[mod] = selected;
        }
      });
    }

    var loadAttempts = 0;
    while (modsWithOptions.isNotEmpty && loadAttempts < 5) {
      modsWithOptions = _loadOptionsFromJSON(modsWithOptions,
          refreshOptions: loadAttempts != 0);
      loadAttempts++;
    }

    return u;
  }

  final UnitCore core;
  final List<BaseModification> _mods = [];
  List<String> get modNames => _mods.map((m) => m.name).toList();
  List<String> get modNamesWithCost => _mods
      .map((m) => '${m.name}(${m.applyMods(UnitAttribute.tv, 0)})')
      .toList();
  CommandLevel _commandLevel = CommandLevel.none;
  List<String> _special = [];

  CommandLevel get commandLevel => _commandLevel;
  set commandLevel(CommandLevel cl) {
    _commandLevel = cl;
    notifyListeners();
  }

  bool get isDuelist {
    return this.traits.any((element) => element.name == 'Duelist');
  }

  bool isVeteran() {
    return this.traits.any((element) => element.name == 'Vet');
  }

  String get name {
    var value = this.core.name;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.name, value);
    }

    return value;
  }

  int get tv {
    var value = this.core.tv;
    value = value + commandTVCost(this._commandLevel);

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.tv, value);
    }

    return value;
  }

  Roles? get role {
    var value = this.core.role;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.roles, value);
    }

    return value;
  }

  Movement? get movement {
    var value = this.core.movement;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.movement, value);
    }

    return value;
  }

  int? get armor {
    var value = this.core.armor;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.armor, value);
    }
    return value;
  }

  int? get actions {
    var value = this.core.actions;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.actions, value);
    }
    return value;
  }

  int? get gunnery {
    var value = this.core.gunnery;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.gunnery, value);
    }
    return value;
  }

  int? get piloting {
    var value = this.core.piloting;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.piloting, value);
    }
    return value;
  }

  int? get ew {
    var value = this.core.ew;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.ew, value);
    }
    return value;
  }

  int? get hull {
    var value = this.core.hull;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.hull, value);
    }
    return value;
  }

  int? get structure {
    var value = this.core.structure;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.structure, value);
    }
    return value;
  }

  List<Weapon> get weapons {
    return reactWeapons..addAll(mountedWeapons);
  }

  List<Weapon> get reactWeapons {
    var newList = this
        .core
        .reactWeapons
        .map((weapon) => Weapon.fromWeapon(weapon))
        .toList();

    for (var mod in this._mods) {
      newList = mod.applyMods(UnitAttribute.react_weapons, newList);
    }

    return newList;
  }

  List<Weapon> get mountedWeapons {
    var newList = this
        .core
        .mountedWeapons
        .map((weapon) => Weapon.fromWeapon(weapon))
        .toList();

    for (var mod in this._mods) {
      newList = mod.applyMods(UnitAttribute.mounted_weapons, newList);
    }

    return newList;
  }

  List<Trait> get traits {
    var newList =
        this.core.traits.map((trait) => Trait.fromTrait(trait)).toList();

    for (var mod in this._mods) {
      newList = mod.applyMods(UnitAttribute.traits, newList);
    }

    return newList;
  }

  ModelType get type {
    var value = this.core.type;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.type, value);
    }

    return value;
  }

  String get height {
    return this.core.height;
  }

  List<String> get special {
    var value = this._special.toList();
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.special, value);
    }
    return value;
  }

  T attribute<T>(
    UnitAttribute att, {
    String? modIDToSkip,
  }) {
    assert(T == att.expected_type, 'Expected [${att.expected_type}], got [$T]');

    var value = this.core.attribute(att) as T;

    for (var mod in this
        ._mods
        .where((m) => modIDToSkip == null ? true : m.id != modIDToSkip)) {
      value = mod.applyMods(att, value);
    }

    return value;
  }

  void addUnitMod(BaseModification mod) {
    _mods.add(mod);
    _mods.forEach((m) {
      final updatedMod = m.refreshData();
      updatedMod.options?.validate();
      if (updatedMod != m) {
        _mods[_mods.indexWhere((element) => element.id == updatedMod.id)];
      }
    });
    notifyListeners();
  }

  void removeUnitMod(String id) {
    _mods.removeWhere((mod) => mod.id == id);
    if (id == veteranId) {
      // only remove all vet upgrades if the unit doesn't still have the vet trait
      if (!traits.any((trait) => trait.name == 'Vet')) {
        _mods.removeWhere((mod) => mod is VeteranModification);
      }
    } else if (id == duelistId) {
      _mods.removeWhere((mod) => mod is DuelistModification);
      // if the unit isn't also a vet remove the vet traits
      if (!traits.any((trait) => trait.name == 'Vet')) {
        _mods.removeWhere((mod) => mod is VeteranModification);
      }
    }
    _mods.forEach((m) {
      final updatedMod = m.refreshData();
      updatedMod.options?.validate();
      if (updatedMod != m) {
        _mods[_mods.indexWhere((element) => element.id == updatedMod.id)];
      }
    });
    notifyListeners();
  }

  void forceNotify() {
    notifyListeners();
  }

  List<BaseModification> getMods() {
    return _mods.toList();
  }

  bool hasMod(String id) => this
      ._mods
      .where((element) => element.name == id || element.id == id)
      .isNotEmpty;

  BaseModification? getMod(String id) {
    if (!this.hasMod(id)) {
      return null;
    }
    return this._mods.firstWhere((mod) => mod.id == id);
  }

  int numUnitMods() => _mods.length;
  void clearUnitMods() {
    _mods.clear();
    notifyListeners();
  }
}

Map<BaseModification, Map<String, dynamic>> _loadOptionsFromJSON(
    Map<BaseModification, Map<String, dynamic>> modsWithOptionsToLoad,
    {bool refreshOptions = false}) {
  /*
      {
        "text": "LAC",
        "selected": null
      }
      ////////////////////
      {
        "text": "LSG",
        "selected": {
          "text": "LCW",
          "selected": null
        }
      }
      */
  final Map<BaseModification, Map<String, dynamic>> failedToLoadOptions = {};
  modsWithOptionsToLoad.forEach((modWithOptions, modOptions) {
    final selectedOptionText = modOptions['text'];
    final seletedOptionSelection = modOptions['selected'];

    if (refreshOptions) {
      modWithOptions = modWithOptions.refreshData();
    }

    if (selectedOptionText != null) {
      final selectedOption =
          modWithOptions.options!.optionByText(selectedOptionText);
      if (selectedOption != null) {
        modWithOptions.options!.selectedOption = selectedOption;
        if (seletedOptionSelection != null) {
          final subOptionText = seletedOptionSelection['text'];
          if (subOptionText != null) {
            final selectedSubOption =
                selectedOption.optionByText(subOptionText);
            if (selectedSubOption != null) {
              selectedOption.selectedOption = selectedSubOption;
            } else {
              failedToLoadOptions[modWithOptions] = modOptions;
              print('was unable to find a sub option that matches the ' +
                  'selected text value of $subOptionText for mod ' +
                  '${modWithOptions.id}');
            }
          }
        }
      } else {
        failedToLoadOptions[modWithOptions] = modOptions;
        print('was unable to find an option that matches the selected text' +
            ' value of $selectedOptionText for mod ${modWithOptions.id}');
      }
    }
  });

  return failedToLoadOptions;
}
