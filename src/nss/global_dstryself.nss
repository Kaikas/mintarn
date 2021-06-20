void main() {
    object oPc = GetPlaceableLastClickedBy();
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    if (GetLocalString(OBJECT_SELF, "createdby") == sAccountName + "_" + sName) {
        DestroyObject(OBJECT_SELF);
        SetLocalInt(oPc, "wuerfel_placed", GetLocalInt(oPc, "wuerfel_placed") - 1);
    }
    if (GetIsDM(oPc)) {
        SendMessageToPC(oPc, "Created by: " + GetLocalString(OBJECT_SELF, "createdby"));
        DestroyObject(OBJECT_SELF);
    }
}
