object oModule = GetModule();

// Base temperature for a day
int basetemperature(int iTempDayBefore) {
    int iTemperatur = 0;

    // Season
    if (GetCalendarMonth() == 1) iTemperatur = 3;
    if (GetCalendarMonth() == 2) iTemperatur = 5;
    if (GetCalendarMonth() == 3) iTemperatur = 7;
    if (GetCalendarMonth() == 4) iTemperatur = 8;
    if (GetCalendarMonth() == 5) iTemperatur = 12;
    if (GetCalendarMonth() == 6) iTemperatur = 18;
    if (GetCalendarMonth() == 7) iTemperatur = 20;
    if (GetCalendarMonth() == 8) iTemperatur = 16;
    if (GetCalendarMonth() == 9) iTemperatur = 12;
    if (GetCalendarMonth() == 10) iTemperatur = 6;
    if (GetCalendarMonth() == 11) iTemperatur = 4;
    if (GetCalendarMonth() == 12) iTemperatur = 3;

    // Change by day before or after
    if (iTempDayBefore < iTemperatur) iTemperatur--;
    if (iTempDayBefore > iTemperatur) iTemperatur++;

    // Let the temperature appear a bit random
    iTemperatur = iTemperatur + d4() - 4;

    return iTemperatur;
}

// Temperature during a day
int temperature(int iTemperatur) {

    // Time of day
    if (GetTimeHour() == 0) iTemperatur = iTemperatur - 4;
    if (GetTimeHour() == 1) iTemperatur = iTemperatur - 5;
    if (GetTimeHour() == 2) iTemperatur = iTemperatur - 5;
    if (GetTimeHour() == 3) iTemperatur = iTemperatur - 5;
    if (GetTimeHour() == 4) iTemperatur = iTemperatur - 5;
    if (GetTimeHour() == 5) iTemperatur = iTemperatur - 5;
    if (GetTimeHour() == 6) iTemperatur = iTemperatur - 5;
    if (GetTimeHour() == 7) iTemperatur = iTemperatur - 4;
    if (GetTimeHour() == 8) iTemperatur = iTemperatur - 3;
    if (GetTimeHour() == 9) iTemperatur = iTemperatur - 2;
    if (GetTimeHour() == 10) iTemperatur = iTemperatur - 1;
    if (GetTimeHour() == 11) iTemperatur = iTemperatur + 0;
    if (GetTimeHour() == 12) iTemperatur = iTemperatur + 2;
    if (GetTimeHour() == 13) iTemperatur = iTemperatur + 2;
    if (GetTimeHour() == 14) iTemperatur = iTemperatur + 3;
    if (GetTimeHour() == 15) iTemperatur = iTemperatur + 4;
    if (GetTimeHour() == 16) iTemperatur = iTemperatur + 5;
    if (GetTimeHour() == 17) iTemperatur = iTemperatur + 4;
    if (GetTimeHour() == 18) iTemperatur = iTemperatur + 3;
    if (GetTimeHour() == 19) iTemperatur = iTemperatur + 1;
    if (GetTimeHour() == 20) iTemperatur = iTemperatur + 0;
    if (GetTimeHour() == 21) iTemperatur = iTemperatur + 0;
    if (GetTimeHour() == 22) iTemperatur = iTemperatur - 2;
    if (GetTimeHour() == 23) iTemperatur = iTemperatur - 4;

    return iTemperatur;
}

void setWind(object oArea, int iWindStrength) {
  // Direction [East, North, Ground]
  vector vDirection = [1.0, 1.0, 0.0];
  float fWindStrength = IntToFloat(iWindStrength);
  string sWindDirection = GetLocalString(oModule, "sWindDirection");
  float fNegative = 1.0;

  if (sWindDirection == "Südwind") vDirection = Vector(0.0, 1.0, 0.0);
  if (sWindDirection == "Westwind") vDirection = Vector(1.0, 0.0, 0.0);
  if (sWindDirection == "Nordwind") vDirection = Vector(0.0, -1.0, 0.0);
  if (sWindDirection == "Ostwind") vDirection = Vector(-1.0, 0.0, 0.0);

  if (sWindDirection == "Nordostwind") vDirection = Vector(-1.0, -1.0, 0.0);
  if (sWindDirection == "Südostwind") vDirection = Vector(-1.0, 1.0, 0.0);
  if (sWindDirection == "Nordwestwind") vDirection = Vector(1.0, -1.0, 0.0);
  if (sWindDirection == "Südwestwind") vDirection = Vector(1.0, 1.0, 0.0);
  
  SetAreaWind(oArea, vDirection, fWindStrength, fWindStrength * 50.0, fWindStrength * 1.0);
}

