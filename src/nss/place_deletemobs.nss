#include "nwnx_sql"
#include "global_helper"

void main() {
    object oPc = GetPCSpeaker();
    object oDelete = GetNearestObject(OBJECT_TYPE_CREATURE, oPc, 1);
    int id = GetLocalInt(oDelete, "id");

    string sQuery = "DELETE FROM Encounter WHERE id=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, IntToString(id));
        NWNX_SQL_ExecutePreparedQuery();
    }
    DestroyObject(oDelete);
}
