void main() {
    object oPc = GetPCSpeaker();
    if (GetLocalInt(oPc, "wuerfel_placed") > 20) {
        SendMessageToPC(oPc, "Ihr könnt keine weiteren Gegenstände mehr platzieren. Löscht alte Gegenstände um mehr platzieren zu können.");
    } else {
        SetLocalInt(oPc, "wuerfel_placed", GetLocalInt(oPc, "wuerfel_placed") + 1);
        string sArea = GetLocalString(oPc, "wuerfel_area");
        object oArea = GetObjectByTag(sArea);
        vector vPosition;
        vPosition.x = GetLocalFloat(oPc, "wuerfel_x");
        vPosition.y = GetLocalFloat(oPc, "wuerfel_y");
        vPosition.z = GetLocalFloat(oPc, "wuerfel_z");
        float fFacing = GetLocalFloat(oPc, "wuerfel_facing");
        location locTarget = Location(oArea, vPosition, fFacing);
        object oCreated = CreateObject(OBJECT_TYPE_PLACEABLE, GetScriptParam("place"), locTarget);
        string sAccountName = GetPCPlayerName(oPc);
        string sName = GetName(oPc);
        SetLocalString(oCreated, "createdby", sAccountName + "_" + sName);
    }
}
