class SavedMod {
  final String type;
  final int order;
  final Map<String, dynamic> mod;

  SavedMod(this.type, this.order, this.mod);

  factory SavedMod.fromJson(dynamic json) {
    return SavedMod(json['type'], json['order'], json['mod']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'order': order, 'mod': mod};
  }

  Map<String, dynamic>? get selected => mod['selected'];

  String get ModId => mod['id'];
}
