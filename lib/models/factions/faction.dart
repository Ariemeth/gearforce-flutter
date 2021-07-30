import 'package:gearforce/models/factions/faction_type.dart';

class Faction {
  String get name => factionTypeToString(this.factionType);
  late final FactionType factionType;
  final List<String> subFactions;

  Faction({required this.factionType, required this.subFactions});
}
