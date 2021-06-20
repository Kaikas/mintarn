#include "global_helper"
#include "nw_i0_plot"

// Handles player death
void main() {
    object oPc = GetLastPlayerDied();
    location lStart = GetLocation(GetObjectByTag("WP_DEATH"));
    AssignCommand(oPc, JumpToLocation(lStart));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPc);
    RemoveEffects(oPc);

    // armour slow
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR){
        // copied from: https://nwnlexicon.com/index.php?title=GetItemACValue
        // Get the appearance of the torso slot
        int nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
        // Look up in parts_chest.2da the relevant line, which links to the actual AC bonus of the armor
        // We cast it to int, even though the column is technically a float.
        int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
        // Return the given AC value (0 to 8)
        //End Copy

        if(nAC == 4 || nAC == 5) {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectMovementSpeedDecrease(5)), "eff_armorslow"), oPc);
        } else if (nAC > 5) {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectMovementSpeedDecrease(10)), "eff_armorslow"), oPc);
        }
    }

    // Reset 6 rounds
    SetLocalInt(oPc, "DYING_POINTS", 0);
    SetLocalInt(oPc, "LIVING_POINTS", 0);
}
