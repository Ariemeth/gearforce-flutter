import 'package:gearforce/models/rules/nucoal/nucoal.dart';

/*
  TH - Temple Heights
  The city of Temple Heights is an enigma. It has gone from an obscure city in the Badlands to a
  thriving refugee center and tourist destination. From liberated GRELs to the mysterious Sandriders,
  all types now call the crescent mesa city home. Reports about the Sandriders themselves are very
  minimal. Every recon mission sent to observe Sandrider camps have mysteriously disappeared. The
  popular rumor is that the desert itself swallowed them whole.
  * Jannite Pilots: Veteran gears in this force with one action may upgrade to having two actions
  for +2 TV each.
  * Jannite Wardens: You may select 2 gears in this force to become duelists. All duelists must take
  the Jannite Pilot upgrade if able.
  * Local Militia: Combat groups made entirely of infantry and/or cavalry may use the GP, SK,
  FS, RC or SO roles. A combat group of all infantry and/or cavalry may deploy using the special
  operations deployment rule.
  * Something to Prove: GREL infantry may increase their GU skill by one for 1 TV each.
*/
class TH extends NuCoal {
  TH(super.data)
      : super(
          name: 'Temple Heights',
          subFactionRules: [],
        );
}
