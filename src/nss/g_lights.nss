/*

   All light functions of Mintarn go in here.

 */

int iNewSystem = 1;

// Creates an INVISIBLE_LIGHT object on all  occurences of WP_LIGHT waypoints.
// This is done so waypoints can be placed instead of invisible objects.
void CreateLightsAtWaypoints() {
  if (iNewSystem) {
    // Not needed anymore
  } else {
    int i = 0;
    object oWaypoint = GetObjectByTag("WP_LIGHT", 0);
    object oLight;
    while (oWaypoint != OBJECT_INVALID) {
      oLight = CreateObject(OBJECT_TYPE_PLACEABLE, "invisibleitem", GetLocation(oWaypoint), FALSE, "INVISIBLE_LIGHT");
      oWaypoint = GetObjectByTag("WP_LIGHT", i);
      i++;
    }
  }
}

// Turn on a single light source.
void TurnOnLight(object oLight) {
  SetLocalInt(oLight, "light", 1);

  // Play light animation
  AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));

  if (iNewSystem) {
    string lighttype = "dl_brown_09";
    if (GetLocalString(oLight, "lighttype") != "") lighttype = GetLocalString(oLight, "lighttype");
    object oTarget = GetNearestObjectByTag("WP_LIGHT", oLight);
    object oLightSource = CreateObject(OBJECT_TYPE_PLACEABLE, lighttype, GetLocation(oTarget), FALSE, "NEW_LIGHT");
  } else {
    // Determine lighting effect type
    int lighttype = VFX_DUR_LIGHT_YELLOW_15;
    if (GetLocalInt(oLight, "lighttype") != 0) lighttype = GetLocalInt(oLight, "lighttype");

    // Apply light effect to closest INVISIBLE_LIGHT object
    object oTarget = GetNearestObjectByTag("INVISIBLE_LIGHT", oLight);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(lighttype), oTarget);
  }
}

// Turn off a single light source.
void TurnOffLight(object oLight) {
  SetLocalInt(oLight, "light", 0);

  // Play light animation
  AssignCommand(oLight, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

  if (iNewSystem) {
    object oTarget = GetNearestObjectByTag("NEW_LIGHT", oLight);
    if (GetDistanceBetween(oLight, oTarget) <= 5.0) {
        DestroyObject(oTarget);
    }
  } else {
    // Remove light effects from closes INVISIBLE_LIGHT object
    object oTarget = GetNearestObjectByTag("INVISIBLE_LIGHT", oLight);
    effect eLoop=GetFirstEffect(oTarget);
    while (GetIsEffectValid(eLoop)) {
      RemoveEffect(oTarget, eLoop);
      eLoop=GetNextEffect(oTarget);
    }
 }
}

// Toggle a single light source
void ToggleLight(object oLight) {
  if (GetLocalInt(oLight, "light") == 1) {
    TurnOffLight(oLight);
  } else {
    TurnOnLight(oLight);
  }
}

/*
   Manipulates lights with specific tag.
   sTag is the tag of all objects to be manipulated
   sType is the type of action to be done:
0: off
1: on
2: toggle
 */
void ManipulateAllLightsWithTag(string sTag, int iType) {
  int i = 0;
  object oLight = GetObjectByTag(sTag, 0);

  while (oLight != OBJECT_INVALID) {
    if (iType == 0) TurnOffLight(oLight);
    if (iType == 1) TurnOnLight(oLight);
    if (iType == 2) ToggleLight(oLight);
    i++;
    oLight = GetObjectByTag(sTag, i);
  }
}

// This is the heartbeat function that gets called ever so often
// to determine if its time to change the lights.
void LightHeartbeat(int iDawn, int iDusk) {
  object oModule = GetModule();

  // Check if its night
  //if (GetTimeHour() >= iDusk && GetTimeHour() <= iDawn && (GetLocalString(oModule, "LIGHTS_TIME") == "DAY" || GetLocalString(oModule, "LIGHTS_TIME") == "INIT")) {
  if (GetIsNight() && (GetLocalString(oModule, "LIGHTS_TIME") == "DAY" || GetLocalString(oModule, "LIGHTS_TIME") == "INIT")) {
    // Set Module LIGHTS_TIME
    SetLocalString(oModule, "LIGHTS_TIME", "NIGHT");
    // Switch on all night lighs
    ManipulateAllLightsWithTag("LIGHT_NIGHTTIME", 1);
    // Switch off all day lights
    ManipulateAllLightsWithTag("LIGHT_DAYTIME", 0);
  }
  //if (GetTimeHour() > iDawn && GetTimeHour() < iDusk && (GetLocalString(oModule, "LIGHTS_TIME") == "NIGHT" || GetLocalString(oModule, "LIGHTS_TIME") == "INIT")) {
  if (GetIsDay() && (GetLocalString(oModule, "LIGHTS_TIME") == "NIGHT" || GetLocalString(oModule, "LIGHTS_TIME") == "INIT")) {
    // Set Module LIGHTS_TIME
    SetLocalString(oModule, "LIGHTS_TIME", "DAY");
    // Switch on all night lighs
    ManipulateAllLightsWithTag("LIGHT_NIGHTTIME", 0);
    // Switch off all day lights
    ManipulateAllLightsWithTag("LIGHT_DAYTIME", 1);
  }

  DelayCommand(60.0f, LightHeartbeat(iDawn, iDusk));
}

