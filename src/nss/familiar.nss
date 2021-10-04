#include "nwnx_sql"
#include "nwnx_feedback"

// Handles pet spawn and gives them hitpoints according to the database
void spawn(object oPc, object oPet) {
    // Check if entry already exists
    string sQuery = "SELECT * FROM Pets WHERE name=? AND charname=? AND type=?";
    int iFound = 0;
    int iHitPoints = 0;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, GetTag(oPet));
        NWNX_SQL_ExecutePreparedQuery();

        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) > 0) {
                iFound = 1;
                iHitPoints = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
            }
        }
    }
    SendMessageToPC(oPc, "Pet: " + GetTag(oPet) + IntToString(iHitPoints));
    // Entry not found, create
    if (iFound == 0) {
        // Check if entry already exists
        string sQuery = "INSERT INTO Pets (name, charname, type, health) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, GetTag(oPet));
            NWNX_SQL_PreparedString(3, IntToString(GetCurrentHitPoints(oPet)));
            NWNX_SQL_ExecutePreparedQuery();
        }
    // Entry found, set hitpoints
    } else {
        if (iHitPoints != -128) {
            //NWNX_Feedback_SetCombatLogMessageHidden(11, 1);
            //NWNX_Feedback_SetCombatLogMessageHidden(3, 1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oPet) - iHitPoints), oPet);
            //NWNX_Feedback_SetCombatLogMessageHidden(11, 0);
            //NWNX_Feedback_SetCombatLogMessageHidden(3, 0);
        }
    }
}

// Updates hitpoints when a pet is damaged
void damaged(object oPc, object oPet) {
    string sQuery = "UPDATE Pets SET health=? WHERE name=? AND charname=? AND type=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, IntToString(GetCurrentHitPoints(oPet)));
        NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(2, GetName(oPc));
        NWNX_SQL_PreparedString(3, GetTag(oPet));
        NWNX_SQL_ExecutePreparedQuery();
    }
}

// Dummy for compiler
//void main() {}

