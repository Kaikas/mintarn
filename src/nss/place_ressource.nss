#include "nwnx_sql"
#include "global_helper"

void main() {
    string sTier = "1";
    if (GetScriptParam("indoor") == "0") {
        sTier = "1";
    } else {
        sTier = "2";
    }
    object oPc = GetPCSpeaker();
    string sArea = GetLocalString(oPc, "placer_area");
    object oArea = GetObjectByTag(sArea);
    vector vPosition;
    vPosition.x = GetLocalFloat(oPc, "placer_x");
    vPosition.y = GetLocalFloat(oPc, "placer_y");
    vPosition.z = GetLocalFloat(oPc, "placer_z");
    float fFacing = GetLocalFloat(oPc, "placer_facing");
    location locTarget = Location(oArea, vPosition, fFacing);
    int iRand = Random(2);
    CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_pilz", locTarget);

    string sQuery = "INSERT INTO Ressources (area, posx, posy, posz, facing, tier) VALUES (?, ?, ?, ?, ?, ?)";
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
