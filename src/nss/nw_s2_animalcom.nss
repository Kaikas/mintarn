//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:://////////////////////////////////////////////
/*
    This spell summons a Druid/Ranger animal companion
    and gives them level-appropriate score bonuses
*/
//:://////////////////////////////////////////////
//:: By Victorious & Yuuki
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"

//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:://////////////////////////////////////////////
/*
    This spell summons a Druid/Ranger animal companion
    and gives them level-appropriate score bonuses
*/
//:://////////////////////////////////////////////
//:: By Victorious & Yuuki
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"

void main()
{
    object oPc = OBJECT_SELF;
    object oCompanion = OBJECT_INVALID;

    SummonAnimalCompanion();

    oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);

    if(oCompanion != OBJECT_INVALID){
        //The druid’s class levels stack with levels of any other classes that are entitled to an animal companion for the purpose of determining the companion’s bonus. Except that the ranger’s effective druid level is one-half his ranger level
        int iDruidBonus = (GetLevelByClass(CLASS_TYPE_DRUID, oPc) + (GetLevelByClass(CLASS_TYPE_RANGER, oPc)/2))/3;

        //Bonus HD: Extra eight-sided (d8) Hit Dice, each of which gains a Constitution modifier, as normal. An animal companion gains additional skill points, feats and ability scores for bonus HD as normal for advancing a monster’s Hit Dice.
        int i;
        for(i = 1; i <= iDruidBonus*2; i++){
           LevelUpHenchman(oCompanion);
        }

        for(i=1;i<=GetHitDice(oCompanion); i++){
         NWNX_Creature_SetMaxHitPointsByLevel(oCompanion, i, 2);
        }
        SpeakString("2 HP per Level: " + IntToString(GetCurrentHitPoints(oCompanion)));

        for(i=1;i<=GetHitDice(oCompanion); i++){
         NWNX_Creature_SetMaxHitPointsByLevel(oCompanion, i, 3);
        }
        SpeakString("3 HP per Level: " + IntToString(GetCurrentHitPoints(oCompanion)));

        for(i=1;i<=GetHitDice(oCompanion); i++){
         NWNX_Creature_SetMaxHitPointsByLevel(oCompanion, i, 4+(i%2));
        }
        SpeakString("4+i%2 HP per Level: " + IntToString(GetCurrentHitPoints(oCompanion)));

        NWNX_Creature_SetSkillRank(oCompanion, SKILL_LISTEN, 5+iDruidBonus);
        NWNX_Creature_SetSkillRank(oCompanion, SKILL_SPOT, 5+iDruidBonus);

        //Natural Armor Adjustment: An improvement to the animal companion’s existing natural armor bonus.
        NWNX_Creature_SetBaseAC(oCompanion, NWNX_Creature_GetBaseAC(oCompanion) + iDruidBonus*2);

        //Str/Dex Adjustment: Bonus to the animal companion’s Strength and Dexterity scores.
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_STRENGTH, iDruidBonus);
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_DEXTERITY, iDruidBonus);

    }
    else{SpeakString("No Animal Companion Found!");}
}
