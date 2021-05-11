#include "nwnx_events"
#include "nwnx_player"

// Setting the trap
void settrap(object oPc, object oTrap, int ifaction) {
    // Check if another trap has already been placed to avoid trap stacking

    // D&D 5e trap logic 


    // Determine trap script
    string sTrapScript = "";
    switch (GetTag(oTrap)) {
      // Blitzfalle
      case "CRAFT_Blitzfalle1":
        sTrapScript = "falle_elektr1";
        break;
      case "CRAFT_Blitzfalle2":
        sTrapScript = "falle_elektr2";
        break;
      case "CRAFT_Blitzfalle3":
        sTrapScript = "falle_elektr3";
        break;
      case "CRAFT_Blitzfalle4":
        sTrapScript = "falle_elektr4";
        break;
      case "CRAFT_Blitzfalle5":
        sTrapScript = "falle_elektr5";
        break;
      default:
        break;
    }
    // Create the trap
    CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, // doesn't matter
      GetLocation(oPc), // Player location
      2.0f, // Size of the trap
      GetTag(oTrap), //Tag of the placed trap
      STANDARD_FACTION_COMMONER, // Faction the trap belongs to
      "", // Disarm script - hooked, doesn't matter
      sTrapScript); // The script being run
    // Play the trap sound
    PlaySound("gui_traparm");
    // Remove the trap from inventory
    DestroyObject(oTrap);
}

// Set trap script
void main() {
    // The player
    object oPc = OBJECT_SELF;
    // The trap object as used from the inventory
    object oTrap = StringToObject(NWNX_Events_GetEventData("TRAP_OBJECT_ID"));
    // Skip the default event
    NWNX_Events_SkipEvent();
    
    // Start a timer progress bar for 5 seconds
    NWNX_Player_StartGuiTimingBar(oPc, 5.0, "");
    // Block player and play emote
    AssignCommand(oPc, ClearAllActions());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPc, 5.0f);
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0f));

    // Place the trap at the current location
    //DelayCommand(5.0f, settrap(oPc, oTrap));
}
