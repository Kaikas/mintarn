void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Wache"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
