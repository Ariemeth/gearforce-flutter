class Role {
  const Role({required this.name, this.unlimited = false});

  final RoleType name;
  final bool unlimited;
  factory Role.fromJson(dynamic json) => Role(
        name: convertRoleType(json.toString().split("+").first),
        unlimited: json.toString().endsWith('+') ? true : false,
      );

  @override
  String toString() {
    return '${this.name.toString().split('.').last}${this.unlimited ? '+' : ''}';
  }
}

RoleType convertRoleType(String role) {
  switch (role.toUpperCase()) {
    case "GP":
      return RoleType.GP;
    case "SK":
      return RoleType.SK;
    case "FS":
      return RoleType.FS;
    case "RC":
      return RoleType.RC;
    case "SO":
      return RoleType.SO;
    case "FT":
      return RoleType.FT;
  }

  throw new FormatException("Unknown role type", role);
}

class Roles {
  const Roles({required this.roles});

  final List<Role> roles;

  factory Roles.fromJson(dynamic json) {
    List<Role> r = [];
    json.toString().split(",").forEach((element) {
      r.add(Role.fromJson(element.trim()));
    });
    return Roles(
      roles: r,
    );
  }

  factory Roles.from(Roles old) {
    return Roles(roles: old.roles.toList());
  }

  bool includesRole(List<RoleType?> roleType) {
    return roles.any((element) => roleType.contains(element.name));
  }

  @override
  String toString() {
    return roles.toString();
  }
}

enum RoleType { GP, SK, FS, RC, SO, FT }
