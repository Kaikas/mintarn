//::///////////////////////////////////////////////
//:: Kelpstrand
//:: NW_KELPSTRAND
//:://////////////////////////////////////////////
/*
  Long strands of wet kelp streak out to envelop your target. A target that fails the grapple check becomes entangled in the thick strands of kelp and is grappled.
*/

#include "x2_I0_SPELLS"
#include "x3_inc_string"
#include "x2_inc_spellhook"

void RepeatGrappleCheck(object oTarget, object oCaster, int spell, int attachedStrands);

void main() {

    if (!X2PreSpellCastCode()){
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
    }

    //location lTarget = GetSpellTargetLocation();

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    //location lLocation = GetSpellTargetLocation();
    //int nArea = 1;
    //if(GetIsObjectValid(oTarget)){
    //    nArea = 0;
    //}

    int duration = GetCasterLevel(oCaster);
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) {
     duration = duration * 2;
    }

    //Grapple check by caster is done with Casterlevel and Ability Mod for this Spell
    int iGrappleModCaster = GetCasterLevel(oCaster) + GetAbilityModifier(ABILITY_WISDOM, oCaster);
    //Normal grapple check: Base attack bonus + Strength modifier + special size modifier
    int iGrappleModTarget = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);

    //For every three caster levels gain an additional strand.
    int strands = GetCasterLevel(oCaster) / 3;
    if (strands < 1) {
      strands = 1;
    }
    if (strands > 5) {
      strands = 5;
    }

    //Only works against hostiles/"Foes"
    if (!GetIsReactionTypeFriendly(oTarget)) {
      SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
      int attachedStrands = 0;
      int strand = 1;

      //Start of Loop
      for (strand = 1; strand <= strands; strand++) {

        if (TouchAttackRanged(oTarget, GetSpellCastItem() == OBJECT_INVALID) > 0 && !GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget)) {

          string sLogMessage;

          //Roll the d20s
          int iRollCaster = d20(1);
          int iRollTarget = d20(1);

          //In case of a tie roll again to break the tie
          while ((iRollCaster + iGrappleModCaster) == (iRollTarget + iGrappleModTarget)) {
            iRollCaster = d20(1);
            iRollTarget = d20(1);
          }
          if ((iRollCaster + iGrappleModCaster) > (iRollTarget + iGrappleModTarget)) {
            attachedStrands = attachedStrands + 1;
            sLogMessage = StringToRGBString(GetName(oCaster), "477") + StringToRGBString(" : Ringkampfwurf gegen " + GetName(oTarget) + " : *Erfolg* : (" + IntToString(iRollCaster) + " + " + IntToString(iGrappleModCaster) + " = " + IntToString(iRollCaster + iGrappleModCaster) + " gg. " + IntToString(iRollTarget) + " + " + IntToString(iGrappleModTarget) + " = " + IntToString(iRollTarget + iGrappleModTarget) + ")", "267");
          }
          else {
            sLogMessage = StringToRGBString(GetName(oCaster), "477") + StringToRGBString(" : Ringkampfwurf gegen " + GetName(oTarget) + " : *Misserfolg* : (" + IntToString(iRollCaster) + " + " + IntToString(iGrappleModCaster) + " = " + IntToString(iRollCaster + iGrappleModCaster) + " gg. " + IntToString(iRollTarget) + " + " + IntToString(iGrappleModTarget) + " = " + IntToString(iRollTarget + iGrappleModTarget) + ")", "267");
          }

         if (GetIsPC(oCaster)) {
           SendMessageToPC(oCaster, sLogMessage);
         }
         if (GetIsPC(oTarget)) {
           SendMessageToPC(oTarget, sLogMessage);
         }
         else {
           object oMaster = GetMaster(oTarget);
           if (GetIsObjectValid(oMaster) && GetIsPC(oMaster) && (GetName(oCaster) != GetName(oMaster))) {
             SendMessageToPC(oMaster, sLogMessage);
           }
         }
       }
      }
      if (attachedStrands == 0) {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE), oTarget);
      }
      else {
        //While grappling only attacks with unarmed strike, natural weapon, or light weapon are allowed
        if (GetIsPC(oTarget)) {
          SendMessageToPC(oTarget, StringToRGBString("Ihr seid in einen Ringkampf verwickelt und könnt keine somatischen Zauber wirken oder beidhändige Waffen einsetzen.", "770"));
        }

        object oEquippedWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
         if (GetIsObjectValid(oEquippedWeapon)) {
           if (!MatchSingleHandedWeapon(oEquippedWeapon)) {
             AssignCommand(oTarget, ClearAllActions());
             AssignCommand(oTarget, ActionUnequipItem(oEquippedWeapon));
           }
         }
        //Grappling Consequences: No Dexterity Bonus, No Movement, No Spellcasting with somatic component
        effect grappling = EffectLinkEffects(MagicalEffect(EffectSpellFailure()), MagicalEffect(EffectMovementSpeedDecrease(99)));
        int targetDexModifier = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
        if (targetDexModifier > 0) {
          grappling = EffectLinkEffects(grappling, MagicalEffect(EffectACDecrease(targetDexModifier, AC_DODGE_BONUS)));
        }
        grappling = EffectLinkEffects(grappling, EffectVisualEffect(VFX_DUR_ENTANGLE));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, grappling, oTarget, RoundsToSeconds(duration));
        DelayCommand(6.0f, RepeatGrappleCheck(oTarget, oCaster, GetSpellId(), attachedStrands));
      }
    }
  }

