#include "nwnx_sql"

// Lädt die Beschreibung aus der Datenbank
void main() {
    object oPc = GetPCSpeaker();
    string sQuery = "SELECT description FROM Users WHERE name=? AND charname=?";
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_ExecutePreparedQuery();
        NWNX_SQL_ReadNextRow();
        SendMessageToPC(oPc, NWNX_SQL_ReadDataInActiveRow(0));
        SetDescription(oPc, NWNX_SQL_ReadDataInActiveRow(0));
    }
}
