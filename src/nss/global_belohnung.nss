void main() {
    object oPc = GetPCSpeaker();
    object oTarget = GetLocalObject(oPc, "target");
    int iLevel = GetHitDice(oTarget);
    int iRequiredXp = ((iLevel + 1) * (iLevel) / 2) * 1000;
    if (iRequiredXp == 0) iRequiredXp = 3000;
    if (GetScriptParam("belohnung") == "klein") {
        SendMessageToPC(oPc, "Kleine Belohnung and " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt eine Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100);
    }
    if (GetScriptParam("belohnung") == "mittel") {
        SendMessageToPC(oPc, "Gro�e Belohnung and " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt eine gro�e Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100 * 2);
    }
    if (GetScriptParam("belohnung") == "gro�") {
        SendMessageToPC(oPc, "Au�erordentliche Belohnung and " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt eine au�erordenliche Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100 * 3);
    }
}
