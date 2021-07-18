#include "global_money"

void main() {
    object oPc = GetPCSpeaker();
    object oTarget = GetLocalObject(oPc, "target");
    int iLevel = GetHitDice(oTarget);
    int iGiveXp = 1000;
    if (GetScriptParam("belohnung") == "klein") {
        SendMessageToPC(oTarget, "Ihr habt eine Belohnung erhalten.");
        SendMessageToPC(oPc, GetName(oTarget) + " hat " + IntToString(iGiveXp) + " EP erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iGiveXp);
    }
    if (GetScriptParam("belohnung") == "mittel") {
        SendMessageToPC(oTarget, "Ihr habt eine groﬂe Belohnung erhalten.");
        SendMessageToPC(oPc, GetName(oTarget) + " hat " + IntToString(iGiveXp) + " EP erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iGiveXp * 2);
    }
    if (GetScriptParam("belohnung") == "gross") {
        SendMessageToPC(oTarget, "Ihr habt eine auﬂerordenliche Belohnung erhalten.");
        SendMessageToPC(oPc, GetName(oTarget) + " hat " + IntToString(iGiveXp) + " EP erhalten.");
        SetXP(oTarget, GetXP(oTarget) + iGiveXp * 3);
    }
    if (GetScriptParam("belohnung") == "mklein") {
        MONEY_GiveCoinMoneyWorth(10, oTarget);
        SendMessageToPC(oTarget, "Ihr habt eine Belohnung erhalten.");
        SendMessageToPC(oPc, GetName(oTarget) + " hat 10 Kupfer erhalten.");
    }
    if (GetScriptParam("belohnung") == "mmittel") {
        MONEY_GiveCoinMoneyWorth(50, oTarget);
        SendMessageToPC(oTarget, "Ihr habt eine Belohnung erhalten.");
        SendMessageToPC(oPc, GetName(oTarget) + " hat 50 Kupfer erhalten.");
    }
    if (GetScriptParam("belohnung") == "mgross") {
        MONEY_GiveCoinMoneyWorth(100, oTarget);
        SendMessageToPC(oTarget, "Ihr habt eine Belohnung erhalten.");
        SendMessageToPC(oPc, GetName(oTarget) + " hat 100 Kupfer erhalten.");
    }
}
