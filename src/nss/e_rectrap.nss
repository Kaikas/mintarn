#include "nwnx_events"


// Recover a trap
void main() {
    object oPc = OBJECT_SELF;
    NWNX_Events_SkipEvent();
    string sTag = GetTag(StringToObject(NWNX_Events_GetEventData("TRAP_OBJECT_ID")));
    SendMessageToPC(oPc, sTag);
    DestroyObject(StringToObject(NWNX_Events_GetEventData("TRAP_OBJECT_ID")));
}
