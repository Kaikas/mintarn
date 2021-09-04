#include "nwnx_sql"

// Gibt dem Spieler eine Belohnung bei erfolgreichem Quest
void main() {
    object oPc = GetPCSpeaker();
    int iCount = StringToInt(GetScriptParam("iCount"));
    string sDeleteObject = GetScriptParam("sDeleteObject");
    int iGold = StringToInt(GetScriptParam("iGold"));
    int iXP = StringToInt(GetScriptParam("iXP"));
    object oItem = GetFirstItemInInventory(oPc);
    int i = 0;
    while (oItem != OBJECT_INVALID)
    {
        if (i < iCount && GetTag(oItem) == sDeleteObject) {
            DestroyObject(oItem);
            i++;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    SetXP(oPc, GetXP(oPc) + iXP);
    GiveGoldToCreature(oPc, iGold);
    string sQuery = "UPDATE QuestStatus SET stage = ? WHERE name=? AND charname=? AND quest=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, "1");
        NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(2, GetName(oPc));
        NWNX_SQL_PreparedString(3, "stadtwache_intro");
        NWNX_SQL_ExecutePreparedQuery();
    }
    RemoveJournalQuestEntry("wache", oPc, FALSE, FALSE);
}
