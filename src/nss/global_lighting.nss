void ToggleLight(object oLight) {
    if (GetLocalInt(oLight, "light") == 1) {
        SetLocalInt(oLight, "light", 0);

        // Remove all Effects from target
        object oTarget = GetNearestObjectByTag("INVISIBLE_LIGHT", oLight);
        effect eLoop=GetFirstEffect(oTarget);
        while (GetIsEffectValid(eLoop)) {
            RemoveEffect(oTarget, eLoop);
            eLoop=GetNextEffect(oTarget);
        }

        // Update lighting
        SetPlaceableIllumination(oLight, FALSE);
        RecomputeStaticLighting(GetArea(oLight));
        AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
    } else {
        SetLocalInt(oLight, "light", 1);

        // Determine lighting effect
        int lighttype = VFX_DUR_LIGHT_YELLOW_15;
        if (GetLocalInt(oLight, "lighttype") != 0) {
           lighttype = GetLocalInt(oLight, "lighttype");
        }

        // Apply lighting effect
        object oTarget = GetNearestObjectByTag("INVISIBLE_LIGHT", oLight);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(lighttype), oTarget);

        // Update lighting
        SetPlaceableIllumination(oLight, TRUE);
        RecomputeStaticLighting(GetArea(oLight));
        AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
    }
}


void ToggleAllLightsWithTag(string tag) {
    int i = 0;
    object oLight = GetObjectByTag(tag, 0);

    while (oLight != OBJECT_INVALID)
    {
        ToggleLight(oLight);

        i++;
        oLight = GetObjectByTag(tag, i);
    }
}


void ToggleDayNightLighting() {
    // SendMessageToPC( GetFirstPC(), "ToogleDayNightLighting");
    object oLight;
    int i = 0;

    while (GetObjectByTag("LIGHT_DAYTIME", i) != OBJECT_INVALID) {
        oLight = GetObjectByTag("LIGHT_DAYTIME", i);
        // Note that dawn (6) and dusk (18) are ignored.
        if (GetIsDay() &&  GetLocalInt(oLight, "light") == 0) {
            //SendMessageToPC( GetFirstPC(), "Es ist Tag. Schalte Tageslicht an.");
            ToggleLight(oLight);
        }
        if (GetIsNight() && GetLocalInt(oLight, "light") == 1) {
            //SendMessageToPC( GetFirstPC(), "Es ist Nacht. Schalte Tageslicht aus.");
            ToggleLight(oLight);
        }
        i++;
    }

    i = 0;
    while (GetObjectByTag("LIGHT_NIGHTTIME", i) != OBJECT_INVALID) {
        oLight = GetObjectByTag("LIGHT_NIGHTTIME", i);
        if (GetIsDay() &&  GetLocalInt(oLight, "light") == 1) {
            //SendMessageToPC( GetFirstPC(), "Es ist Tag. Schalte Nachtlicht aus.");
            ToggleLight(oLight);
        }
        if (GetIsNight() && GetLocalInt(oLight, "light") == 0) {
            //SendMessageToPC( GetFirstPC(), "Es ist Nacht. Schalte Nachtlicht an.");
            ToggleLight(oLight);
        }
        i++;
    }

    int iSecondToFullHour = (60.0 - GetTimeMinute()) * 0.7 * 60.0;
    //SendMessageToPC( GetFirstPC(), IntToString(GetTimeHour()));
    DelayCommand((60.0 - m), ToggleDayNightLighting());
    WriteTimestampedLogEntry("Toggle global lighting");
}


void ReplaceLightWaypoints()
{
    int i = 0;
    object oWaypoint = GetObjectByTag("WP_LIGHT", 0);
    object oLight;


    while (oWaypoint != OBJECT_INVALID)
    {
        oLight = CreateObject(OBJECT_TYPE_PLACEABLE, "invisibleitem", GetLocation(oWaypoint), FALSE, "INVISIBLE_LIGHT");

        i++;
        oWaypoint = GetObjectByTag("WP_LIGHT", i);
    }
}