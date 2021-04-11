// Teleportiert den Spieler nach Siebenwind
void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_SIEBENWIND"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
