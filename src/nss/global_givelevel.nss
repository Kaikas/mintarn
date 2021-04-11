void main() {
    object oPc = GetPCSpeaker();
    int iLevel = StringToInt(GetScriptParam("level"));
    if (iLevel == 3) SetXP(oPc, 9000);
    if (iLevel == 4) SetXP(oPc, 27000);
    if (iLevel == 5) SetXP(oPc, 65000);
    if (iLevel == 6) SetXP(oPc, 140000);
    if (iLevel == 7) SetXP(oPc, 230000);
    if (iLevel == 8) SetXP(oPc, 340000);
    if (iLevel == 9) SetXP(oPc, 480000);
    if (iLevel == 10) SetXP(oPc, 640000);
    if (iLevel == 11) SetXP(oPc, 850000);
    if (iLevel == 12) SetXP(oPc, 1000000);
    if (iLevel == 13) SetXP(oPc, 1200000);
    if (iLevel == 14) SetXP(oPc, 1400000);
    if (iLevel == 15) SetXP(oPc, 1650000);
}