void setWindForAreas(int iWindStrength) {
    setWind(GetObjectByTag("AREA_Freihafen"), iWindStrength);
    setWind(GetObjectByTag("AREA_Insel"), iWindStrength);
    setWind(GetObjectByTag("AREA_Banditenfestung"), iWindStrength);
    setWind(GetObjectByTag("AREA_Hgelland"), iWindStrength);
    setWind(GetObjectByTag("AREA_Banditenfestung"), iWindStrength);
    setWind(GetObjectByTag("AREA_versteckterHain"), iWindStrength);
    setWind(GetObjectByTag("AREA_Westmark"), iWindStrength);
}


// Set fog for an area
void setFog(string sDay, string sDayBefore, int iTemperatur, int iHeight, int iWindStrength, int iRain, object oModule, object oArea) {
    int iStart = GetLocalInt(oModule, sDay + "fog_start");
    int iEnd = GetLocalInt(oModule, sDay + "fog_end");
    if (iStart == 0) iStart = 6;
    if (iEnd == 0) iEnd = 8;

    if (GetTimeHour() > iStart && GetLocalInt(oArea, "fog") == 0 && GetTimeHour() < iEnd && iWindStrength < 3 && (iRain == 1 || iRain == 3)) {
        if (GetTag(oArea) != "AREA_versteckterHain") {
            SetFogAmount(FOG_TYPE_SUN, 200, oArea);
            SetFogAmount(FOG_TYPE_MOON, 200, oArea);
        }
        int i, j;
        for (i = 0; i < 300; i = i + 30) {
            for (j = 0; j < 300; j = j + 30) {
                float z = GetGroundHeight(Location(oArea, Vector(IntToFloat(i), IntToFloat(j), 0.0), 0.0));
                vector vPosition = Vector(IntToFloat(i), IntToFloat(j), z);
                if (iTemperatur > 5) {
                    if (iHeight == 0) CreateObject(OBJECT_TYPE_PLACEABLE, "weather_foglow", Location(oArea, vPosition, 0.0), FALSE, "WEATHER_FOG");
                    if (iHeight == 1) CreateObject(OBJECT_TYPE_PLACEABLE, "weather_fogmid", Location(oArea, vPosition, 0.0), FALSE, "WEATHER_FOG");
                    if (iHeight == 2) CreateObject(OBJECT_TYPE_PLACEABLE, "weather_foghigh", Location(oArea, vPosition, 0.0), FALSE, "WEATHER_FOG");
                 } else {
                    if (iHeight == 0) CreateObject(OBJECT_TYPE_PLACEABLE, "weather_fogilow", Location(oArea, vPosition, 0.0), FALSE, "WEATHER_FOG");
                    if (iHeight == 1) CreateObject(OBJECT_TYPE_PLACEABLE, "weather_fogimid", Location(oArea, vPosition, 0.0), FALSE, "WEATHER_FOG");
                    if (iHeight == 2) CreateObject(OBJECT_TYPE_PLACEABLE, "weather_fogihigh", Location(oArea, vPosition, 0.0), FALSE, "WEATHER_FOG");
                }
            }
        }
        SetLocalInt(oArea, "fog", 1);
    }
    if ((GetTimeHour() < iStart || GetTimeHour() > iEnd) && GetLocalInt(oArea, "fog") == 1) {
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);
        int i;
        object oFog;
        for (i = 0; i < 1000; i++) {
            oFog = GetObjectByTag("WEATHER_FOG", i);
            if (oFog != OBJECT_INVALID) {
                DestroyObject(oFog);
            }
        }
        SetLocalInt(oArea, "fog", 0);
    }
}

