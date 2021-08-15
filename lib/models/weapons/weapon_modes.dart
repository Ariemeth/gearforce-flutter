enum weaponModes {
  Direct,
  Indirect,
  Melee,
  Proximity,
}

String getWeaponModeName(weaponModes wm) {
  return wm.toString().split('.').last;
}
