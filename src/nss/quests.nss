// Quest system

#include "nwnx_sql"

// Creates a quest with
// type: DELIVER | GATHER | KILL | CRAFT
// tag: Tag of the object or monster
// count: count of creatures to kill, thinkgs to deliver, ...
void CreateQuest(string type, string tag, int count) {
    string sQuery = "INSERT INTO Quests (type, tag, count) VALUES (?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, type);
        NWNX_SQL_PreparedString(1, tag);
        NWNX_SQL_PreparedInt(2, count);
        NWNX_SQL_ExecutePreparedQuery();
    }
}

// Initialize tables and create quests
void main() {
    // Create Quest Table
    string sQuery = "DROP TABLE Quests";
    NWNX_SQL_ExecuteQuery(sQuery);
    sQuery = "CREATE TABLE IF NOT EXISTS Quests (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "type TEXT, " +
        "tag TEXT, " +
        "count TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Create actual quests
    CreateQuest("DELIVER", "Paket_1", 1);
    CreateQuest("GATHER", "Paket_1", 1);
    CreateQuest("KILL", "Paket_1", 1);
    CreateQuest("CRAFT", "Paket_1", 1);
}
