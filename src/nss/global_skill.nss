#include "nwnx_events"
#include "nwnx_util"
#include "nwnx_webhook"

void main() {
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_TAUNT) {
        SendMessageToPC(OBJECT_SELF, "Euer Versuch zu provozieren zeigt keine Wirkung.");
        NWNX_Events_SkipEvent();
    }
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_ANIMAL_EMPATHY) {
        SendMessageToPC(OBJECT_SELF, "Euer Versuch ein Tier zu zähmen zeigt keine Wirkung.");
        NWNX_Events_SkipEvent();
    }
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_PICK_POCKET) {
        object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
        if (GetIsPC(oTarget)) {
          NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), "Pick pocket: " + GetPCPlayerName(OBJECT_SELF) + " - " + GetName(OBJECT_SELF) + " steals from " + GetPCPlayerName(oTarget) + " - " + GetName(oTarget), "Mintarn");
        }
    
    }
}
