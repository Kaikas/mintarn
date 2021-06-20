// Teleportiert den Spieler in den Freihafen
void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_FREIHAFEN_LEDERER", 0));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
