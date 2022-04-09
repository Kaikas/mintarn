//::///////////////////////////////////////////////
//:: Familiar Buff spell
//:: spe_familiar
//:://////////////////////////////////////////////
/*
    Buffs Master and familiar as close as possible to 3.5 values
*/
//:://////////////////////////////////////////////
//:: Created By: Victorious
//:: Created On: 09.04.22
//:://////////////////////////////////////////////



#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "nwnx_creature"


void main()
{
   object oPc = GetSpellTargetObject();
   object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);

   if(oFamiliar != OBJECT_INVALID){
        string sTag = GetTag(oFamiliar);
        int iTagLength = GetStringLength(sTag);
        sTag = GetSubString(sTag, 0, iTagLength-2);

        effect eFamiliarBuff;
        int iClassLevels;
        if(GetLevelByClass(CLASS_TYPE_WIZARD,oPc)>GetLevelByClass(CLASS_TYPE_SORCERER,oPc)){
            iClassLevels = GetLevelByClass(CLASS_TYPE_WIZARD,oPc);
        }
        else{
           iClassLevels = GetLevelByClass(CLASS_TYPE_SORCERER,oPc);
        }

        //3.5: For the purpose of effects related to number of Hit Dice, use the master’s character level or the familiar’s normal HD total, whichever is higher.
        //We decided to "ignore" this part of the rules because the implementation is a royal pain in the ass.
        //Function only increases level("HitDice"), but doesn't actually grant HP
        //NWNX_Creature_SetLevelByPosition(oFamiliar, 0, GetHitDice(oPc));

        //3.5: Use the master’s base attack bonus, as calculated from all his classes
        NWNX_Creature_SetBaseAttackBonus(oFamiliar, GetBaseAttackBonus(oPc));

        //3.5: Natural Armor Adj. - The number noted here (https://www.d20srd.org/srd/classes/sorcererWizard.htm) is an improvement to the familiar’s existing natural armor bonus.
        NWNX_Creature_SetBaseAC(oFamiliar, (NWNX_Creature_GetBaseAC(oFamiliar) + (GetHitDice(oPc)/2)));

        //3.5: For each saving throw, use either the familiar’s base save bonus (Fortitude +2, Reflex +2, Will +0) or the master’s (as calculated from all his classes), whichever is better.
        // -> it doesn’t share any of the other bonuses that the master might have on saves.
        //Need to check if the "other bonuses" aren't shared!
        NWNX_Creature_SetBaseSavingThrow(oFamiliar,SAVING_THROW_FORT,NWNX_Creature_GetBaseSavingThrow(oFamiliar,SAVING_THROW_FORT)+2);
        NWNX_Creature_SetBaseSavingThrow(oFamiliar,SAVING_THROW_REFLEX,NWNX_Creature_GetBaseSavingThrow(oFamiliar,SAVING_THROW_REFLEX)+2);

        if(NWNX_Creature_GetBaseSavingThrow(oFamiliar,SAVING_THROW_FORT)< NWNX_Creature_GetBaseSavingThrow(oPc,SAVING_THROW_FORT)){
            NWNX_Creature_SetBaseSavingThrow(oFamiliar,SAVING_THROW_FORT,NWNX_Creature_GetBaseSavingThrow(oPc,SAVING_THROW_FORT));
        }
        if(NWNX_Creature_GetBaseSavingThrow(oFamiliar,SAVING_THROW_REFLEX)< NWNX_Creature_GetBaseSavingThrow(oPc,SAVING_THROW_REFLEX)){
            NWNX_Creature_SetBaseSavingThrow(oFamiliar,SAVING_THROW_REFLEX,NWNX_Creature_GetBaseSavingThrow(oPc,SAVING_THROW_REFLEX));
        }
        if(NWNX_Creature_GetBaseSavingThrow(oFamiliar,SAVING_THROW_WILL)< NWNX_Creature_GetBaseSavingThrow(oPc,SAVING_THROW_WILL)){
            NWNX_Creature_SetBaseSavingThrow(oFamiliar,SAVING_THROW_WILL,NWNX_Creature_GetBaseSavingThrow(oPc,SAVING_THROW_WILL));
        }

        //3.5: For each skill in which either the master or the familiar has ranks, use either the normal skill ranks for an animal
        //     of that type or the master’s skill ranks, whichever are better. In either case, the familiar uses its own ability modifiers.
        //     Regardless of a familiar’s total skill modifiers, some skills may remain beyond the familiar’s ability to use.
        // I summon thee, power of loops! ~~
        int i;
        for(i = 1; i<=35; i++){
            //skills which are disabled
            if(i == 3 || i == 10 || i == 18 || i == 18 || i == 20 || i == 22 || i == 25 || i == 26 || i == 27 || i == 32){
                continue;
            }

            if(GetSkillRank(i,oFamiliar,TRUE) < GetSkillRank(i,oPc,TRUE)){
                NWNX_Creature_SetSkillRank(oFamiliar,i,GetSkillRank(i,oPc,TRUE));
            }
        }


        //3.5: The familiar has one-half the master’s total hit points (not including temporary hit points), rounded down, regardless of its actual Hit Dice.
        //Applying the HP as temp HP; setting HP per Level is currently broken
        int iMasterHP = GetMaxHitPoints(oPc);
        if(iMasterHP/2 > GetMaxHitPoints(oFamiliar)){
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints((iMasterHP/2) - GetMaxHitPoints(oFamiliar)), oFamiliar);
        }
        else{
            SetCurrentHitPoints(oFamiliar, iMasterHP/2);
        }

        //3.5: INT-Score gets adjusted and Familiar gets improved evasion, see https://www.d20srd.org/srd/classes/sorcererWizard.htm
        NWNX_Creature_SetRawAbilityScore(oFamiliar, ABILITY_INTELLIGENCE, ((iClassLevels+1)/2)+5);
        NWNX_Creature_AddFeat(oFamiliar,FEAT_IMPROVED_EVASION);

        //3.5: If the master is 11th level or higher, a familiar gains spell resistance equal to the master’s level + 5
        if(iClassLevels > 10){
            NWNX_Creature_SetSpellResistance(oFamiliar, iClassLevels +5);
        }


        if(sTag == "nw_fm_bat"){
            eFamiliarBuff = EffectSkillIncrease(6,3);
        }
        else if(sTag == "nw_fm_cat"){
            eFamiliarBuff = EffectSkillIncrease(8,3);
        }
        else if(sTag == "nw_fm_hawk"){
            eFamiliarBuff = EffectSkillIncrease(17,2);
        }
        else if(sTag == "nw_fm_liz"){
            eFamiliarBuff = EffectSkillIncrease(34,3);
        }
        else if(sTag == "nw_fm_owl"){
            eFamiliarBuff = EffectSkillIncrease(17,2);
        }
        else if(sTag == "nw_fm_rat"){
            eFamiliarBuff = EffectSavingThrowIncrease(SAVING_THROW_FORT,2);
        }
        else if(sTag == "nw_fm_rave"){
            eFamiliarBuff = EffectSkillIncrease(14,3);
        }
        else if(sTag == "nw_fm_vip"){
            eFamiliarBuff = EffectSkillIncrease(23,3);
        }
        else if(sTag == "nw_fm_frog"){
            eFamiliarBuff = EffectTemporaryHitpoints(3);
        }
        else if(sTag == "nw_fm_weas"){
            eFamiliarBuff = EffectSavingThrowIncrease(SAVING_THROW_REFLEX,2);
        }
        else if(sTag == "nw_fm_ferr"){
            eFamiliarBuff = EffectSavingThrowIncrease(SAVING_THROW_REFLEX,2);
        }
        else {SpeakString("Familiar not implemented:" + sTag );}

        eFamiliarBuff = SupernaturalEffect(eFamiliarBuff);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eFamiliarBuff,oPc);

    }
    else{SpeakString("No Animal Companion Found!");}


}
