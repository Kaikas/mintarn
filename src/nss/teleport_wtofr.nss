void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Friedhof"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
