void main() {
    object oItem = GetPCItemLastEquipped();
    object oPc = GetPCItemLastEquippedBy();
    // Fackel
    if (GetTag(oItem) == "CRAFT_Fackel") {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_15), oPc);
    }
    // Rüstung
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
}
