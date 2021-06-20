void main() {
    // Hier �ndern
    string sDoor = "DOOR_OOC"; // Tag der T�r
    float fDelay = 10.0f; // 60 Sekunden
    string sMessage = "Die T�r ist nun offen."; // Nachricht an den Spieler

    // Script
    object oPc = GetLastUsedBy();
    SendMessageToPC(oPc, sMessage);
    object oDoor = GetObjectByTag(sDoor);
    SetLocked(oDoor, FALSE);
    DelayCommand(fDelay,ActionCloseDoor(oDoor));
    DelayCommand(fDelay, SetLocked(oDoor, TRUE));
}
