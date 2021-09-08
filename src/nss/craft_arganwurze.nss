#include "global_helper"

// Gibt dem Spieler crafting items
void main() {
    object oPc = GetLastUsedBy();
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0));
    string sItem = "sw_ro_arganwurze";
    int iCount = Random(2) + 1;
    CreateItemOnObject(sItem, oPc, iCount);
    DelayCommand(2700.0, respawn(GetLocation(OBJECT_SELF), GetResRef(OBJECT_SELF), GetTag(OBJECT_SELF), GetArea(OBJECT_SELF)));
    DestroyObject(OBJECT_SELF);
}
