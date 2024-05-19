class PDFSettings {
  Sections sections = Sections();

  @override
  String toString() {
    return 'Sections: ' +
        'recordSheet = ${sections.recordSheet}, ' +
        'unitCards = ${sections.unitCards}, ' +
        'traitReference = ${sections.traitReference}, ' +
        'factionRules = ${sections.factionRules}, ' +
        'subFactionRules = ${sections.subFactionRules}';
  }
}

class Sections {
  bool recordSheet = true;
  bool unitCards = true;
  bool traitReference = true;
  bool factionRules = true;
  bool subFactionRules = true;
  bool alphaBetaRules = true;
}
