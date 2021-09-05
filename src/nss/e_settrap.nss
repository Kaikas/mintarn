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

    if (sTag == "CRAFT_Feuerfalle1") iTrapId = 5;
    if (sTag == "CRAFT_Feuerfalle2") iTrapId = 6;
    if (sTag == "CRAFT_Feuerfalle3") iTrapId = 7;
    if (sTag == "CRAFT_Feuerfalle4") iTrapId = 8;
    if (sTag == "CRAFT_Feuerfalle5") iTrapId = 9;

    if (sTag == "CRAFT_Frostfalle1") iTrapId = 10;
    if (sTag == "CRAFT_Frostfalle2") iTrapId = 11;
    if (sTag == "CRAFT_Frostfalle3") iTrapId = 12;
    if (sTag == "CRAFT_Frostfalle4") iTrapId = 13;
    if (sTag == "CRAFT_Frostfalle5") iTrapId = 14;

    if (sTag == "CRAFT_Saurefalle1") iTrapId = 15;
    if (sTag == "CRAFT_Saurefalle2") iTrapId = 16;
    if (sTag == "CRAFT_Saurefalle3") iTrapId = 17;
    if (sTag == "CRAFT_Saurefalle4") iTrapId = 18;
    if (sTag == "CRAFT_Saurefalle5") iTrapId = 19;

    if (sTag == "CRAFT_Schallfalle1") iTrapId = 20;
    if (sTag == "CRAFT_Schallfalle2") iTrapId = 21;
    if (sTag == "CRAFT_Schallfalle3") iTrapId = 22;
    if (sTag == "CRAFT_Schallfalle4") iTrapId = 23;
    if (sTag == "CRAFT_Schallfalle5") iTrapId = 24;

    // TODO: Missing due to merge
    if (sTag == "CRAFT_Gift1") iTrapId = 25;
    if (sTag == "CRAFT_Gift2") iTrapId = 26;
    if (sTag == "CRAFT_Gift3") iTrapId = 27;
    if (sTag == "CRAFT_Gift4") iTrapId = 28;
    if (sTag == "CRAFT_Gift5") iTrapId = 29;

    if (sTag == "CRAFT_Verstrickungsfalle1") iTrapId = 30;
    if (sTag == "CRAFT_Verstrickungsfalle2") iTrapId = 31;
    if (sTag == "CRAFT_Verstrickungsfalle3") iTrapId = 32;
    if (sTag == "CRAFT_Verstrickungsfalle4") iTrapId = 33;
    if (sTag == "CRAFT_Verstrickungsfalle5") iTrapId = 34;

    if (sTag == "CRAFT_Heilfalle1") iTrapId = 35;
    if (sTag == "CRAFT_Heilfalle2") iTrapId = 36;
    if (sTag == "CRAFT_Heilfalle3") iTrapId = 37;
    if (sTag == "CRAFT_Heilfalle4") iTrapId = 38;
    if (sTag == "CRAFT_Heilfalle5") iTrapId = 39;

    if (sTag == "CRAFT_Negativfalle1") iTrapId = 40;
    if (sTag == "CRAFT_Negativfalle2") iTrapId = 41;
    if (sTag == "CRAFT_Negativfalle3") iTrapId = 42;
    if (sTag == "CRAFT_Negativfalle4") iTrapId = 43;
    if (sTag == "CRAFT_Negativfalle5") iTrapId = 44;

    if (sTag == "CRAFT_Stachelfalle1") iTrapId = 45;
    if (sTag == "CRAFT_Stachelfalle2") iTrapId = 46;
    if (sTag == "CRAFT_Stachelfalle3") iTrapId = 47;
    if (sTag == "CRAFT_Stachelfalle4") iTrapId = 48;
    if (sTag == "CRAFT_Stachelfalle5") iTrapId = 49;

    if (sTag == "CRAFT_Klingenfalle1") iTrapId = 50;
    if (sTag == "CRAFT_Klingenfalle2") iTrapId = 51;
    if (sTag == "CRAFT_Klingenfalle3") iTrapId = 52;
    if (sTag == "CRAFT_Klingenfalle4") iTrapId = 53;
    if (sTag == "CRAFT_Klingenfalle5") iTrapId = 54;

    // TODO: Missing due to merge
    if (sTag == "CRAFT_Stumpf1") iTrapId = 55;
    if (sTag == "CRAFT_Stumpf2") iTrapId = 56;
    if (sTag == "CRAFT_Stumpf3") iTrapId = 57;
    if (sTag == "CRAFT_Stumpf4") iTrapId = 58;
    if (sTag == "CRAFT_Stumpf5") iTrapId = 59;

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

    if (GetTag(oTrap) == "CRAFT_Feuerfalle1") sTrapScript = "falle_feuer1";
    if (GetTag(oTrap) == "CRAFT_Feuerfalle2") sTrapScript = "falle_feuer2";
    if (GetTag(oTrap) == "CRAFT_Feuerfalle3") sTrapScript = "falle_feuer3";
    if (GetTag(oTrap) == "CRAFT_Feuerfalle4") sTrapScript = "falle_feuer4";
    if (GetTag(oTrap) == "CRAFT_Feuerfalle5") sTrapScript = "falle_feuer5";

    if (GetTag(oTrap) == "CRAFT_Frostfalle1") sTrapScript = "falle_frost1";
    if (GetTag(oTrap) == "CRAFT_Frostfalle2") sTrapScript = "falle_frost2";
    if (GetTag(oTrap) == "CRAFT_Frostfalle3") sTrapScript = "falle_frost3";
    if (GetTag(oTrap) == "CRAFT_Frostfalle4") sTrapScript = "falle_frost4";
    if (GetTag(oTrap) == "CRAFT_Frostfalle5") sTrapScript = "falle_frost5";

    if (GetTag(oTrap) == "CRAFT_Saurefalle1") sTrapScript = "falle_saure1";
    if (GetTag(oTrap) == "CRAFT_Saurefalle2") sTrapScript = "falle_saure2";
    if (GetTag(oTrap) == "CRAFT_Saurefalle3") sTrapScript = "falle_saure3";
    if (GetTag(oTrap) == "CRAFT_Saurefalle4") sTrapScript = "falle_saure4";
    if (GetTag(oTrap) == "CRAFT_Saurefalle5") sTrapScript = "falle_saure5";

    if (GetTag(oTrap) == "CRAFT_Schallfalle1") sTrapScript = "falle_schall1";
    if (GetTag(oTrap) == "CRAFT_Schallfalle2") sTrapScript = "falle_schall2";
    if (GetTag(oTrap) == "CRAFT_Schallfalle3") sTrapScript = "falle_schall3";
    if (GetTag(oTrap) == "CRAFT_Schallfalle4") sTrapScript = "falle_schall4";
    if (GetTag(oTrap) == "CRAFT_Schallfalle5") sTrapScript = "falle_schall5";

    if (GetTag(oTrap) == "CRAFT_Gift1") sTrapScript = "falle_gift1";
    if (GetTag(oTrap) == "CRAFT_Gift2") sTrapScript = "falle_gift2";
    if (GetTag(oTrap) == "CRAFT_Gift3") sTrapScript = "falle_gift3";
    if (GetTag(oTrap) == "CRAFT_Gift4") sTrapScript = "falle_gift4";
    if (GetTag(oTrap) == "CRAFT_Gift5") sTrapScript = "falle_gift5";

    if (GetTag(oTrap) == "CRAFT_Verstrickungsfalle1") sTrapScript = "falle_verstricken1";
    if (GetTag(oTrap) == "CRAFT_Verstrickungsfalle2") sTrapScript = "falle_verstricken2";
    if (GetTag(oTrap) == "CRAFT_Verstrickungsfalle3") sTrapScript = "falle_verstricken3";
    if (GetTag(oTrap) == "CRAFT_Verstrickungsfalle4") sTrapScript = "falle_verstricken4";
    if (GetTag(oTrap) == "CRAFT_Verstrickungsfalle5") sTrapScript = "falle_verstricken5";

    if (GetTag(oTrap) == "CRAFT_Heilfalle1") sTrapScript = "falle_heilig1";
    if (GetTag(oTrap) == "CRAFT_Heilfalle2") sTrapScript = "falle_heilig2";
    if (GetTag(oTrap) == "CRAFT_Heilfalle3") sTrapScript = "falle_heilig3";
    if (GetTag(oTrap) == "CRAFT_Heilfalle4") sTrapScript = "falle_heilig4";
    if (GetTag(oTrap) == "CRAFT_Heilfalle5") sTrapScript = "falle_heilig5";

    if (GetTag(oTrap) == "CRAFT_Negativfalle1") sTrapScript = "falle_negativ1";
    if (GetTag(oTrap) == "CRAFT_Negativfalle2") sTrapScript = "falle_negativ1";
    if (GetTag(oTrap) == "CRAFT_Negativfalle3") sTrapScript = "falle_negativ1";
    if (GetTag(oTrap) == "CRAFT_Negativfalle4") sTrapScript = "falle_negativ1";
    if (GetTag(oTrap) == "CRAFT_Negativfalle5") sTrapScript = "falle_negativ1";

    if (GetTag(oTrap) == "CRAFT_Stachelfalle1") sTrapScript = "falle_stacheln1";
    if (GetTag(oTrap) == "CRAFT_Stachelfalle2") sTrapScript = "falle_stacheln2";
    if (GetTag(oTrap) == "CRAFT_Stachelfalle3") sTrapScript = "falle_stacheln3";
    if (GetTag(oTrap) == "CRAFT_Stachelfalle4") sTrapScript = "falle_stacheln4";
    if (GetTag(oTrap) == "CRAFT_Stachelfalle5") sTrapScript = "falle_stacheln5";

    if (GetTag(oTrap) == "CRAFT_Klingenfalle1") sTrapScript = "falle_klinge1";
    if (GetTag(oTrap) == "CRAFT_Klingenfalle2") sTrapScript = "falle_klinge2";
    if (GetTag(oTrap) == "CRAFT_Klingenfalle3") sTrapScript = "falle_klinge3";
    if (GetTag(oTrap) == "CRAFT_Klingenfalle4") sTrapScript = "falle_klinge4";
    if (GetTag(oTrap) == "CRAFT_Klingenfalle5") sTrapScript = "falle_klinge5";

    if (GetTag(oTrap) == "CRAFT_Stumpf1") sTrapScript = "falle_stumpf1";
    if (GetTag(oTrap) == "CRAFT_Stumpf2") sTrapScript = "falle_stumpf2";
    if (GetTag(oTrap) == "CRAFT_Stumpf3") sTrapScript = "falle_stumpf3";
    if (GetTag(oTrap) == "CRAFT_Stumpf4") sTrapScript = "falle_stumpf4";
    if (GetTag(oTrap) == "CRAFT_Stumpf5") sTrapScript = "falle_stumpf5";

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
    int iSkillCheck = GetHitDice(oPc);
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

    SendMessageToPC(oPc, "Falle stellen: Ihr würfelt " + IntToString(iRoll) + " + " + IntToString(iSkillCheck) + ".");
    SendMessageToPC(oPc, "Die Falle hatten eine Schwierigkeit von " + IntToString(iDC) + ".");
    // Check if the skillcheck was successful
    if (iSkillCheck + iRoll >= iDC) {
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
      if (iDC - iSkillCheck + iRoll > 15 && !GetHasFeat(SW_FEAT_SKILL_MASTERY, oPc)) {
        SetTrap(oPc, oTrap, STANDARD_FACTION_HOSTILE);
        SendMessageToPC(oPc, "Kritischer Misserfolg: Die Falle ging nach hinten los.");
      } else {
        SendMessageToPC(oPc, "Misserfolg: Die Falle ist kaputt.");
      }
    }
}
