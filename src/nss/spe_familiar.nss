//::///////////////////////////////////////////////
//:: Generic RP Spell
//:: spe_generic
//:://////////////////////////////////////////////
/*
    Writes the Name of the Spell to the combat log chat
*/
//:://////////////////////////////////////////////
//:: Created By: Victorious
//:: Created On: 19.03.22
//:://////////////////////////////////////////////



#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"


void main()
{
   object oPc = GetSpellTargetObject();
   object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);

   if(oFamiliar != OBJECT_INVALID){
        string sTag = GetTag(oFamiliar);
        int iTagLength = GetStringLength(sTag);
        sTag = GetSubString(sTag, 0, iTagLength-2);
        SpeakString(sTag);

        effect eFamiliarBuff;

        if(sTag == "NW_FM_BAT"){
        eFamiliarBuff = EffectSkillIncrease(SKILL_LISTEN,3);
        }
        else if(sTag == "NW_FM_CAT"){
        eFamiliarBuff = EffectSkillIncrease(SKILL_MOVE_SILENTLY,3);
        }
        else if(sTag == "NW_FM_HAWK"){
        eFamiliarBuff = EffectSkillIncrease(SKILL_SPOT,2);
        }
        else if(sTag == "NW_FM_LIZ"){
        //Look up SkillID for athletics
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_LISTEN,3),oPc);
        }
        else if(sTag == "NW_FM_OWL"){
        eFamiliarBuff = EffectSkillIncrease(FEAT_SKILL_FOCUS_SPOT,2);
        }
        else if(sTag == "NW_FM_RAT"){
        eFamiliarBuff = EffectSavingThrowIncrease(SAVING_THROW_FORT,2);
        }
        else if(sTag == "NW_FM_RAVE"){
        eFamiliarBuff = EffectSkillIncrease(SKILL_APPRAISE,3);
        }
        else if(sTag == "NW_FM_VIP"){
        eFamiliarBuff = EffectSkillIncrease(SKILL_BLUFF,3);
        }
        else if(sTag == "NW_FM_FROG"){
        eFamiliarBuff = EffectTemporaryHitpoints(3);
        }
        else if(sTag == "NW_FM_WEAS"){
        eFamiliarBuff = EffectSavingThrowIncrease(SAVING_THROW_REFLEX,2);
        }
        else if(sTag == "NW_FM_FERR"){
        eFamiliarBuff = EffectSavingThrowIncrease(SAVING_THROW_REFLEX,2);
        }
        else {SpeakString("Familiar not implemented:" + sTag );}

        eFamiliarBuff = ExtraordinaryEffect(eFamiliarBuff);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eFamiliarBuff,oPc);

    }
    else{SpeakString("No Animal Companion Found!");}


}
