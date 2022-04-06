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
<<<<<<< Updated upstream
        int i;
=======
        int i = 1;
>>>>>>> Stashed changes
        for(i = 1; i <= 1+iDruidBonus; i++){
           LevelUpHenchman(oCompanion);
        }
        NWNX_Creature_SetLevelByPosition(oCompanion, 0, 2+(iDruidBonus*2));
        NWNX_Creature_SetSkillRank(oCompanion, SKILL_LISTEN, 3+iDruidBonus);
        NWNX_Creature_SetSkillRank(oCompanion, SKILL_SPOT, 3+iDruidBonus);
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_CONSTITUTION, (iDruidBonus/2)-(iDruidBonus/4));
        if (((GetLevelByClass(CLASS_TYPE_DRUID, oPc) + (GetLevelByClass(CLASS_TYPE_RANGER, oPc)) > 3) && (iDruidBonus < 1 ))) {
           NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_STRENGTH, -6);
        }

        //Natural Armor Adjustment: An improvement to the animal companion’s existing natural armor bonus.
        NWNX_Creature_SetBaseAC(oCompanion, NWNX_Creature_GetBaseAC(oCompanion) + iDruidBonus*2);

        //Str/Dex Adjustment: Bonus to the animal companion’s Strength and Dexterity scores.
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_STRENGTH, iDruidBonus);
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_DEXTERITY, iDruidBonus);

<<<<<<< Updated upstream
=======
        //An animal companion gains ability scores for bonus HD as normal for advancing a monster’s Hit Dice.
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_STRENGTH, (GetHitDice(oCompanion)/4)*(-1)); // Remove NWN ability bonus
        NWNX_Creature_ModifyRawAbilityScore(oCompanion, ABILITY_CONSTITUTION, (GetHitDice(oCompanion)/4));  // Ability bonus from advancing every 4 levels

>>>>>>> Stashed changes
        //A druid’s animal companion is superior to a normal animal of its kind and has special powers and gains additional feats for bonus HD as normal.
        if (iDruidBonus >= 1 ) {
           NWNX_Creature_AddFeat(oCompanion, FEAT_EVASION); // Special power from level 3 druid
           NWNX_Creature_RemoveFeatByLevel(oCompanion, FEAT_CLEAVE,3); // Remove NWN feat selection
           NWNX_Creature_AddFeatByLevel(oCompanion, FEAT_ALERTNESS,3); // General feat for advancing to 3 HD
        }
        if (iDruidBonus >= 2 ) {
           NWNX_Creature_AddFeat(oCompanion, FEAT_HARDINESS_VERSUS_ENCHANTMENTS); // Special power from level 6 druid
           NWNX_Creature_RemoveFeatByLevel(oCompanion, FEAT_POWER_ATTACK,6); // Remove NWN feat selection
           NWNX_Creature_AddFeatByLevel(oCompanion, FEAT_TOUGHNESS,6); //General feat for advancing to 6 HD
        }
        if (iDruidBonus >= 4 ) {
           NWNX_Creature_RemoveFeatByLevel(oCompanion, FEAT_DODGE,9); // Remove NWN feat selection
           NWNX_Creature_AddFeatByLevel(oCompanion, FEAT_WEAPON_SPECIALIZATION_CREATURE,9); // General feat for advancing to 9 HD
        }
        if (iDruidBonus >= 5 ) {
           NWNX_Creature_AddFeat(oCompanion, FEAT_IMPROVED_EVASION); // Special power from level 15 druid
           NWNX_Creature_AddFeatByLevel(oCompanion, FEAT_BLIND_FIGHT,12); // General feat for advancing to 12 HD
        }

    }
    else{SpeakString("No Animal Companion Found!");}
}