#include "nwnx_sql"
#include "global_helper"

void main() {
    string sTier = "1";
    string sType = "kiste";
    object oPc = GetPCSpeaker();
    string sArea = GetLocalString(oPc, "placer_area");
    object oArea = GetObjectByTag(sArea);
    vector vPosition;
    vPosition.x = GetLocalFloat(oPc, "placer_x");
    vPosition.y = GetLocalFloat(oPc, "placer_y");
    vPosition.z = GetLocalFloat(oPc, "placer_z");
    float fFacing = GetLocalFloat(oPc, "placer_facing");
    location locTarget = Location(oArea, vPosition, fFacing);
    object oChest = CreateObject(OBJECT_TYPE_PLACEABLE, sType, locTarget);

    string sQuery = "INSERT INTO Chests (area, posx, posy, posz, facing, tier) VALUES (?, ?, ?, ?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sArea);
        NWNX_SQL_PreparedString(1, FloatToString(vPosition.x));
        NWNX_SQL_PreparedString(2, FloatToString(vPosition.y));
        NWNX_SQL_PreparedString(3, FloatToString(vPosition.z));
        NWNX_SQL_PreparedString(4, FloatToString(fFacing));
        NWNX_SQL_PreparedString(5, sTier);
        NWNX_SQL_ExecutePreparedQuery();
    }
}