void weather() {
    // Create random values for testing
    //SetCalendar(GetCalendarYear() + 1, d12(), Random(28) + 1);
    //SetTime(Random(24), 0, 0, 0);

    object oModule = GetModule();
    int iTemperatur;

    //////////////////////////
    // Temperature
    //////////////////////////

    // If we have a new day, we need to create a new temperature baseline
    string sDay = IntToString(GetCalendarYear()) + "." + IntToString(GetCalendarMonth()) + "." + IntToString(GetCalendarDay());
    string sDayBefore;
    if (GetCalendarDay() == 1) {
        sDayBefore = IntToString(GetCalendarYear()) + "." + IntToString(GetCalendarMonth()) + ".28";
    } else {
        sDayBefore = IntToString(GetCalendarYear()) + "." + IntToString(GetCalendarMonth()) + "." + IntToString(GetCalendarDay() - 1);
    }
    if (GetLocalInt(oModule, sDay) == 0) {
        // temp not set yet, get temp of previous day
        iTemperatur = basetemperature(GetLocalInt(oModule, sDayBefore) - 100);
        SetLocalInt(oModule, sDay, iTemperatur + 100);
    } else {
        iTemperatur = temperature(GetLocalInt(oModule, sDay) - 100);
    }


    //////////////////////////
    // Wind
    //////////////////////////

    // Possible: N, NO, O, SO, S, SW, W, NW
    // Sehr stark (5), Strong (4), medium (3), weak (2), windstill (1)
    int iWindStrength = 1;
    if (GetLocalInt(oModule, "windstrength") == 0) {
        SetLocalInt(oModule, "windstrength", 1);
    } else {
        iWindStrength = GetLocalInt(oModule, "windstrength");
    }
    int iRand = Random(10);
    if (iRand > 8) {
        // Make wind stronger
        if (iWindStrength < 5) iWindStrength = iWindStrength + 1;
    } else if (iRand < 4) {
        // Make wind weaker
        if (iWindStrength > 1) iWindStrength = iWindStrength - 1;
    }
    SetLocalInt(oModule, "windstrength", iWindStrength);
    string sWindDirection = "Ostwind";
    if (GetTimeHour() < 9 && GetTimeHour() > 19) {
        iRand = Random(3);
        if (iRand == 0) sWindDirection = "Südwestwind";
        if (iRand == 1) sWindDirection = "Westwind";
        if (iRand == 2) sWindDirection = "Nordwestwind";
    } else {
        if (iRand == 0) sWindDirection = "Südostwind";
        if (iRand == 1) sWindDirection = "Ostwind";
        if (iRand == 2) sWindDirection = "Nordostwind";
    }
    SetLocalString(oModule, "sWindDirection", sWindDirection);

    setWindForAreas(iWindStrength);


    //////////////////////////
    // Rain & Snow
    //////////////////////////

    // Rain (2), Snow (3), Clear (1)
    int iRain = 1;
    if (GetLocalInt(oModule, "rain") == 0) {
        SetLocalInt(oModule, "rain", 1);
    } else {
        iRain = GetLocalInt(oModule, "rain");
    }
    if (iRain == 1) {
        if (Random(100) > 95) {
            if (iTemperatur > 1) {
                iRain = 2;
                SetWeather(oModule, WEATHER_RAIN);
                SetLocalInt(oModule, "rain", 2);
            } else {
                iRain = 3;
                SetWeather(oModule, WEATHER_SNOW);
                SetLocalInt(oModule, "rain", 3);
            }
        }
    } else if (iRain == 2 || iRain == 3) {
        if (Random(100) > 90) {
            iRain = 1;
            SetLocalInt(oModule, "rain", 1);
            SetWeather(oModule, WEATHER_CLEAR);
        }
    }

    //////////////////////////
    // Fog
    //////////////////////////

    // Set fog times for a new day
    if (GetLocalInt(oModule, sDay + "fog_start") == 0) {
        // Fog start time
        int iFogStart = d6();
        SetLocalInt(oModule, sDay + "fog_start", iFogStart);
        // Fog end time
        SetLocalInt(oModule, sDay + "fog_end", iFogStart + d6() + d6());
    }
    // Set fog for the right areas
    int iHeight = Random(2);
    setFog(sDay, sDayBefore, iTemperatur, iHeight, iWindStrength, iRain, oModule, GetObjectByTag("AREA_Freihafen"));
    setFog(sDay, sDayBefore, iTemperatur, iHeight, iWindStrength, iRain, oModule, GetObjectByTag("AREA_Banditenfestung"));
    setFog(sDay, sDayBefore, iTemperatur, iHeight, iWindStrength, iRain, oModule, GetObjectByTag("AREA_Insel"));
    setFog(sDay, sDayBefore, iTemperatur, iHeight, iWindStrength, iRain, oModule, GetObjectByTag("AREA_Hgelland"));
    setFog(sDay, sDayBefore, iTemperatur, iHeight, iWindStrength, iRain, oModule, GetObjectByTag("AREA_versteckterHain"));
    setFog(sDay, sDayBefore, iTemperatur, iHeight, iWindStrength, iRain, oModule, GetObjectByTag("AREA_Westmark"));

    //SetTime(Random(24), 0, 0, 0);
    DelayCommand(504.0, weather());
}

void saveFog(object oArea) {
    SetLocalInt(oArea, "fog_sun", GetFogAmount(FOG_TYPE_SUN, oArea));
    SetLocalInt(oArea, "fog_moon", GetFogAmount(FOG_TYPE_MOON, oArea));
    SetLocalInt(oArea, "fog", 0);
}
