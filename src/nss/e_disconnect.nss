#include "nwnx_webhook"
#include "nwnx_util"
#include "nwnx_sql"

void DestroyAllObjectsInInventory(object Chest) {
    object oItem = GetFirstItemInInventory(Chest);
    while (oItem != OBJECT_INVALID) {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(Chest);
    }
}

void DropAllItemsFromDatabase(object Chest, object oPc) {
    string sQuery = "DELETE FROM Playerchests WHERE name=? AND charname=? AND cdkey=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, GetPCPublicCDKey(oPc));
        NWNX_SQL_ExecutePreparedQuery();
    }
}

void SaveItemsInDatabase(object Chest, object oPc) {
    object oItem = GetFirstItemInInventory(Chest);
    while (oItem != OBJECT_INVALID) {
        string sQuery = "INSERT INTO Playerchests (name, charname, cdkey, itemtag, amount) VALUES (?, ?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, GetPCPublicCDKey(oPc));
            NWNX_SQL_PreparedString(3, GetResRef(oItem));
            NWNX_SQL_PreparedString(4, IntToString(GetItemStackSize(oItem)));
            NWNX_SQL_PreparedString(5, GetDescription(oItem));
            NWNX_SQL_ExecutePreparedQuery();
        }
        oItem = GetNextItemInInventory(Chest);
    }
}

// Cleans up if a player crashed or disconnected with alt+f4
void main() {
    object oPc = OBJECT_SELF;
    string PlayerID = GetPCPublicCDKey(oPc);
    string sAccountName = GetPCPlayerName(oPc);
    string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_MODULE");
    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " ist gecrasht.", "Mintarn");
    object oArea = GetFirstArea();
    while (GetIsObjectValid(oArea)) {
        object oObject = GetFirstObjectInArea(oArea);
        while(GetIsObjectValid(oObject)) {
             if(GetTag(oObject) == "PERSITENT_CHEST") {
                if (GetLocalString(oObject, "OPENEDBY") == PlayerID) {
                    DropAllItemsFromDatabase(oObject, oPc);
                    SaveItemsInDatabase(oObject, oPc);
                    DestroyAllObjectsInInventory(oObject);
                    SetLocalInt(oObject, "OPEN", 0);
                }
             }
             oObject = GetNextObjectInArea(oArea);
        }
        oArea = GetNextArea();
    }
}
