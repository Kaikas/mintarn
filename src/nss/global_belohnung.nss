void main() {
    object oPc = GetPCSpeaker();
    object oTarget = GetLocalObject(oPc, "target");
    int iLevel = GetHitDice(oTarget);
    int iRequiredXp = ((iLevel + 1) * (iLevel) / 2) * 1000;
    if (iRequiredXp == 0) iRequiredXp = 3000;
    if (GetScriptParam("belohnung") == "klein") {
        SendMessageToPC(oTarget, "Ihr habt eine Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100);
    }
    if (GetScriptParam("belohnung") == "mittel") {
        SendMessageToPC(oTarget, "Ihr habt eine groﬂe Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100 * 2);
    }
    if (GetScriptParam("belohnung") == "groﬂ") {
        SendMessageToPC(oTarget, "Ihr habt eine auﬂerordenliche Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100 * 3);
    }
}
