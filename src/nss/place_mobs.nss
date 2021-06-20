#include "nwnx_sql"
#include "global_helper"

void Create(string sType, object oPc) {
    string sArea = GetLocalString(oPc, "placer_area");
    object oArea = GetObjectByTag(sArea);
    vector vPosition;
    vPosition.x = GetLocalFloat(oPc, "placer_x");
    vPosition.y = GetLocalFloat(oPc, "placer_y");
    vPosition.z = GetLocalFloat(oPc, "placer_z");
    float fFacing = GetLocalFloat(oPc, "placer_facing");
    location locTarget = Location(oArea, vPosition, fFacing);
    object oCreated = CreateObject(OBJECT_TYPE_CREATURE, sType, locTarget);

    string sQuery = "INSERT INTO Encounter (area, posx, posy, posz, facing, type, chance) VALUES (?, ?, ?, ?, ?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sArea);
        NWNX_SQL_PreparedString(1, FloatToString(vPosition.x));
        NWNX_SQL_PreparedString(2, FloatToString(vPosition.y));
        NWNX_SQL_PreparedString(3, FloatToString(vPosition.z));
        NWNX_SQL_PreparedString(4, FloatToString(fFacing));
        NWNX_SQL_PreparedString(5, sType);
        NWNX_SQL_PreparedString(6, IntToString(GetLocalInt(oPc, "SW_PLACER_CHANCE")));
        NWNX_SQL_ExecutePreparedQuery();
    }

    // Set local int id for deletion
    sQuery = "SELECT id FROM Encounter ORDER BY id DESC LIMIT 0, 1";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_ExecutePreparedQuery();
        NWNX_SQL_ReadNextRow();
        int iId = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        SetLocalInt(oCreated, "id", iId);
    }
}
