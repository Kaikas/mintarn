#include "global_helper"

void main() {
    object oPc = GetLastUsedBy();
    // Prevent spam
    if (GetLocalInt(oPc, "KUNDGEBUNG") == 0) {
        SetLocalInt(oPc, "KUNDGEBUNG", 1);
        DelayCommand(600.0f, SetLocalInt(oPc, "KUNDGEBUNG", 0));

        string sMessage = "";
        if (GetTag(OBJECT_SELF) == "OBELISK_TAVERNE") {
            sMessage = GetToken(102) + "Ein Signal der Götter! " + GetName(oPc) + " hat den Obelisk in Freihafen bei der Taverne \"Zum rettenden Ufer\" benutzt.</c>";
        }

        object oTarget = GetFirstPC();
        while (oTarget != OBJECT_INVALID) {
            SendMessageToPC(oTarget, sMessage);
            oTarget = GetNextPC();
        }
    }
}
