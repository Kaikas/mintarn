#include "nwnx_sql"
#include "nwnx_events"

void main() {
    NWNX_Events_SkipEvent();
    SendMessageToPlayer(OBJECT_SELF, "Nope");
}
