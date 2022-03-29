//::///////////////////////////////////////////////
//:: Summon Natures Ally Series
//:: spe_summonnat
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Nature's Ally Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: VICTORIOUS!
//:: Created On: 29.03.2022, copied over from summon monster
//:://////////////////////////////////////////////

effect SetSummonEffect(int nSpellID);

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nSpellID = GetSpellId();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    nDuration = Mintarn_24HourSpellToSeconds();
    if(nDuration == 1)
    {
        nDuration = 2;
    }
    effect eSummon = SetSummonEffect(nSpellID);

    //Make metamagic check for extend
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}


effect SetSummonEffect(int nSpellID)
{
    int nFNF_Effect;
    int nRoll = d3();
    string sSummon;

        if(nSpellID == 907)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "MIN_NATUREALLY1";
        }
        else if(nSpellID == 908)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "MIN_NATUREALLY2";
        }
        else if(nSpellID == 909)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "MIN_NATUREALLY3";
        }
        else if(nSpellID == 910)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "MIN_NATUREALLY3";
        }
        else if(nSpellID == 911)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "MIN_NATUREALLY4";
        }
        else if(nSpellID == 912)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "MIN_NATUREALLY5";
        }
        else if(nSpellID == 913)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRHUGE";
                break;

                case 2:
                    sSummon = "NW_S_WATERHUGE";
                break;

                case 3:
                    sSummon = "NW_S_FIREHUGE";
                break;
            }
        }
        else if(nSpellID == 914)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRGREAT";
                break;

                case 2:
                    sSummon = "NW_S_WATERGREAT";
                break;

                case 3:
                    sSummon = "NW_S_FIREGREAT";
                break;
            }
        }
        else if(nSpellID == 915)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRELDER";
                break;

                case 2:
                    sSummon = "NW_S_WATERELDER";
                break;

                case 3:
                    sSummon = "NW_S_FIREELDER";
                break;
            }
        }
         SpeakString(IntToString(nSpellID));
         SpeakString(sSummon);
    //effect eVis = EffectVisualEffect(nFNF_Effect);
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
    return eSummonedMonster;
}

