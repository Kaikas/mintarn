#include "global_helper"

// �ffnet den Laden
void main() {
    object oStore = GetNearestObjectByTag(GetScriptParam("store"));
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, GetPCSpeaker());
    }
}
