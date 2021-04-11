#include "global_helper"

// Gibt dem Spieler crafting items
void main() {
    object oPc = GetLastUsedBy();
    if (oPc == OBJECT_INVALID) {
        oPc = GetLastAttacker();
    }

    if (iHasItem("CRAFT_Spitzhacke", oPc)) {
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
        string sItem = "sw_ro_eisenerz";
        int iCount = Random(2) + 1;
        object oTarget = GetLastUsedBy();
        int iRandom = Random(20);
        if (iRandom == 0) {
            CreateItemOnObject("sw_ro_malachit", oTarget, 1);
        }
        if (iRandom == 1) {
            CreateItemOnObject("sw_ro_diamant", oTarget, 1);
        }
        if (iRandom == 2) {
            CreateItemOnObject("sw_ro_achat", oTarget, 1);
        }
        if (iRandom == 3) {
            CreateItemOnObject("sw_ro_amethyst", oTarget, 1);
        }
        if (iRandom == 4) {
            CreateItemOnObject("sw_ro_quartz", oTarget, 1);
        }
        if (iRandom == 5) {
            CreateItemOnObject("sw_ro_onyx", oTarget, 1);
        }
        CreateItemOnObject(sItem, oTarget, iCount);
        DestroyObject(OBJECT_SELF);
    } else {
        SpeakString("Ihr müsst eine Spitzhacke in Händen halten um dies abzubauen.");
    }
}
