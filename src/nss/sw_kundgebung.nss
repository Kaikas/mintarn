#include "global_helper"

void main() {
    object oPc = GetLastUsedBy();
    // Prevent spam
    if (GetLocalInt(oPc, "KUNDGEBUNG") == 0) {
        SetLocalInt(oPc, "KUNDGEBUNG", 1);
        DelayCommand(600.0f, SetLocalInt(oPc, "KUNDGEBUNG", 0));

        string sMessage = "";
        if (GetTag(OBJECT_SELF) == "RP_ZumRettendenUfer") {
            sMessage = GetToken(102) + GetName(oPc) + " sucht bei der Taverne \"Zum Rettenden Ufer\" nach Rollenspiel.</c>";
        }

        object oTarget = GetFirstPC();
        while (oTarget != OBJECT_INVALID) {
            SendMessageToPC(oTarget, sMessage);
            oTarget = GetNextPC();
        }
    }
}

