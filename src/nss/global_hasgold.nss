int StartingConditional() {
    object oPc = GetPCSpeaker();
    if (GetGold(oPc) >= StringToInt(GetScriptParam("gold"))) {
        return TRUE;
    }
    return FALSE;
}
