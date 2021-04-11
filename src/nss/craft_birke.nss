#include "global_helper"

// Gibt dem Spieler Holz
void main() {
    object oPc = GetLastUsedBy();
    if (oPc == OBJECT_INVALID) {
        oPc = GetLastAttacker();
    }

    if (iHasItem("CRAFT_Axt", oPc)) {
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        string sItem = "sw_ro_birkenholz";
        int iCount = Random(2) + 1;
        object oTarget = GetLastUsedBy();;
        CreateItemOnObject(sItem, oTarget, iCount);
        DestroyObject(OBJECT_SELF);
    } else {
        SpeakString("Ihr müsst eine Axt in Händen halten um dies abzubauen.");
    }
}
