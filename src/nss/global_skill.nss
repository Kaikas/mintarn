#include "nwnx_events"

void main() {
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_TAUNT) {
        SendMessageToPC(OBJECT_SELF, "Euer Versuch zu provozieren zeigt keine Wirkung.");
        NWNX_Events_SkipEvent();
    }
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_ANIMAL_EMPATHY) {
        SendMessageToPC(OBJECT_SELF, "Euer Versuch ein Tier zu zähmen zeigt keine Wirkung.");
        NWNX_Events_SkipEvent();
    }
}
