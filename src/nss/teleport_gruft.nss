// Teleportiert den Spieler in die Gruft
void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_GRUFT"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
