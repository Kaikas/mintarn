#include "global_helper"

// Öffnet den Laden im OOC Gebiet
void main() {
    object oStore = GetNearestObjectByTag("ooc_store");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetLastUsedBy());
    }
}
