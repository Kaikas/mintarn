void SpellFailureForBards(object oPc, int SpellID) {
  int iBardLevel = GetLevelByClass(CLASS_TYPE_BARD, oPc);
  int iWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPc);
  int iSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPc);
  int iCharLevel = GetHitDice(oPc);
  if (iBardLevel > 0 && iWizardLevel == 0 && iSorcererLevel == 0) {
    
  }
}

void main() {
  SpellFailureForBards(OBJECT_SELF);
}
