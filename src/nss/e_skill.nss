#include "nwnx_events"
#include "nwnx_util"
#include "nwnx_webhook"

// Animal Empathy
void AnimalEmpathy(object oPc, object oTarget) {
    // Duration of the dominated effect. 10 Minutes + 
    float fDuration = IntToFloat(600 + GetHitDice(oPc));
    effect eDom = EffectDominated();

    // Needs to be Ranger or Druid
    if (!(GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF) > 0 || 
          GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF))) {
      return;
    }
    // Never PCs due to EffectDominated() being weird.
    if(GetIsPC(oTarget)) return;

    // Only animals or beasts
    int nRacialType = GetRacialType(oTarget);
    if(nRacialType != RACIAL_TYPE_ANIMAL && nRacialType != RACIAL_TYPE_BEAST && nRacialType != RACIAL_TYPE_MAGICAL_BEAST) return;

    // If create is a companion we do not posess it
    if (GetMaster(oTarget) != OBJECT_INVALID) return;
    
    // Calculate DC
    int nDC = 15;
    if(nRacialType != RACIAL_TYPE_ANIMAL) nDC = 19;
    nDC += GetHitDice(oTarget);

    // Roll - take into account take 20
    int nRoll = 20 + GetLevelByClass(CLASS_TYPE_DRUID, oPc) + GetLevelByClass(CLASS_TYPE_RANGER, oPc) + GetAbilityScore(oPc, ABILITY_CHARISMA);
    if(GetIsInCombat(oPc)) nRoll = d20() + GetLevelByClass(CLASS_TYPE_DRUID, oPc) + GetLevelByClass(CLASS_TYPE_RANGER, oPc) + GetAbilityScore(oPc, ABILITY_CHARISMA);

    // Need to know failure so custom roll (else use GetIsSkillSuccessful).
    if(nRoll >= nDC)
    {
        // Success feedback + domainate
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDom, oTarget, fDuration);
    }
    else if(nRoll < nDC - 5)
    {
        // Critical failure set as enemy
        SetIsTemporaryEnemy(oPc, oTarget, FALSE);
        // Combat round
        DelayCommand(0.5, ExecuteScript(GetEventScript(oTarget, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND), oTarget));
    }
    else
    {
        // Failure feedback
    }
}

void main() {
    // Handles the Taunt skill which is deactivated.
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_TAUNT) {
        SendMessageToPC(OBJECT_SELF, "Euer Versuch zu provozieren zeigt keine Wirkung.");
        NWNX_Events_SkipEvent();
    }
    // Handles animal empathy. This is the engine skill to charme an animal.
    // This can only be used by Druids and Rangers.
    //
    // The skill Animal Handling is the general skill that all classes can use for
    // working with animals.
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_ANIMAL_EMPATHY) {
      AnimalEmpathy(OBJECT_SELF, StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID")));
      NWNX_Events_SkipEvent();
    }
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_PICK_POCKET) {
        object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
        if (GetIsPC(oTarget)) {
          NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), "Pick pocket: " + GetPCPlayerName(OBJECT_SELF) + " - " + GetName(OBJECT_SELF) + " steals from " + GetPCPlayerName(oTarget) + " - " + GetName(oTarget), "Mintarn");
        }
    
    }
}
