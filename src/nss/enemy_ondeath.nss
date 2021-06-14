#include "nwnx_sql"
#include "nwnx_time"
#include "nwnx_feedback"
#include "nwnx_time"

// Respawn the enemy at his death location
void respawn(location lLocation, string sResRef, string sTag, object oArea) {
    // Check if we have already been respawned
    if (GetLocalInt(oArea, "area_enter") > NWNX_Time_GetTimeStamp() - 2700) {
        CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLocation, FALSE, sTag);
    }
}

float quadratic(float x) {
    return (x/10000) * (x/10000);
}

// Gives xp to all creatures close to it
void main() {
    int iXpPenalty = -1;
    int iRpEp = 0;
    int iDatetime = 0;
    object oPc = GetFirstPC();
    while (oPc != OBJECT_INVALID && GetHitDice(oPc) < 15) {
        if (GetArea(oPc) == GetArea(OBJECT_SELF)) {
            if (GetDistanceBetween(OBJECT_SELF, oPc) < 50.0) {
                // Get old xp
                string sQuery = "SELECT * FROM Experience WHERE name=? AND charname=? AND type=?";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                    NWNX_SQL_PreparedString(1, GetName(oPc));
                    NWNX_SQL_PreparedString(2, "moschen");
                    NWNX_SQL_ExecutePreparedQuery();

                    while (NWNX_SQL_ReadyToReadNextRow()) {
                        NWNX_SQL_ReadNextRow();
                        iXpPenalty = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
                        iDatetime = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
                    }
                }
                // Get RP xp
                sQuery = "SELECT * FROM Experience WHERE name=? AND charname=? AND type=?";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                    NWNX_SQL_PreparedString(1, GetName(oPc));
                    NWNX_SQL_PreparedString(2, "rp");
                    NWNX_SQL_ExecutePreparedQuery();

                    while (NWNX_SQL_ReadyToReadNextRow()) {
                        NWNX_SQL_ReadNextRow();
                        iXpPenalty = iXpPenalty + StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
                        iRpEp = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
                    }
                }
                // If no entry exists, create one
                if (iDatetime == 0) {
                    sQuery = "INSERT INTO Experience (name, charname, experience, datetime, type) VALUES (?, ?, ?, ?, ?)";
                    if (NWNX_SQL_PrepareQuery(sQuery)) {
                        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                        NWNX_SQL_PreparedString(1, GetName(oPc));
                        NWNX_SQL_PreparedString(2, "0");
                        NWNX_SQL_PreparedString(3, IntToString(NWNX_Time_GetTimeStamp()));
                        NWNX_SQL_PreparedString(4, "moschen");
                        NWNX_SQL_ExecutePreparedQuery();
                    }
                }
                // Check if one week is over
                if (iDatetime != 0) {
                    if (NWNX_Time_GetTimeStamp() - iDatetime > 604800) {
                        iXpPenalty = 0;
                        sQuery = "DELETE FROM Experience WHERE name=? AND charname=? AND type=?";
                        if (NWNX_SQL_PrepareQuery(sQuery)) {
                            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                            NWNX_SQL_PreparedString(1, GetName(oPc));
                            NWNX_SQL_PreparedString(2, "moschen");
                            NWNX_SQL_ExecutePreparedQuery();
                        }
                    }
                }

                // Base XP
                int iXp = 250;
                // Reduce xp by level over CR
                int iLevel = GetLevelByPosition(1, oPc) + GetLevelByPosition(2, oPc) + GetLevelByPosition(3, oPc);
                int iDiff = iLevel - FloatToInt(GetChallengeRating(OBJECT_SELF));
                //SendMessageToPC(oPc, "Level: " + IntToString(iLevel) + " Diff: " + IntToString(iDiff) + " CR: " + IntToString(FloatToInt(GetChallengeRating(OBJECT_SELF))));
                int i;
                for (i = 0; i < iDiff; i++) {
                    iXp = iXp - 40;
                }
                // Reduce XP by cap
                if (iXpPenalty > 10000) {
                    iXp = FloatToInt(IntToFloat(iXp) / quadratic(IntToFloat(iXpPenalty)));
                }
                // failsafe
                if (iXp > 1000) iXp = 1000;
                if (iXp < 0) iXp = 0;
                // Add Random
                iXp = iXp + 5 + Random(5);

                // Set new xp
                sQuery = "UPDATE Experience SET experience=? WHERE name=? AND charname=? AND type=?";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, IntToString(iXpPenalty + iXp - iRpEp));
                    NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
                    NWNX_SQL_PreparedString(2, GetName(oPc));
                    NWNX_SQL_PreparedString(3, "moschen");
                    NWNX_SQL_ExecutePreparedQuery();
                }
                // Give xp to player
                //NWNX_Feedback_SetFeedbackMessageHidden(182, 1, oPc);
                GiveXPToCreature(oPc, iXp);
                //NWNX_Feedback_SetFeedbackMessageHidden(182, 0, oPc);
                //SendMessageToPC(oPc, "Ihr habt an Erfahrung gewonnen.");
            }
        }
        oPc = GetNextPC();
    }

    // Respawn in 30 Minutes
    DelayCommand(2700.0, respawn(GetLocation(OBJECT_SELF), GetResRef(OBJECT_SELF), GetTag(OBJECT_SELF), GetArea(OBJECT_SELF)));
}

