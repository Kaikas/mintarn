void main() {
    int i;
    object oLight;
    for (i = 0; i < 1000; i++) {
        oLight = GetObjectByTag("LIGHT_Dauerlicht", i);
        SetLocalInt(oLight, "light", 1);
        // VFX_DUR_LIGHT_YELLOW_15
        int lighttype = VFX_DUR_LIGHT_YELLOW_15;
        if (GetLocalInt(oLight, "lighttype") != 0) {
            lighttype = GetLocalInt(oLight, "lighttype");
        }
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(lighttype), GetNearestObjectByTag("INVISIBLE_LIGHT"));
        RecomputeStaticLighting(GetArea(oLight));
        SetPlaceableIllumination(oLight, TRUE);
        AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
    }
}
