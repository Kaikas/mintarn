//::///////////////////////////////////////////////
//:: Winter’s Embrace
//:: NW_WINTERSEMBRACE
//:://////////////////////////////////////////////
/*
  Subject takes 1d8 damage/round; can cause fatigue.
*/

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"

void ApplyFrostburnEffect(object oTarget, object oCaster, int spell, int metaMagic, int dc, int failedSaves);

void main() {

  if (X2PreSpellCastCode()) {

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int dc = GetSpellSaveDC();
    int metaMagic = GetMetaMagicFeat();

    int duration = GetCasterLevel(oCaster);
    if (metaMagic == METAMAGIC_EXTEND) {
      duration = duration * 2;
    }

    if (!GetIsReactionTypeFriendly(oTarget)) {
      SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, dc, SAVING_THROW_TYPE_COLD)) {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(MaximizeOrEmpower(8, 1, metaMagic), DAMAGE_TYPE_COLD), oTarget);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_BLUE), oTarget, RoundsToSeconds(duration-1));
          DelayCommand(6.0f, ApplyFrostburnEffect(oTarget, oCaster, GetSpellId(), metaMagic, dc, 1));
        }
        else {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_BLUE), oTarget, RoundsToSeconds(duration-1));
          DelayCommand(6.0f, ApplyFrostburnEffect(oTarget, oCaster, GetSpellId(), metaMagic, dc, 0));
        }
      }
    }
  }
}

void ApplyFrostburnEffect(object oTarget, object oCaster, int spell, int metaMagic, int dc, int failedSaves) {
  if (!GZGetDelayedSpellEffectsExpired(spell, oTarget, oCaster)) {
    if (GetIsDead(oTarget)) {
      GZRemoveSpellEffects(spell, oTarget);
      return;
    }
    int failedSavesCounter = failedSaves;
    //On the subject’s action each round, it can attempt a new Fortitude saving throw to avoid taking damage that round.
    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, dc, SAVING_THROW_TYPE_COLD)) {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(MaximizeOrEmpower(8, 1, metaMagic), DAMAGE_TYPE_COLD), oTarget);
      failedSavesCounter = failedSavesCounter + 1;

      //If a creature takes damage twice from a single casting of winter’s embrace, it becomes fatigued. 
      if (failedSavesCounter == 2) {
        //A fatigued character takes a -2 penalty to Strength and Dexterity. After 8 hours of complete rest, fatigued characters are no longer fatigued.
        effect fatigued = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, 2), EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
        fatigued = ExtraordinaryEffect(EffectLinkEffects(fatigued, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, fatigued, oTarget, HoursToSeconds(8));
      }

      //The fourth time a creature takes damage from the same spell, it becomes exhausted.
      if (failedSavesCounter == 4) {
        //An exhausted character moves at half speed and takes a -6 penalty to Strength and Dexterity. After 1 hour of complete rest, an exhausted character becomes fatigued.
        effect exhausted = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, 4), EffectAbilityDecrease(ABILITY_DEXTERITY, 4));
        exhausted = EffectLinkEffects(exhausted, EffectMovementSpeedDecrease(50));
        exhausted = ExtraordinaryEffect(EffectLinkEffects(exhausted, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, exhausted, oTarget, HoursToSeconds(1));
      }

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
    }
    DelayCommand(6.0f, ApplyFrostburnEffect(oTarget, oCaster, spell, metaMagic, dc, failedSavesCounter));
  }
}
