#include "x0_i0_walkway"
#include "global_helper"
#include "global_smoke"
#include "nw_i0_generic"

void main() {
    // Trigger AI scripts for NPC_ targets
    string sType = GetSubString(GetTag(OBJECT_SELF), 0, 4);
    if (sType == "NPC_") {
        object oWp;
        oWp = GetNextWaypoint(oWp, GetTag(OBJECT_SELF));
        if (oWp != OBJECT_INVALID) {
            float fTimer = GetLocalFloat(oWp, "RESTART");
            while (GetTag(oWp) != "") {
                if (GetLocalString(oWp, "ACTION") == "WALK") {
                    ActionMoveToObject(oWp);
                }
                if (GetLocalString(oWp, "ACTION") == "RUN") {
                    ActionMoveToObject(oWp, TRUE);
                }
                if (GetLocalString(oWp, "ACTION") == "TELEPORT") {
                    ActionJumpToObject(oWp, TRUE);
                }
                if (GetLocalString(oWp, "ACTION") == "SPEAK") {
                    string sMessage = GetLocalString(oWp, "SPEAK");
                    sMessage = ColorStrings(sMessage, "*", "*", "٧`");
                    sMessage = ColorStrings(sMessage, "((", "))", "uuu");
                    ActionDoCommand(SpeakString(sMessage));
                }
                if (GetLocalString(oWp, "ACTION") == "EMOTE") {
                    ActionPlayAnimation(GetLocalInt(oWp, "EMOTE"), 1.0, GetLocalFloat(oWp, "EMOTE_DURATION"));
                }
                if (GetLocalString(oWp, "ACTION") == "SIT") {
                    ActionSit(GetNearestObjectByTag("SIT"));
                }
                if (GetLocalString(oWp, "ACTION") == "RANDOM") {
                    ActionRandomWalk();
                    return;
                }
                if (GetLocalString(oWp, "ACTION") == "SMOKE") {
                    DelayCommand(IntToFloat(Random(1000)), SmokePipe(OBJECT_SELF));
                }
                oWp = GetNextWaypoint(oWp, GetTag(OBJECT_SELF));
            }
            DelayCommand(fTimer, ExecuteScript("global_onspawn", OBJECT_SELF));
        }
    }
    // Sizes
    if (GetTag(OBJECT_SELF) == "NPC_GronkGall") {
        SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 1.25);
    }
    if (GetTag(OBJECT_SELF) == "NPC_Hoondarrh") {
        SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 2.0);
    }
}
