#include "global_money"

void main() {
    int iHealLevel = StringToInt(GetScriptParam("heal_level"));
    object oPc = GetPCSpeaker();
    object oCleric = OBJECT_SELF;
    int iGold = 50;

    if (iHealLevel == 2) {
        iGold = 250;
    }

    if (MONEY_CountCoins(oPc) >= iGold) {
        MONEY_TakeCoinMoneyWorth(iGold, oPc);
        if (iHealLevel == 1) {
           AssignCommand(oCleric, ActionCastSpellAtObject(SPELL_HEAL, oPc, 0, TRUE));
        }
        if(iHealLevel == 2) {
            AssignCommand(oCleric, ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oPc, 0, TRUE));
        }
    } else {
        SendMessageToPC(oPc, "Ihr könnt euch das nicht leisten.");
    }


}
