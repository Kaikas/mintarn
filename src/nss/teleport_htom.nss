void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Huegelland_Mine"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
