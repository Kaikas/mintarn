#include "nwnx_events"

void main() {
    NWNX_Events_SkipEvent();
    SendMessageToPC(OBJECT_SELF, "Nope");
}
