#include "nwnx_events"

void main() {
    object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
    if (StringToInt(NWNX_Events_GetEventData("ATTITUDE")) == 0 && GetLocalInt(oTarget, "pvp") == 0) {
        SendMessageToPC(OBJECT_SELF, "Eine Anfrage wurde dem Spieler von " + GetName(oTarget) + " gestellt.");
        SendMessageToPC(oTarget, GetName(OBJECT_SELF) + " hat euch eine Anfrage auf ein Duell gestellt. Tippt /pvp um dies zuzulassen.");
        NWNX_Events_SkipEvent();
    }
}

