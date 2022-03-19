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
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    string sSpellName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", GetSpellId())));
    SendMessageToAllDMs(GetName(OBJECT_SELF) + " hat " + sSpellName + " gewirkt.");
    //SendMessageToPC(OBJECT_SELF,sSpellName);


}
