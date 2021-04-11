#include "global_helper"

void main() {
    MessageAll("TEST");
    object oLight = GetNearestObjectByTag("LIGHT");
    if (GetIsObjectValid(oLight)) {
        DestroyObject(oLight);
    } else {
        CreateObject(OBJECT_TYPE_PLACEABLE, "lightwhite", GetLocation(OBJECT_SELF));
    }
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_WHITE), OBJECT_SELF, 0.0f);
    //CreateObject(OBJECT_TYPE_PLACEABLE, "nw_chicken", GetLocation(OBJECT_SELF));
}

/*
if (GetPlaceableIllumination(oLight)) {
            AssignCommand(oLight, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
            SetPlaceableIllumination(oLight, FALSE);
        } else {
            AssignCommand(oLight, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
            SetPlaceableIllumination(oLight, FALSE);
        }

        object oLight = GetNearestObjectByTag("LIGHT");
    if (GetIsObjectValid(oLight)) {
        MessageAll("LIGHT FOUND");


    }
*/