void RepeatGrappleCheck(object oTarget, object oCaster, int spell, int attachedStrands) {
    if (GetIsDead(oTarget)) {
      return;
    }
    else {
      int iBeatenStrands = 0;
      //Add your caster level and your Wisdom bonus to the result of your grapple check rather than your Strength bonus and size bonus
      int iGrappleModCaster = GetCasterLevel(oCaster) + GetAbilityModifier(ABILITY_WISDOM, oCaster);
      //Attack bonus on a grapple check is: Base attack bonus + Strength modifier + special size modifier
      int iGrappleModTarget = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);
      int strand = 1;
      for(strand = 1; strand <= attachedStrands; strand++){
       string sLogMessage;
       int iRollCaster = d20(1);
       int iRollTarget = d20(1);

       //In case of a tie roll again to break the tie
       while ((iRollCaster + iGrappleModCaster) == (iRollTarget + iGrappleModTarget)) {
        iRollCaster = d20(1);
        iRollTarget = d20(1);
       }

      if ((iRollCaster + iGrappleModCaster) > (iRollTarget + iGrappleModTarget)) {
        sLogMessage = StringToRGBString(GetName(oTarget), "646") + StringToRGBString(" : Ringkampfwurf gegen " + GetName(oCaster) + " : *Misserfolg* : (" + IntToString(iRollCaster) + " + " + IntToString(iGrappleModCaster) + " = " + IntToString(iRollCaster + iGrappleModCaster) + " gg. " + IntToString(iRollTarget) + " + " + IntToString(iGrappleModTarget) + " = " + IntToString(iRollTarget + iGrappleModTarget) + ")", "267");

      }
      else {
        sLogMessage = StringToRGBString(GetName(oTarget), "646") + StringToRGBString(" : Ringkampfwurf gegen " + GetName(oCaster) + " : *Erfolg* : (" + IntToString(iRollCaster) + " + " + IntToString(iGrappleModCaster) + " = " + IntToString(iRollCaster + iGrappleModCaster) + " gg. " + IntToString(iRollTarget) + " + " + IntToString(iGrappleModTarget) + " = " + IntToString(iRollTarget + iGrappleModTarget) + ")", "267");
        iBeatenStrands++;
      }

      if (GetIsPC(oCaster)) {
        SendMessageToPC(oCaster, sLogMessage);
      }
      if (GetIsPC(oTarget)) {
        SendMessageToPC(oTarget, sLogMessage);
      }
      else {
        object oMaster = GetMaster(oTarget);
        if (GetIsObjectValid(oMaster) && GetIsPC(oMaster) && (GetName(oCaster) != GetName(oMaster))) {
          SendMessageToPC(oMaster, sLogMessage);
        }
       }
      }
        if(attachedStrands - iBeatenStrands <= 0){
            RemoveSpellEffects(spell, oCaster, oTarget);}
            else{
        DelayCommand(6.0f, RepeatGrappleCheck(oTarget, oCaster, spell, attachedStrands - iBeatenStrands));
        }
      }
    }