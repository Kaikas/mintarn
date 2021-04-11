void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("TELEPORT_Huegelland_AlteHuette"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
