// Teleportiert den Spieler in den Hain
void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_HAIN"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
