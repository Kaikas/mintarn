#include "global_helper"

// �ffnet den Laden im OOC Gebiet
void main() {
    object oStore = GetNearestObjectByTag("STORE_ooc");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetLastUsedBy());
    }
}
