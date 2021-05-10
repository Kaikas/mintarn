// This script goes into stores' OnOpen event, and converts coin money
// back into ingame money, so that it can be used for purchasing.
#include "global_money"

void main()
{
    object oPC = GetLastOpenedBy();
    if (!GetIsPC(oPC))
        return;

    if (!GetLocalInt(oPC, "COIN_DESTRUCTION_PREVENTION"))
        {
        MONEY_TurnCoinsIntoGP(oPC);
        SetLocalInt(oPC, "COIN_DESTRUCTION_PREVENTION", TRUE);
        DelayCommand(0.1, DeleteLocalInt(oPC, "COIN_DESTRUCTION_PREVENTION"));
        }
}


