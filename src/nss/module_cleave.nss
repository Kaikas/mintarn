#include "nwnx_sql"
#include "nwnx_webhook"

void main()
{
    object oPc = GetExitingObject();

    // Note: Must be in a valid area, not "in transition" between them
    if(GetIsObjectValid(GetArea(oPc)))
    {
        string sAccountName = GetPCPlayerName(oPc);
        // Hook
        if (!GetIsDM(oPc)) {
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", "/api/webhooks/698915011552084009/mGO7QhdkzpM8As5-8JN6-Bki8P4AjzCZmk5z0GqbKKr0moNL55kS8GNPWllZ5F3CKrOa/slack", sAccountName + " hat sich ausgeloggt.", "Mintarn");
        }
        string sName = GetName(oPc);
        location loc = GetLocation(oPc);
        object oArea = GetAreaFromLocation(loc);
        vector vPosition = GetPositionFromLocation(loc);
        float fFacing = GetFacingFromLocation(loc);

        // Save player location
        if (GetTag(oArea) != "OOC") {
            string sQuery = "UPDATE Users SET facing=?, posx=?, posy=?, posz=?, area=?, gold=?, level1=?, level2=?, level3=?, gender=?, race=?, portrait=?, class1=?, class2=?, class3=?, alignment1=?, alignment2=?, health=?, maxhealth=? WHERE name=? AND charname=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, FloatToString(fFacing));
                NWNX_SQL_PreparedString(1, FloatToString(vPosition.x));
                NWNX_SQL_PreparedString(2, FloatToString(vPosition.y));
                NWNX_SQL_PreparedString(3, FloatToString(vPosition.z));
                NWNX_SQL_PreparedString(4, GetTag(oArea));
                NWNX_SQL_PreparedString(5, IntToString(GetGold(oPc)));
                NWNX_SQL_PreparedInt(6, GetLevelByPosition(1, oPc));
                NWNX_SQL_PreparedInt(7, GetLevelByPosition(2, oPc));
                NWNX_SQL_PreparedInt(8, GetLevelByPosition(3, oPc));
                NWNX_SQL_PreparedInt(9, GetGender(oPc));
                NWNX_SQL_PreparedInt(10, GetRacialType(oPc));
                NWNX_SQL_PreparedString(11, GetPortraitResRef(oPc));
                NWNX_SQL_PreparedInt(12, GetClassByPosition(1, oPc));
                NWNX_SQL_PreparedInt(13, GetClassByPosition(2, oPc));
                NWNX_SQL_PreparedInt(14, GetClassByPosition(3, oPc));
                NWNX_SQL_PreparedInt(15, GetAlignmentGoodEvil(oPc));
                NWNX_SQL_PreparedInt(16, GetAlignmentLawChaos(oPc));
                NWNX_SQL_PreparedInt(17, GetCurrentHitPoints(oPc));
                NWNX_SQL_PreparedInt(18, GetMaxHitPoints(oPc));
                NWNX_SQL_PreparedString(19, sAccountName);
                NWNX_SQL_PreparedString(20, sName);
                NWNX_SQL_ExecutePreparedQuery();
            }
        }
    }
}
