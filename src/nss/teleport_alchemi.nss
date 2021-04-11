void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Alchemist"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
