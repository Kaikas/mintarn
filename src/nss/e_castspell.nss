#include "x2_inc_itemprop"
#include "nwnx_events"
#include "nwnx_player"

void SpellFailureForBards(object oPc, int iSpellID) {
  int iBardLevel = GetLevelByClass(CLASS_TYPE_BARD, oPc);
  int iWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPc);
  int iSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPc);
  int iCharLevel = GetHitDice(oPc);
  if (iBardLevel > 0 && iWizardLevel == 0 && iSorcererLevel == 0) {
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPc);
    if (!GetIsObjectValid(oItem)) return;
    int nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
    itemproperty ipAdd = ItemPropertyArcaneSpellFailure(nModLevel);
    IPSafeAddItemProperty(oItem, ipAdd);
  }
}

void main() {
  int iSpellID = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
  SpellFailureForBards(OBJECT_SELF, iSpellID);
}
