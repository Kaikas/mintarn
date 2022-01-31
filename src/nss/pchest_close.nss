#include "nwnx_sql"

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

void DestroyAllObjectsInInventory(object Chest) {
    object oItem = GetFirstItemInInventory(Chest);
    while (oItem != OBJECT_INVALID) {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(Chest);
    }
}

void main() {
    object oCloser = GetLastClosedBy();
    string PlayerID = GetPCPublicCDKey(oCloser);

    if (GetLocalString(OBJECT_SELF, "OPENEDBY") == PlayerID) {
        SetLocalInt(OBJECT_SELF, "OPEN", 0);
    }

    DropAllItemsFromDatabase(OBJECT_SELF, oCloser);
    SaveItemsInDatabase(OBJECT_SELF, oCloser);
    DestroyAllObjectsInInventory(OBJECT_SELF);
}
