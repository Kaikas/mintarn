#include "nwnx_events"

void main() {
    object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
    SendMessageToPC(OBJECT_SELF, "Ihr k�nnt " + GetName(oTarget) + " momentan nicht angreifen.");
    NWNX_Events_SkipEvent();
}

