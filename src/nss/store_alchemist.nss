#include "global_helper"

// �ffnet den Fischladen
void main() {
    object oStore = GetNearestObjectByTag("STORE_Alchemist");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetPCSpeaker());
    }
}
