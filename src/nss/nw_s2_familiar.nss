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

    if(oFamiliar != OBJECT_INVALID && !GetHasSpell(916)){

        AssignCommand(oPc,ActionCastSpellAtObject(916, oPc, METAMAGIC_NONE, TRUE, 0,PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    }
    else if(GetHasSpell(916)){
    //Target already has the buff - do nothing
    }
    else{SpeakString("No Animal Companion Found!");}
}











