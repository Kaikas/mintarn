#include "global_helper"

// Öffnet den Laden des Wirts
void main() {
    object oStore = GetNearestObjectByTag("STORE_Lebensmittelhaendler");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetPCSpeaker());
    }
}
