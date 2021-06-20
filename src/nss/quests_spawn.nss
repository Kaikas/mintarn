#include "global_helper"

// Creates a goblin at the waypoint when the player enters
void main() {
    object oPc = GetEnteringObject();
    if (GetIsPC(oPc)) {
        CreateObject(OBJECT_TYPE_CREATURE, "goblin", GetLocation(GetWaypointByTag("SPAWN_Goblin")));
    }
}
