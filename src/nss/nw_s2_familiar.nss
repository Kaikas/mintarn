//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:://////////////////////////////////////////////
/*
    This summons a Wizard's or sorcerers familiar.
*/
//:://////////////////////////////////////////////
//:: By Victorious & Yuuki
//:://////////////////////////////////////////////

#include "nwnx_creature"
void main()
{
    object oPc = OBJECT_SELF;
    object oFamiliar = OBJECT_INVALID;

    SummonFamiliar();

    oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);

    if(oFamiliar != OBJECT_INVALID){
        string sTag = GetTag(oFamiliar);
        int iTagLength = GetStringLength(sTag);
        sTag = GetSubString(sTag, 0, iTagLength-2);
        SpeakString(sTag);

        if(sTag == "NW_FM_BAT"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_LISTEN,3),oPc);
        }
        else if(sTag == "NW_FM_CAT"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_MOVE_SILENTLY,3),oPc);
        }
        else if(sTag == "NW_FM_HAWK"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_SPOT,2),oPc);
        }
        else if(sTag == "NW_FM_LIZ"){
        //Look up SkillID for athletics
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_LISTEN,3),oPc);
        }
        else if(sTag == "NW_FM_OWL"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(FEAT_SKILL_FOCUS_SPOT,2),oPc);
        }
        else if(sTag == "NW_FM_RAT"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSavingThrowIncrease(SAVING_THROW_FORT,2),oPc);
        }
        else if(sTag == "NW_FM_RAVE"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_APPRAISE,3),oPc);
        }
        else if(sTag == "NW_FM_VIP"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSkillIncrease(SKILL_BLUFF,3),oPc);
        }
        else if(sTag == "NW_FM_FROG"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectTemporaryHitpoints(3),oPc);
        }
        else if(sTag == "NW_FM_WEAS"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSavingThrowIncrease(SAVING_THROW_REFLEX,2),oPc);
        }
        else if(sTag == "NW_FM_FERR"){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectSavingThrowIncrease(SAVING_THROW_REFLEX,2),oPc);
        }
        else {SpeakString("Familiar not implemented:" + sTag );}
    }
    else{SpeakString("No Animal Companion Found!");}
}











