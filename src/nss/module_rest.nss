#include "global_helper"
#include "nwnx_time"
#include "nwnx_sql"
#include "nwnx_player"
#include "x0_i0_match"

// Zählt wieviel Nahrung ein Spieler im Inventar hat
int CountFood(object oPc) {
    int iCount = 0;
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID) {
        if (GetTag(oItem) == "CRAFT_Braten" ||
            GetTag(oItem) == "CRAFT_Pilzragout" ||
            GetTag(oItem) == "CRAFT_Fischeintopf") {
            iCount = iCount + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return iCount;
}

// Zählt wieviel Gute Nahrung ein Spieler im Inventar hat
int CountGoodFood(object oPc) {
    int iCount = 0;
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID) {
        if (GetTag(oItem) == "CRAFT_Elfenbrot" ||
            GetTag(oItem) == "CRAFT_Mondscheinmuffin") {
            iCount = iCount + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return iCount;
}

// Entfernt Nahrung aus dem Inventar beim Rasten
void DeleteFood(object oPc) {
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID) {
        if (GetTag(oItem) == "CRAFT_Braten" ||
            GetTag(oItem) == "CRAFT_Pilzragout" ||
            GetTag(oItem) == "CRAFT_Fischeintopf") {
            if (GetItemStackSize(oItem) < 2) {
                DestroyObject(oItem);
            } else {
                SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            }
            return;
        }
        oItem = GetNextItemInInventory(oPc);
    }
}

// Entfernt Gute Nahrung aus dem Inventar beim Rasten
void DeleteGoodFood(object oPc) {
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID) {
        if (GetTag(oItem) == "CRAFT_Elfenbrot" ||
            GetTag(oItem) == "CRAFT_Mondscheinmuffin") {
            if (GetItemStackSize(oItem) < 2) {
                DestroyObject(oItem);
            } else {
                SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            }
            return;
        }
        oItem = GetNextItemInInventory(oPc);
    }
}

// Heilt pets
void healPets(object oPc) {
    string sQuery = "UPDATE Pets SET health = ? WHERE name=? AND charname=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, "-128");
        NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(2, GetName(oPc));
        NWNX_SQL_ExecutePreparedQuery();
    }
}

// Starts rest conversation
void RestConversation(object oPc) {
    AssignCommand(oPc, ClearAllActions());
    SetLocalInt(oPc, "rast", 0);
    DelayCommand(0.0, ExecuteScript("rest_startc", oPc));
}

// Start rest conversation without short rest
void RestConversationNoShort(object oPc) {
    AssignCommand(oPc, ClearAllActions());
    SetLocalInt(oPc, "rast", 0);
    DelayCommand(0.0, ExecuteScript("rest_startc2", oPc));
}

// Full Rest
void RestFull(object oPc) {
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    string sQuery = "SELECT rest FROM Users WHERE name=? AND charname=?";
    int iTimeSinceLastRest;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_ExecutePreparedQuery();
        NWNX_SQL_ReadNextRow();
        iTimeSinceLastRest = NWNX_Time_GetTimeStamp() - StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    }
    if (CountFood(oPc) == 0) {
        SendMessageToPC(oPc, "Ihr habt nicht genug Nahrung um zu Rasten!");
        AssignCommand(oPc, ClearAllActions());
    } else {
        if (iTimeSinceLastRest < 14400) {
            SendMessageToPC(oPc, "Ihr müsst noch " +
                IntToString((1 + (14400 - iTimeSinceLastRest) / 60) / 60) +
                " Stunden und " +
                IntToString((1 + (14400 - iTimeSinceLastRest) / 60) % 60) +
                " Minuten warten bis ihr erneut rasten könnt!");
            AssignCommand(oPc, ClearAllActions());
        } else {
            sQuery = "UPDATE Users SET rest=? WHERE name=? AND charname=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, IntToString(NWNX_Time_GetTimeStamp()));
                NWNX_SQL_PreparedString(1, sAccountName);
                NWNX_SQL_PreparedString(2, sName);
                NWNX_SQL_ExecutePreparedQuery();
            }
            // Refresh short rest
            SetLocalInt(oPc, "rast_short", 0);
            DeleteFood(oPc);
            SetLocalInt(oPc, "DYING_POINTS", 0);
            SetLocalInt(oPc, "LIVING_POINTS", 0);
            healPets(oPc);
        }
    }
    SetLocalInt(oPc, "rast", 0);
}

// Short rest
void RestShort(object oPc) {
    if (CountGoodFood(oPc) > 0) {
        SendMessageToPC(oPc, "Ihr habt hervorragende Nahrung dabei! Eure Rast ist erholsamer.");
        DeleteGoodFood(oPc);
        AssignCommand(oPc, ClearAllActions());
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 5.0));
        NWNX_Player_StartGuiTimingBar(oPc, 5.0);
        effect eRegen = EffectRegenerate(GetMaxHitPoints(oPc) / 5 + 2, 1.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPc, 5.0);
        SetLocalInt(oPc, "rast", 0);
        SetLocalInt(oPc, "rast_short", GetLocalInt(oPc, "rast_short") + 1);
    } else {
        if (CountFood(oPc) == 0) {
            SendMessageToPC(oPc, "Ihr habt nicht genug Nahrung um zu Rasten!");
            AssignCommand(oPc, ClearAllActions());
        } else {
            DeleteFood(oPc);
            AssignCommand(oPc, ClearAllActions());
            AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 5.0));
            NWNX_Player_StartGuiTimingBar(oPc, 5.0);
            effect eRegen = EffectRegenerate(GetMaxHitPoints(oPc) / 10 + 2, 1.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPc, 5.0);
            SetLocalInt(oPc, "rast", 0);
            SetLocalInt(oPc, "rast_short", GetLocalInt(oPc, "rast_short") + 1);
        }
    }
    SetLocalInt(oPc, "rast", 0);
}


// Rastsystem
void main() {
    object oPc = GetLastPCRested();
    int iRestType = GetLastRestEventType();
    string sQuery;
    if (GetHasEffect(EFFECT_TYPE_NEGATIVELEVEL, oPc)) {
       AssignCommand(oPc, ClearAllActions());
       SendMessageToPC(oPc, "Ihr seid gestorben und könnt noch nicht rasten.");
    }
    switch (iRestType) {
        case REST_EVENTTYPE_REST_STARTED:
            if (GetTag(GetArea(oPc)) == "AREA_UnterDeck" || GetTag(GetArea(oPc)) == "OOC") {
              //pass
            } else {
                // Start rest conversation
                if (GetLocalInt(oPc, "rast") == 0 && GetLocalInt(oPc, "rast_short") <= 2) {
                    RestConversation(oPc);
                    return;
                // Full rest
                } else if (GetLocalInt(oPc, "rast") == 1) {
                    RestFull(oPc);
                    return;
                // Short rest
                } else if (GetLocalInt(oPc, "rast") == 2) {
                    RestShort(oPc);
                    return;
                } else if (GetLocalInt(oPc, "rast") == 0 && GetLocalInt(oPc, "rast_short") > 2) {
                    RestConversationNoShort(oPc);
                    return;
                }
            }
            break;
        case REST_EVENTTYPE_REST_FINISHED:
            break;
        case REST_EVENTTYPE_REST_CANCELLED:
            break;
    }
}
