void main() {
    object oPc = GetLastUsedBy();
    location lStart = GetLocation(GetObjectByTag("WP_WESTMARK_TEST"));
    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}


