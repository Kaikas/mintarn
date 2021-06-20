void main() {
    object oPc = GetPCSpeaker();
    SetCustomToken(8000, IntToString(GetLocalInt(oPc, "SW_PLACER_CHANCE")));
}
