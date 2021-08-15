class Weapon {
  const Weapon({
    required this.code,
    required this.name,
  });
  final String code;
  final String name;

  Map<String, dynamic> toJson() => {
        'code': this.code,
        'name': this.name,
      };

  factory Weapon.fromJson(dynamic json) {
    return Weapon(
      code: json['code'],
      name: json['name'],
    );
  }
}
