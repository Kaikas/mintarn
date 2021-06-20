void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Huegel_Banditenfestung"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
