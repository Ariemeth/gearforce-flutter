class Role {
  const Role({required this.name, this.unlimited = false});

  final RoleType name;
  final bool unlimited;
  factory Role.fromJson(dynamic json) => Role(
        name: convertRoleType(json.toString().split('+').first),
        unlimited: json.toString().endsWith('+') ? true : false,
      );

  @override
  String toString() {
    return '${name.toString().split('.').last.toUpperCase()}${unlimited ? '+' : ''}';
  }
}

RoleType convertRoleType(String role) {
  switch (role.toUpperCase()) {
    case 'GP':
      return RoleType.gp;
    case 'SK':
      return RoleType.sk;
    case 'FS':
      return RoleType.fs;
    case 'RC':
      return RoleType.rc;
    case 'SO':
      return RoleType.so;
    case 'FT':
      return RoleType.ft;
  }

  throw FormatException('Unknown role type', role);
}

class Roles {
  const Roles({required this.roles});

  final List<Role> roles;

  factory Roles.fromJson(dynamic json) {
    List<Role> r = [];
    json.toString().split(',').forEach((element) {
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
    return roles.any((role) => roleType.contains(role.name));
  }

  @override
  String toString() {
    return roles.toString();
  }
}

enum RoleType { gp, sk, fs, rc, so, ft }
