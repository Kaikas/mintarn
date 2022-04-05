//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:://////////////////////////////////////////////
/*
    This spell summons a Druid/Ranger animal companion
    and gives them level-appropriate score bonuses to align more closely,
    or as-close-as-possible, with DnD 3.5
*/
//:://////////////////////////////////////////////
//:: By Victorious & Yuuki
//:://////////////////////////////////////////////

#include "nwnx_creature"

void main()
{
    object oPc = OBJECT_SELF;
    object oCompanion = OBJECT_INVALID;

    SummonAnimalCompanion();

    oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);

    if(oCompanion != OBJECT_INVALID){
        //3.5:
        //The druid’s class levels stack with levels of any other classes that are entitled
        //to an animal companion for the purpose of determining the companion’s bonus.
        //Except that the ranger’s effective druid level is one-half his ranger level
        int iDruidBonus = (GetLevelByClass(CLASS_TYPE_DRUID, oPc) + (GetLevelByClass(CLASS_TYPE_RANGER, oPc)/2))/3;

        //3.5:
        //Bonus HD: Extra eight-sided (d8) Hit Dice, each of which gains a Constitution modifier, as normal.
        //An animal companion gains additional skill points, feats and ability scores for bonus HD
        //as normal for advancing a monster’s Hit Dice.

        int i;
        for(i = 1; i <= 1+iDruidBonus; i++){
           LevelUpHenchman(oCompanion);
        }

        //HACK: NWNX_Creature_SetHitPointsByLevel does nothing right now.
        //Setting each other level via SetLevelByPosition gives them 0 HP,
        //which almost-averages the HP to the 4.5 average we wanted.
        NWNX_Creature_SetLevelByPosition(oCompanion, 0, 2+(iDruidBonus*2));

        NWNX_Creature_SetSkillRank(oCompanion, SKILL_LISTEN, 3+iDruidBonus);
        NWNX_Creature_SetSkillRank(oCompanion, SKILL_SPOT, 3+iDruidBonus);

        //Reducing strength on those that are summoned by rangers,
        //since NWN forces the usage of <animal>_<level> templates. Those are measured on Druids.
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_CONSTITUTION, (iDruidBonus/2)-(iDruidBonus/4));
        if (((GetLevelByClass(CLASS_TYPE_DRUID, oPc) + (GetLevelByClass(CLASS_TYPE_RANGER, oPc)) > 3) && (iDruidBonus < 1 ))) {
           NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_STRENGTH, -6);
        }

        //3.5:
        //Natural Armor Adjustment: An improvement to the animal companion’s existing natural armor bonus.
        NWNX_Creature_SetBaseAC(oCompanion, NWNX_Creature_GetBaseAC(oCompanion) + iDruidBonus*2);

        //3.5:
        //Str/Dex Adjustment: Bonus to the animal companion’s Strength and Dexterity scores.
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_STRENGTH, iDruidBonus);
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_DEXTERITY, iDruidBonus);

    }
    else{SpeakString("No Animal Companion Found!");}
}
