// Bestimmt ob eine Aufgabe als Dialogoption einem Spieler gegeben werden soll
int StartingConditional() {
    // TODO: SQL Abfrage
    if (GetTag(OBJECT_SELF) == "NPC_Kastin") {
        return TRUE;
    }
    return FALSE;
}
