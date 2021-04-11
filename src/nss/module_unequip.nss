void main() {
    object oItem = GetPCItemLastUnequipped();
    object oPc = GetPCItemLastUnequippedBy();

    // Fackel
    if (GetTag(oItem) == "CRAFT_Fackel") {
        effect eEffect = GetFirstEffect(oPc);
        while (GetIsEffectValid(eEffect)) {
            if (GetEffectType(eEffect) == 74) {
                RemoveEffect(oPc, eEffect);
            }
            eEffect = GetNextEffect(oPc);
        }
    }
    // Rüstung
    if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR){
        effect eEffect = GetFirstEffect(oPc);
        while(GetIsEffectValid(eEffect)) {
            if(GetEffectTag(eEffect) == "eff_armorslow") {
                RemoveEffect(oPc, eEffect);
            }
            eEffect = GetNextEffect(oPc);
        }
    }
}
