void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Huegel_Lagerhoehle"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
