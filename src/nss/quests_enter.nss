// Sets the quests for a user

#include "nwnx_sql"

// Writes a message to all player
void MessageAll(string sMessage) {
    object oPlayer = GetFirstPC();
    while(GetIsObjectValid(oPlayer))
        {
        SendMessageToPC(oPlayer,sMessage);
        oPlayer = GetNextPC();
        }
}

// Math.Min()
int Min(int a, int b) {
    if (a < b)
        return a;
    return b;
}

// Selects a valid quest for a player and puts it into the database
void SelectQuest(object oPc) {
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    string sQuery = "SELECT * FROM Quests";
    NWNX_SQL_ExecuteQuery(sQuery);
    int iQuestCount = NWNX_SQL_GetAffectedRows();
    int iQuestId;
    int iCountQuestsWithId;
    while (iCountQuestsWithId != 0) {
        // Assign a random quest
        iQuestId = Random(iQuestCount);
        // Check if the quest has already been given to the user
        string sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND stage!=? AND quest=?";
        if (NWNX_SQL_PrepareQuery(sQuery))
        {
            NWNX_SQL_PreparedString(0, sAccountName);
            NWNX_SQL_PreparedString(1, sName);
            NWNX_SQL_PreparedString(2, "DONE");
            NWNX_SQL_PreparedInt(3, iQuestId);
            NWNX_SQL_ExecutePreparedQuery();
        }
        // Count the quests
        iCountQuestsWithId = NWNX_SQL_GetAffectedRows();
    }

    // Insert Quest
    sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_PreparedInt(2, iQuestId);
        NWNX_SQL_PreparedString(3, "NEW");
        NWNX_SQL_ExecutePreparedQuery();
    }
}

// On client enter, counts quests for the user, adds quests until 10 quests are
// filled up
void main() {
    object oPc = GetEnteringObject();
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    string sQuery = "SELECT COUNT(*) FROM QuestStatus WHERE name=? AND charname=? AND (stage=? OR stage=?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_PreparedString(2, "PENDING");
        NWNX_SQL_PreparedString(3, "NEW");
        NWNX_SQL_ExecutePreparedQuery();
        NWNX_SQL_ReadNextRow();
        int iCurrentQuests = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        sQuery = "SELECT COUNT(*) FROM Quests";
        NWNX_SQL_ExecuteQuery(sQuery);
        NWNX_SQL_ReadNextRow();
        int iCountQuests = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        // Add quests until we have 10 or count of Quests
        int i;
        for (i = 0; i < Min(10, iCountQuests) - iCurrentQuests; i++) {
            SelectQuest(oPc);
        }
    }
}
