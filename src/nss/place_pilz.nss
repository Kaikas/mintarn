// Gibt dem Spieler einen Pilz beim benutzen
void main() {
    object oPc = GetLastUsedBy();
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0));
    string sItem = "sw_ro_pilz";
    int iCount = Random(2) + 1;
    object oTarget = GetLastUsedBy();
    CreateItemOnObject(sItem, oTarget, iCount);
    DestroyObject(OBJECT_SELF);
}
