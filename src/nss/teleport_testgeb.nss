void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_Testgebiet"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}


