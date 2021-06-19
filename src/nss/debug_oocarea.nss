void main() {
    // Hier ändern
    string sDoor = "DOOR_OOC"; // Tag der Tür
    float fDelay = 10.0f; // 60 Sekunden
    string sMessage = "Die Tür ist nun offen."; // Nachricht an den Spieler

    // Script
    object oPc = GetLastUsedBy();
    SendMessageToPC(oPc, sMessage);
    object oDoor = GetObjectByTag(sDoor);
    SetLocked(oDoor, FALSE);
    DelayCommand(fDelay,ActionCloseDoor(oDoor));
    DelayCommand(fDelay, SetLocked(oDoor, TRUE));
}
