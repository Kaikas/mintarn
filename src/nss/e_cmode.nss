#include "nwnx_events"

void main() {
    if (StringToInt(NWNX_Events_GetEventData("COMBAT_MODE_ID")) == 1) {
        SendMessageToPC(OBJECT_SELF, "Ihr k�nnt nicht parrieren.");
        NWNX_Events_SkipEvent();
    }
}

