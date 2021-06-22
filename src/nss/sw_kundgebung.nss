void main() {
    object oPc = GetLastUsedBy();
    string sMessage = "";
    if (GetTag(OBJECT_SELF) == "OBELISK_TAVERNE") {
        sMessage = "<cuuu>Ein Signal der Götter! " + GetName(oPc) + " hat den Obelisk in Freihafen bei der Taverne \"Zum rettenden Ufer\" benutzt.";
    }

    object oTarget = GetFirstPC();
    while (oTarget != OBJECT_INVALID) {
        SendMessageToPC(oTarget, sMessage);
        oTarget = GetNextPC();
    }
}
