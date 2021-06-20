// Gibt dem Spieler Erz
void main() {
    object oPc = GetLastUsedBy();

    if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPc)) == "CRAFT_Spitzhacke") {
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        string sItem = "sw_ro_eisenerz";
        int iCount = Random(2) + 1;
        object oTarget = GetLastUsedBy();;
        CreateItemOnObject(sItem, oTarget, iCount);
        if (Random(10) == 0) {
            CreateItemOnObject("sw_ro_malachit", oTarget, 1);
        }
        if (Random(10) == 0) {
            CreateItemOnObject("sw_ro_diamant", oTarget, 1);
        }
        if (Random(10) == 0) {
            CreateItemOnObject("sw_ro_achat", oTarget, 1);
        }
        if (Random(10) == 0) {
            CreateItemOnObject("sw_ro_amethyst", oTarget, 1);
        }
        if (Random(10) == 0) {
            CreateItemOnObject("sw_ro_quartz", oTarget, 1);
        }
        if (Random(10) == 0) {
            CreateItemOnObject("sw_ro_onyx", oTarget, 1);
        }
        DestroyObject(OBJECT_SELF);
    } else {
        SpeakString("Ihr müsst eine Spitzhacke in Händen halten um dies abzubauen.");
    }
}
