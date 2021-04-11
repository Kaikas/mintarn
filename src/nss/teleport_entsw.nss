// Teleportiert den Spieler zurück vom Ort der Ents
void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_ENTSW"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
