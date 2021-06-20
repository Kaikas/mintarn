#include "nwnx_sql"

void main()
{
    // SW Rasten
        object oTarget = GetLastUsedBy();
        string sQuery = "UPDATE Users SET rest=? WHERE name=? AND charname=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, "0");
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oTarget));
            NWNX_SQL_PreparedString(2, GetName(oTarget));

            NWNX_SQL_ExecutePreparedQuery();
        }
        CreateItemOnObject("sw_na_braten", oTarget);
        SetLocalInt(oTarget, "rast", 1);
        ExecuteScript("global_rest", oTarget);
}
