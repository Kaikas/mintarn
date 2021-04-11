// Gibt dem Spieler crafting items
void main() {
    object oPc = GetLastUsedBy();
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    string sItem = "sw_ro_chronichin";
    int iCount = Random(2) + 1;
    CreateItemOnObject(sItem, oPc, iCount);
    DestroyObject(OBJECT_SELF);
}
