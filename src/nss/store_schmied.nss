#include "global_helper"

// �ffnet den Laden des Schmieds
void main() {
    object oStore = GetNearestObjectByTag("STORE_Schmied");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetPCSpeaker());
    }
}
