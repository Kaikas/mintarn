//::///////////////////////////////////////////////
//:: Lava Missile
//:: NW_LAVAMISSILE
//:://////////////////////////////////////////////
/*
  Lava dart strikes its target, dealing 1d4 points of fire damage. A target that fails its saving throw catches on fire.
*/

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"


//If the target doesn't make the saving throw, do damage and continue on
void ApplyBurningEffect(object oTarget, object oCaster, int spell) {

  if (!GZGetDelayedSpellEffectsExpired(spell, oTarget, oCaster)) {

    if (GetIsDead(oTarget) || MySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_FIRE)) {
      GZRemoveSpellEffects(spell, oTarget);
    }
    else {

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(1), DAMAGE_TYPE_FIRE), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oTarget);
      DelayCommand(6.0f, ApplyBurningEffect(oTarget, oCaster, spell));
    }

  }

}

//The part of the spell where the missiles impact the target
void RunLavaImpact(object oTarget, object oCaster, int iSpellID, int missiles, int metaMagic, int iSpellDC, effect eBurning)
{
      int missile;
      int savingThrowFailed;
      effect targetEffect = EffectVisualEffect(VFX_IMP_FLAME_S);

      for (missile = 1; missile <= missiles; missile++) {
        int damage = d4(1);
        if (metaMagic == METAMAGIC_MAXIMIZE) {
          damage = 4;
        }
        if (metaMagic == METAMAGIC_EMPOWER) {
          damage = damage + damage / 2;
        }
        if (MySavingThrow(SAVING_THROW_REFLEX, oTarget, iSpellDC, SAVING_THROW_TYPE_FIRE)) {
          damage = damage / 2;
        } else {
          savingThrowFailed = 1;
        }
        effect damageEffect = EffectDamage(damage, DAMAGE_TYPE_FIRE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, damageEffect, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, targetEffect, oTarget);
      }
      //A target that fails at least one saving throw catches on fire.
      if (savingThrowFailed == 1) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBurning, oTarget, RoundsToSeconds(GetCasterLevel(oCaster)));
        DelayCommand(6.0f,ApplyBurningEffect(oTarget,oCaster, iSpellID));
      }

   }




void main()
{
    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int metaMagic = GetMetaMagicFeat();
    effect missileEffect = EffectVisualEffect(VFX_IMP_MIRV_FLAME);

    float fDelay = GetDistanceBetween(oCaster, oTarget) / (3.0 * log(GetDistanceBetween(oCaster, oTarget)) + 2.0);

    //For every two caster levels gain an a dditional missile — two at 4th level, three at 6th level, four at 8th level and the maximum of five at 10th level or higher.
    int missiles = GetCasterLevel(oCaster) / 2;
    if (missiles < 1) {
      missiles = 1;
    }
    if (missiles > 5) {
      missiles = 5;
    }

    int iSpellID=GetSpellId();
    int nMetaMagic = GetMetaMagicFeat();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Shoot as many fire projectiles things as there are missiles
        int iProjectile;
        for(iProjectile = 1; iProjectile <= missiles; iProjectile++){
            ApplyEffectToObject(DURATION_TYPE_INSTANT, missileEffect, oTarget);

        }
        //the main() has to apply SOME effect, or the spell will count as ended. VFX_DUR_LIGHT is an invisible effect!
        effect eSpellDebug = EffectVisualEffect(VFX_DUR_LIGHT);
        //effects have to be declared in the main() to be considered part of the spell when applied
        effect eBurning = EffectVisualEffect(VFX_DUR_INFERNO);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellDebug, oTarget, fDelay + RoundsToSeconds(GetCasterLevel(oCaster)));
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellID, TRUE));
        //only run the impact when the missiles have landed
        DelayCommand(fDelay,RunLavaImpact(oTarget,oCaster,iSpellID, missiles, metaMagic, GetSpellSaveDC(), eBurning));
    }
}
