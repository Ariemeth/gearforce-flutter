class PDFSettings {
  Sections sections = Sections();

  @override
  String toString() {
    return 'Sections: ' +
        'recordSheet = ${sections.recordSheet}, ' +
        'tallUnitCards = ${sections.tallUnitCards}, ' +
        'wideUnitCards = ${sections.wideUnitCards}, ' +
        'traitReference = ${sections.traitReference}, ' +
        'factionRules = ${sections.factionRules}, ' +
        'subFactionRules = ${sections.subFactionRules}';
  }
}

class Sections {
  bool recordSheet = true;
  bool tallUnitCards = false;
  bool wideUnitCards = true;
  bool traitReference = true;
  bool factionRules = true;
  bool subFactionRules = true;
  bool alphaBetaRules = true;
}
