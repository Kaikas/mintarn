// Destroys the item and puts something into the inventory of the caller
// depending on the calling item tag.

#include "global_helper"

void main() {
    // TODO: Make this dependend on the tag of the quest giver / SQL
    string sItem = "blauerpilz";
    int iCount = 1;

    // Give item to player and destroy self
    object oTarget = GetLastUsedBy();
    CreateItemOnObject(sItem, oTarget, iCount);
    // TODO: Spawn System
    //DestroyObject(OBJECT_SELF);
}
