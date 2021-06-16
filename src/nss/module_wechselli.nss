void switchLights() {
    //SetTime(Random(24), 0, 0, 0);
    //SetTime(9, 0, 0, 0);
    if (GetTimeHour() > 6 && GetTimeHour() < 18) {
        int i;
        object oLight;
        for (i = 0; i < 1000; i++) {
            oLight = GetObjectByTag("LIGHT_Wechsellicht", i);
            if (oLight != OBJECT_INVALID) {
                if (GetLocalInt(oLight, "light") != 1) {
                    SetLocalInt(oLight, "light", 1);
                    // VFX_DUR_LIGHT_YELLOW_15
                    int lighttype = VFX_DUR_LIGHT_YELLOW_15;
                    if (GetLocalInt(oLight, "lighttype") != 0) {
                        lighttype = GetLocalInt(oLight, "lighttype");
                    }
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(lighttype), GetNearestObjectByTag("INVISIBLE_LIGHT", oLight));
                    //RecomputeStaticLighting(GetArea(oLight));
                    SetPlaceableIllumination(oLight, TRUE);
                    AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
                }
            }
        }
    } else {
        int i;
        object oLight;
        for (i = 0; i < 1000; i++) {
            oLight = GetObjectByTag("LIGHT_Wechsellicht", i);
            if (oLight != OBJECT_INVALID) {
                SetLocalInt(oLight, "light", 0);
                object oTarget = GetNearestObjectByTag("INVISIBLE_LIGHT", oLight);
                effect eLoop=GetFirstEffect(oTarget);
                while (GetIsEffectValid(eLoop)) {
                    RemoveEffect(oTarget, eLoop);
                    eLoop=GetNextEffect(oTarget);
                }
                SetPlaceableIllumination(oLight, FALSE);
                AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
            }
        }
    }
    DelayCommand(600.0, switchLights());
}

void main() {
    switchLights();
}
