#include "nwnx_events"
#include "nwnx_player"

void SpellFailureForBards(object oPc, int SpellID) {
  int iBardLevel = GetLevelByClass(CLASS_TYPE_BARD, oPc);
  int iWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPc);
  int iSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPc);
  int iCharLevel = GetHitDice(oPc);
  if (iBardLevel > 0 && iWizardLevel == 0 && iSorcererLevel == 0) {
    // Get AC of Chest armour
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPc);
    itemproperty ipLoop=GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipLoop)) {
      if (GetItemPropertyType(ipLoop) == IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT) {
        RemoveItemProperty(oItem, ipLoop);
      }
      ipLoop=GetNextItemProperty(oItem);
    }
  }
}

void main() {
  int iSpellID = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
  SpellFailureForBards(OBJECT_SELF, iSpellID);
}
