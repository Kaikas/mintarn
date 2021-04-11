#include "nwnx_sql"

// Gibt dem Spieler eine Anleitung wie er seine Beschreibung editieren kann
void main() {
    object oPc = GetPCSpeaker();
    string sQuery = "SELECT text FROM Meta WHERE tag=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, "description");
        NWNX_SQL_ExecutePreparedQuery();
        NWNX_SQL_ReadNextRow();
        SendMessageToPC(oPc, NWNX_SQL_ReadDataInActiveRow(0));
    }
    sQuery = "SELECT token FROM Users WHERE name=? AND charname=?";
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_ExecutePreparedQuery();
        NWNX_SQL_ReadNextRow();
        SendMessageToPC(oPc, NWNX_SQL_ReadDataInActiveRow(0));
    }
}
