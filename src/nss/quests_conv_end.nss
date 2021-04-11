#include "global_helper"

// Entscheidet ob einem Spieler eine Dialogoption angeboten wird
int StartingConditional() {
    // Anzahl der Gegenstände die im Inventar sein müssen
    int iCount;
    // Tag des Gegenstands der im Inventar sein muss
    string sItem;
    // TODO: Aus der Datenbank lesen
    if (GetTag(OBJECT_SELF) == "NPC_Kastin") {
        sItem = "BlauerPilz";
        iCount = 3;
    }
    if (GetTag(OBJECT_SELF) == "NPC_Gard") {
        sItem = "MagischesBuch";
        iCount = 1;
    }
    if (GetTag(OBJECT_SELF) == "NPC_Verrio") {
        sItem = "Knochenamulett";
        iCount = 1;
    }

    // Zähle die items und gebe TRUE zurück wenn es genug sind
    object oPc = GetPCSpeaker();
    object oItem = GetFirstItemInInventory(oPc);
    int i = 0;
    while (oItem != OBJECT_INVALID)
    {
        if (GetTag(oItem) == sItem) {
            i++;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    MessageAll("TAG: " + GetTag(OBJECT_SELF));
    MessageAll("iCount: " + IntToString(i));
    MessageAll("sItem: " + sItem);
    if (i >= iCount) {
        return TRUE;
    } else {
        return FALSE;
    }
}
