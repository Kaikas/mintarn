#include "x2_inc_itemprop"
#include "nwnx_events"
#include "nwnx_player"
#include "x3_inc_skin"

int ChestArmourIsLightOrLess(object oPc) {
  object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
  if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR){
    int nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    if (nAC < 4) {
      return 1;
    } else {
      return 0;
    }
  }
  return 1;
}

int HasNoShieldEquipped(object oPc) {
  object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
  if(GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD ||
      GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD ||
      GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) {
      return 0;
  }
  return 1;
}

void SpellFailureForBards(object oPc, int iSpellID) {
  int iBardLevel = GetLevelByClass(CLASS_TYPE_BARD, oPc);
  int iWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPc);
  int iSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPc);
  int iCharLevel = GetHitDice(oPc);
  if (iBardLevel > 0 && iWizardLevel == 0 && iSorcererLevel == 0) {
    if (ChestArmourIsLightOrLess(oPc) && HasNoShieldEquipped(oPc)) {
      DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPc));
      object oItem = SKIN_SupportGetSkin(oPc);
      if (!GetIsObjectValid(oItem)) {
        SendMessageToPC(oPc, "FAIL: No Hide equipped");
        return;
      }
      int nModLevel = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
      itemproperty ipAdd = ItemPropertyArcaneSpellFailure(nModLevel);
      IPSafeAddItemProperty(oItem, ipAdd);
    }
  }
}

void main() {
  object oPc = OBJECT_SELF;
  int iSpellID = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
  SpellFailureForBards(oPc, iSpellID);
}
