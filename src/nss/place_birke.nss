// Gibt dem Spieler Holz
void main() {
    object oPc = GetLastUsedBy();

    if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPc)) == "CRAFT_Axt") {
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
        string sItem = "sw_ro_holz";
        int iCount = Random(2) + 1;
        object oTarget = GetLastUsedBy();;
        CreateItemOnObject(sItem, oTarget, iCount);
        DestroyObject(OBJECT_SELF);
    } else {
        SpeakString("Ihr m�sst eine Axt in H�nden halten um dies abzubauen.");
    }
}
