enum weaponModes {
  Direct,
  Indirect,
  Melee,
}

String getWeaponModeName(weaponModes wm) {
  return wm.toString().split('.').last;
}
