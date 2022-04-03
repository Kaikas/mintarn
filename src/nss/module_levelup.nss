#include "nwnx_creature"

void SetMaxHP(object oPlayer) {
    if(GetIsPC(oPlayer)){
    int nLevel, nCharacterLevel = GetHitDice(oPlayer);
    AssignCommand(oPlayer, ActionSpeakString("LevelingUp"));
    for(nLevel = 1; nLevel <= nCharacterLevel; nLevel++)
    {
        int nMaxHP = StringToInt(Get2DAString("classes", "HitDie", NWNX_Creature_GetClassByLevel(oPlayer, nLevel)));

        //if (GetHasFeat(FEAT_TOUGHNESS, oPlayer)) {
        //    NWNX_Creature_SetMaxHitPointsByLevel(oPlayer, nLevel, nMaxHP + 1);
        //} else {
        //    NWNX_Creature_SetMaxHitPointsByLevel(oPlayer, nLevel, nMaxHP);
        //}
        NWNX_Creature_SetMaxHitPointsByLevel(oPlayer, nLevel, nMaxHP);
    }
} }

void main() {
    object oPc = GetPCLevellingUp();
    SetMaxHP(oPc);
}
