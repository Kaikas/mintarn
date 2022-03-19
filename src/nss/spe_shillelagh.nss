//::///////////////////////////////////////////////
//:: Shillelagh
//:://////////////////////////////////////////////
/*
  Grants a +1 enhancement bonus and let it deal damage as if it were two size categories larger.
*/

#include "x2_inc_spellhook"

void main() {

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oCaster = OBJECT_SELF;
    object oWeapon = IPGetTargetedOrEquippedMeleeWeapon();

    float nDuration = TurnsToSeconds(GetCasterLevel(oCaster));
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) {
        nDuration = nDuration * 2;
    }

    //Weapon becomes a weapon with a +1 enhancement bonus on attack and damage rolls.
    itemproperty ipEnhancementBonus = ItemPropertyEnhancementBonus(1);
    //Weapon deals damage as if it were two size categories larger (medium sized club/staff = 1d6, huge club/staff = 2d6)
    itemproperty ipIncreasedSizeDamage = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);

    if (GetIsObjectValid(oWeapon) && (GetBaseItemType(oWeapon) == BASE_ITEM_CLUB || GetBaseItemType(oWeapon) == BASE_ITEM_QUARTERSTAFF)) {
        SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oCaster, GetSpellId(), FALSE));
        //Add visual effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), GetItemPossessor(oWeapon));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), GetItemPossessor(oWeapon), nDuration);
        //Add temporary item properties
        IPSafeAddItemProperty(oWeapon, ipEnhancementBonus, nDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        IPSafeAddItemProperty(oWeapon, ipIncreasedSizeDamage, nDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    } else {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    }

}
