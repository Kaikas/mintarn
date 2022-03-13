#include "nwnx_sql"

int StartingConditional() {
    object oPc = GetPCSpeaker();
    int iStage;

    string sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        if (GetScriptParam("item") == "CRAFT_Eisenerz") {
            NWNX_SQL_PreparedString(2, "schmied_intro");
        }
        if (GetScriptParam("item") == "MIN_Leuchte") {
            NWNX_SQL_PreparedString(2, "lederer_intro");
        }
        if (GetScriptParam("item") == "CRAFT_Birkenholz") {
            NWNX_SQL_PreparedString(2, "schreiner_intro");
        }
        if (GetScriptParam("item") == "sw_we_beduerftige") {
            NWNX_SQL_PreparedString(2, "lebensmittel_intro");
        }
        if (GetScriptParam("item") == "QUEST_GoblinTalisman") {
            NWNX_SQL_PreparedString(2, "stadtwache_intro");
        }
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        }
    }
    int iResult = 0;
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (GetTag(oItem) == GetScriptParam("item")) {
            iResult = iResult + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    if (GetScriptParam("item") == "sw_we_beduerftige" && iStage == 1) {
        return 1;
    }
    if (GetScriptParam("item") == "MIN_Leuchte" && iStage == 0 && iResult > 0) {
        return 1;
    }
    if (GetScriptParam("item") == "QUEST_GoblinTalisman" && iStage == 1) {
        return 0;
    }
    if (iResult > 0 && GetScriptParam("item") == "CRAFT_Birkenholz") {
        return 1;
    }
    if (iResult > 0 && GetScriptParam("item") == "CRAFT_Eisenerz") {
        return 1;
    }
    if (iResult > 4 && iStage == 0) {
        return 1;
    } else {
        return 0;
    }
}
