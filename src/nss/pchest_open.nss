#include "nw_o2_coninclude"
#include "nwnx_sql"

void LoadItemsFromDatabase(object oChest, object oPc) {
    object oItem;
    string sResRef;
    int iAmount;
    string sDescription;
    string sQuery = "SELECT * FROM Playerchests WHERE name=? AND charname=? AND cdkey=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, GetPCPublicCDKey(oPc));
            NWNX_SQL_ExecutePreparedQuery();

            while (NWNX_SQL_ReadyToReadNextRow()) {
                NWNX_SQL_ReadNextRow();
                sResRef = NWNX_SQL_ReadDataInActiveRow(4);
                iAmount = StringToInt(NWNX_SQL_ReadDataInActiveRow(5));
                sDescription = NWNX_SQL_ReadDataInActiveRow(6);
                oItem = CreateItemOnObject(sResRef, oChest, iAmount);
                SetDescription(oItem, sDescription);
                //SendMessageToPC(oPc, "Item created: " + GetResRef(oItem) + " " + sResRef + " " + IntToString(iAmount));
            }
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
    object oOpener = GetLastOpener();
    string PlayerID = GetPCPublicCDKey(oOpener);

    if (GetLocalInt(OBJECT_SELF, "OPEN") == 1) {
        SendMessageToPC(oOpener, "Die Kiste wird gerade benutzt");
        ExecuteScript("pchest_clear", oOpener);
    } else {
        SetLocalInt(OBJECT_SELF, "OPEN", 1);
        SetLocalString(OBJECT_SELF, "OPENEDBY", PlayerID);

        DestroyAllObjectsInInventory(OBJECT_SELF);
        LoadItemsFromDatabase(OBJECT_SELF, oOpener);
    }
}
