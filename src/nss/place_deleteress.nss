#include "nwnx_sql"
#include "global_helper"

void main() {
    object oPc = GetPCSpeaker();
    object oDelete = GetNearestObject(OBJECT_TYPE_PLACEABLE, oPc, 1);
    location locTarget = GetLocation(oDelete);
    string sArea = GetTag(GetArea(oDelete));
    vector vPosition = GetPosition(oDelete);
    float fFacing = GetFacing(oDelete);

    string sQuery = "DELETE FROM Ressources WHERE area=? AND posx=? AND posy=? AND posz=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sArea);
        NWNX_SQL_PreparedString(1, FloatToString(vPosition.x));
        NWNX_SQL_PreparedString(2, FloatToString(vPosition.y));
        NWNX_SQL_PreparedString(3, FloatToString(vPosition.z));
        NWNX_SQL_ExecutePreparedQuery();
    }
    DestroyObject(oDelete);
}
