void main() {
    object oPc = GetPCSpeaker();
    int iChance = GetLocalInt(oPc, "SW_PLACER_CHANCE");
    if (iChance < 100) {
        SetLocalInt(oPc, "SW_PLACER_CHANCE", iChance + 5);
        SetCustomToken(8000, IntToString(GetLocalInt(oPc, "SW_PLACER_CHANCE")));
    }
}
