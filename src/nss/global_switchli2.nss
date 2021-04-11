void main() {
    if (GetLocalInt(OBJECT_SELF, "light") == 1) {
        SetLocalInt(OBJECT_SELF, "light", 0);
        object oTarget = GetNearestObjectByTag("INVISIBLE_LIGHT");
        effect eLoop=GetFirstEffect(oTarget);
        while (GetIsEffectValid(eLoop)) {
            RemoveEffect(oTarget, eLoop);
            eLoop=GetNextEffect(oTarget);
        }
        SetPlaceableIllumination(OBJECT_SELF, FALSE);
        AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
    } else {
        SetLocalInt(OBJECT_SELF, "light", 1);
        object oPc = GetLastUsedBy();
        // VFX_DUR_LIGHT_YELLOW_15
        int lighttype = VFX_DUR_LIGHT_YELLOW_15;
        if (GetLocalInt(OBJECT_SELF, "lighttype") != 0) {
            lighttype = GetLocalInt(OBJECT_SELF, "lighttype");
        }
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(lighttype), GetNearestObjectByTag("INVISIBLE_LIGHT"));
        RecomputeStaticLighting(GetArea(oPc));
        SetPlaceableIllumination(OBJECT_SELF, TRUE);
        AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
    }
}
