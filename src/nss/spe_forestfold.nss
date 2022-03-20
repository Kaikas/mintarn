//::///////////////////////////////////////////////
//:: Forestfold
//:: NW_FORESTFOLD
//:://////////////////////////////////////////////
/*
  Grants a +10 competence bonus on Hide and Move Silently checks.
*/

#include "x2_inc_spellhook"

void main() {

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    int nDuration = GetCasterLevel(oCaster);
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) {
      nDuration = nDuration * 2;
    }

    //Grants a +10 competence bonus on Hide and Move Silently checks.
    effect eStealth = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, 10), EffectSkillIncrease(SKILL_MOVE_SILENTLY, 10));
    eStealth = EffectLinkEffects(eStealth, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    if (GetIsObjectValid(oTarget)) {
      SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStealth, oTarget, Mintarn_HourSpellToSeconds(nDuration));
    }
}
