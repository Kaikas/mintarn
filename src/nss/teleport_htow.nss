void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Wald_Huegel"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
