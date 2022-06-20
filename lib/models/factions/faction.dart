import 'package:gearforce/models/factions/faction_type.dart';

class Faction {
  String get name => this.factionType.name;
  final FactionType factionType;
  final List<String> subFactions;

  Faction({required this.factionType, required this.subFactions});
}
