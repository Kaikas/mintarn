#include "nwnx_sql"
#include "nwnx_time"

// In seconds
const int TOKENTIMER = 60;

void CreateDowntimeInDatabase(object oPc) {
    string sQuery = "INSERT INTO Downtime (name, charname, datetime) VALUES (?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, IntToString(NWNX_Time_GetTimeStamp()));
        NWNX_SQL_ExecutePreparedQuery();
    }
}

int TokenHasAlreadyBeenReceived(object oPc) {
    string sQuery = "SELECT * FROM Downtime WHERE name=? AND charname=? ORDER BY id DESC LIMIT 1";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_ExecutePreparedQuery();

        int iFoundEntry = 0;
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iFoundEntry = 1;
            if (NWNX_Time_GetTimeStamp() - StringToInt(NWNX_SQL_ReadDataInActiveRow(3)) < TOKENTIMER) {
                return 1;
            }
        }
        // No entry exists yet, create one
        if (iFoundEntry == 0) {
            CreateDowntimeInDatabase(oPc);
        }
    }
    return 0;
}

void CreateTokenOnPlayer(object oPc) {
    CreateItemOnObject("sw_we_aktivit", oPc);
    string sQuery = "UPDATE Downtime SET datetime=? WHERE name=? AND charname=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, IntToString(NWNX_Time_GetTimeStamp()));
        NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(2, GetName(oPc));
        NWNX_SQL_ExecutePreparedQuery();
    }
}

void GiveDowntimeToken(object oPc) {
    if (!TokenHasAlreadyBeenReceived(oPc)) {
        CreateTokenOnPlayer(oPc);
    }
}
