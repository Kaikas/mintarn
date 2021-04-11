void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Banditenfestung_Huegel"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
