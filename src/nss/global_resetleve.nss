void main() {
    object oPc = GetLastUsedBy();
    int iXp = GetXP(oPc);
    SetXP(oPc, 0);
    SetXP(oPc, iXp);
    SendMessageToPC(oPc, "Level zurückgesetzt.");
}
