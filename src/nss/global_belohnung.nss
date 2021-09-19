#include "global_money"

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
        SendMessageToPC(oPc, "Große Belohnung and " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt eine große Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100 * 2);
    }
    if (GetScriptParam("belohnung") == "groß") {
        SendMessageToPC(oPc, "Außerordentliche Belohnung and " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt eine außerordenliche Belohnung erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iRequiredXp / 100 * 3);
    }
    if (GetScriptParam("belohnung") == "goldklein") {
        SendMessageToPC(oPc, "10 Kupfer an " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt ein paar Münzen erhalten.");
        MONEY_GiveCoinMoneyWorth(10, oTarget);
    }
    if (GetScriptParam("belohnung") == "goldmittel") {
        SendMessageToPC(oPc, "5 Silber an " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt ein paar Münzen erhalten.");
        MONEY_GiveCoinMoneyWorth(50, oTarget);
    }
    if (GetScriptParam("belohnung") == "goldgross") {
        SendMessageToPC(oPc, "1 Gold an " + GetName(oTarget) + " vergeben");
        SendMessageToPC(oTarget, "Ihr habt ein paar Münzen erhalten.");
        MONEY_GiveCoinMoneyWorth(100, oTarget);
    }
}
