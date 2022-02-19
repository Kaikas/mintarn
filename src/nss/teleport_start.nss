#include "nwnx_sql"

// Teleportiert den Spieler an seine letzte bekannte Position
void main() {
    object oPc = GetLastUsedBy();

    //Until this has a better place to be: Reset death fails and successes
    SetLocalInt(oPc, "DYING_POINTS", 0);
    SetLocalInt(oPc, "LIVING_POINTS", 0);

    // Destroy equipped items
    object oItem;
    int nSlot;
    if (GetIsPC(oPc)) {
        for (nSlot=0; nSlot < NUM_INVENTORY_SLOTS; nSlot++) {
           oItem = GetItemInSlot(nSlot, oPc);
           if (nSlot != INVENTORY_SLOT_CARMOUR && nSlot != INVENTORY_SLOT_CWEAPON_B && nSlot != INVENTORY_SLOT_CWEAPON_L && nSlot != INVENTORY_SLOT_CWEAPON_R) {
               if (GetSubString(GetTag(oItem), 0, 6) != "MIN_" && GetSubString(GetTag(oItem), 0, 6) != "CRAFT_" && GetSubString(GetTag(oItem), 0, 6) != "QUEST_" && GetSubString(GetTag(oItem), 0, 3) != "SW_" && GetTag(oItem) != "x3_it_pchide") {
                   SendMessageToPC(oPc, GetTag(oItem));
                   PrintString(GetTag(oItem));
                   DestroyObject(oItem);
               }
           }
        }
        // Destroy items in inventory
        oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID) {
            if (GetSubString(GetTag(oItem), 0, 4) != "MIN_" && GetSubString(GetTag(oItem), 0, 6) != "CRAFT_" && GetSubString(GetTag(oItem), 0, 6) != "QUEST_" && GetSubString(GetTag(oItem), 0, 3) != "SW_" && GetTag(oItem) != "x3_it_pchide") {
               SendMessageToPC(oPc, GetTag(oItem));
               PrintString(GetTag(oItem));
               DestroyObject(oItem);
            }
            oItem = GetNextItemInInventory(GetFirstPC());
        }
        //CreateItemOnObject("x3_it_skin", oPc, 1);
    }

    // Teleport to old location
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    string sQuery = "SELECT * FROM Users WHERE name=? AND charname=?";
    if (NWNX_SQL_PrepareQuery(sQuery))
    {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_ExecutePreparedQuery();

        NWNX_SQL_ReadNextRow();
        if (NWNX_SQL_ReadDataInActiveRow(7) != "" && NWNX_SQL_ReadDataInActiveRow(7) != "OOC" && GetObjectByTag(NWNX_SQL_ReadDataInActiveRow(7)) != OBJECT_INVALID) {
            vector vPosition = Vector(StringToFloat(NWNX_SQL_ReadDataInActiveRow(4)), StringToFloat(NWNX_SQL_ReadDataInActiveRow(5)), StringToFloat(NWNX_SQL_ReadDataInActiveRow(6)));
            location locTarget = Location(GetObjectByTag(NWNX_SQL_ReadDataInActiveRow(7)), vPosition, StringToFloat(NWNX_SQL_ReadDataInActiveRow(3)));
            SetDescription(oPc, NWNX_SQL_ReadDataInActiveRow(14));
            DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(locTarget)));
        } else {
            location lStart = GetLocation(GetObjectByTag("WP_START_AUF_SEE"));
            DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
        }
    } else {
        // No database connection
        location lStart = GetLocation(GetObjectByTag("WP_START_AUF_SEE"));
        DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
    }
}
