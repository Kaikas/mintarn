#include "nwnx_events"
#include "nwnx_player"

// Setting the trap
void settrap(object oPc, object oTrap) {
    if (GetTag(oTrap) == "CRAFT_Stachelfalle") {
        CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, GetLocation(oPc), 2.0f, GetTag(oTrap), STANDARD_FACTION_COMMONER);
    } else if (GetTag(oTrap) == "CRAFT_Feuerfalle") {
        CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_FIRE, GetLocation(oPc), 2.0f, GetTag(oTrap), STANDARD_FACTION_COMMONER);
    } else if (GetTag(oTrap) == "CRAFT_Stromfalle") {
        CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_ELECTRICAL, GetLocation(oPc), 2.0f, GetTag(oTrap), STANDARD_FACTION_COMMONER);
    } else {
        CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, GetLocation(oPc), 2.0f, "CRAFT_Stachelfalle", STANDARD_FACTION_COMMONER);
    }
    // Play the trap sound
    PlaySound("gui_traparm");
    // Remove the trap from inventory
    DestroyObject(oTrap);
}

// Keep stealthed when placing traps
void main() {
    object oPc = OBJECT_SELF;
    object oTrap = StringToObject(NWNX_Events_GetEventData("TRAP_OBJECT_ID"));
    NWNX_Events_SkipEvent();
    //EnterTargetingMode(oPc, OBJECT_TYPE_ALL, MOUSECURSOR_DISARM);
    NWNX_Player_StartGuiTimingBar(oPc, 5.0, "");
    DelayCommand(5.0f, settrap(oPc, oTrap));
}
