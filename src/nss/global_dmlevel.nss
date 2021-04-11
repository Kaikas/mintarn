#include "nwnx_sql"
#include "nwnx_events"

void main() {
    string sQuery = "INSERT INTO DMactions (name, charname, action) VALUES (?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(OBJECT_SELF));
        NWNX_SQL_PreparedString(1, GetName(OBJECT_SELF));
        NWNX_SQL_PreparedString(2, "Level " + NWNX_Events_GetEventData("AMOUNT") + " gegeben an " + GetPCPlayerName(StringToObject(NWNX_Events_GetEventData("OBJECT"))));
        NWNX_SQL_ExecutePreparedQuery();
    }
}
