#include "nwnx_events"
#include "nwnx_player"

// TODO: message to player how their skilcheck was put together

// Skill id of the skill used to set traps
const int SW_SKILL_SET_TRAP = 13;
const int SW_SKILL_DISABLE_TRAP = 9;
const int SW_FEAT_SKILL_MASTERY = 225;

// Get Trap SetDC
int GetTrapSetDC(string sTag) {
    int iTrapId = 0;
    if (sTag == "CRAFT_Blitzfalle1") iTrapId = 0;
    if (sTag == "CRAFT_Blitzfalle2") iTrapId = 1;
    if (sTag == "CRAFT_Blitzfalle3") iTrapId = 2;
    if (sTag == "CRAFT_Blitzfalle4") iTrapId = 3;
    if (sTag == "CRAFT_Blitzfalle5") iTrapId = 4;
    return StringToInt(Get2DAString("traps", "SetDC", iTrapId));
}

// Setting the trap
void SetTrap(object oPc, object oTrap, int iFaction) {
    // Determine trap script
    string sTrapScript = "";
    if (GetTag(oTrap) == "CRAFT_Blitzfalle1") sTrapScript = "falle_elektr1";
    if (GetTag(oTrap) == "CRAFT_Blitzfalle2") sTrapScript = "falle_elektr2";
    if (GetTag(oTrap) == "CRAFT_Blitzfalle3") sTrapScript = "falle_elektr3";
    if (GetTag(oTrap) == "CRAFT_Blitzfalle4") sTrapScript = "falle_elektr4";
    if (GetTag(oTrap) == "CRAFT_Blitzfalle5") sTrapScript = "falle_elektr5";

    // Create the trap
    CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, // doesn't matter
      GetLocation(oPc), // Player location
      2.0f, // Size of the trap
      GetTag(oTrap), //Tag of the placed trap
      iFaction, // Faction the trap belongs to
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
    
    // Check if another trap has already been placed to avoid trap stacking
    object oArea = GetArea(oPc);
    object oObject = GetFirstObjectInArea(oArea);
    int iTrapCloseBy = 0;
    while (GetIsObjectValid(oObject)) {
      if (GetStringLeft(GetResRef(oObject), 6) == "sw_fa_" && 
          GetDistanceBetweenLocations(GetLocation(oPc), GetLocation(oObject)) < 10.0) {
        SendMessageToPC(oPc, "Ihr könnt hier keine Falle stellen, es ist bereits eine an diesem Ort.");
        return;
      }
      oObject = GetNextObjectInArea(oArea);
    }
    
    // d20 for skillcheck
    int iRoll = d20();
    // If Ranger, Rogue or Assassin and not in combat take 20
    if ((GetLevelByClass(CLASS_TYPE_ROGUE, oPc) + 
        GetLevelByClass(CLASS_TYPE_ASSASSIN, oPc) +
        GetLevelByClass(CLASS_TYPE_RANGER, oPc) > 0 &&
        !GetIsInCombat(oPc)) || GetHasFeat(SW_FEAT_SKILL_MASTERY, oPc)) {
      iRoll = 20;
    }
    // Add modifiers
    int iSkillCheck = iRoll + GetHitDice(oPc);
    // Synergy with disable trap
    if (GetSkillRank(SW_SKILL_DISABLE_TRAP, oPc) > 4)
      iSkillCheck = iSkillCheck + 2;
    // Apply AC penalty for armour
    object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    int iAppearance = GetItemAppearance(oChest, 
      ITEM_APPR_TYPE_ARMOR_MODEL, 
      ITEM_APPR_ARMOR_MODEL_TORSO);
    int iAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearance));
    switch (iAC) {
      case 3:
        iSkillCheck = iSkillCheck - 1;
        break;
      case 4:
        iSkillCheck = iSkillCheck - 2;
        break;
      case 5:
        iSkillCheck = iSkillCheck - 5;
        break;
      case 6:
        iSkillCheck = iSkillCheck - 7;
        break;
      case 7:
        iSkillCheck = iSkillCheck - 7;
        break;
      case 8:
        iSkillCheck = iSkillCheck - 8;
        break;
      default:
        break;
    }
    // Apply AC penalty for shield
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPc);
    switch (GetBaseItemType(oShield)) {
      case BASE_ITEM_SMALLSHIELD:
        iSkillCheck = iSkillCheck - 1;
        break;
      case BASE_ITEM_LARGESHIELD:
        iSkillCheck = iSkillCheck - 2;
        break;
      case BASE_ITEM_TOWERSHIELD:
        iSkillCheck = iSkillCheck - 10;
        break;
      default:
        break;
    }

    // Get Trap DC
    int iDC = GetTrapSetDC(GetTag(oTrap));

    // Check if the skillcheck was successful
    if (iSkillCheck >= iDC) {
      // Start a timer progress bar for 5 seconds
      NWNX_Player_StartGuiTimingBar(oPc, 5.0, "");
      // Block player and play emote
      AssignCommand(oPc, ClearAllActions());
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPc, 5.0f);
      AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0f));

      // Place the trap at the current location
      DelayCommand(5.0f, SetTrap(oPc, oTrap, STANDARD_FACTION_COMMONER));
    } else {
      // Spectacular Failure
      if (iDC - iSkillCheck > 9 && !GetHasFeat(SW_FEAT_SKILL_MASTERY, oPc)) {
        SetTrap(oPc, oTrap, STANDARD_FACTION_HOSTILE);
      }
    }
}
