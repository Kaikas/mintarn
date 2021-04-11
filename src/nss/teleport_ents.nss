// Teleportiert den Spieler in den Ort der Ents
void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_ENTS"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
