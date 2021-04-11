void main() {
    object oPc = GetLastUsedBy();
    if (GetLocalInt(OBJECT_SELF, "light") == 1) {
        SendMessageToPC(oPc, "off");
        SetLocalInt(OBJECT_SELF, "light", 0);
        int i;
        DestroyObject(GetNearestObjectByTag("LIGHT_1"));
        DestroyObject(GetNearestObjectByTag("LIGHT_2"));
        DestroyObject(GetNearestObjectByTag("LIGHT_3"));
        DestroyObject(GetNearestObjectByTag("LIGHT_4"));
        RecomputeStaticLighting(GetArea(oPc));
    } else {
        SendMessageToPC(oPc, "on");
        SetLocalInt(OBJECT_SELF, "light", 1);
        int i;
        object oLight1 = CreateObject(OBJECT_TYPE_PLACEABLE, "lightwhite", GetLocation(GetNearestObjectByTag("INVISIBLE_LIGHT")));
        SetTag(oLight1, "LIGHT_1");
        object oLight2 = CreateObject(OBJECT_TYPE_PLACEABLE, "lightwhite", GetLocation(GetNearestObjectByTag("INVISIBLE_LIGHT")));
        SetTag(oLight2, "LIGHT_2");
        object oLight3 = CreateObject(OBJECT_TYPE_PLACEABLE, "lightwhite", GetLocation(GetNearestObjectByTag("INVISIBLE_LIGHT")));
        SetTag(oLight3, "LIGHT_3");
        object oLight4 = CreateObject(OBJECT_TYPE_PLACEABLE, "lightwhite", GetLocation(GetNearestObjectByTag("INVISIBLE_LIGHT")));
        SetTag(oLight4, "LIGHT_4");
        RecomputeStaticLighting(GetArea(oPc));
    }
}
