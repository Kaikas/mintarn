#include "global_helper"

// Öffnet den Fischladen
void main() {
    object oStore = GetNearestObjectByTag("STORE_Fischhaendler");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetPCSpeaker());
    }
}
