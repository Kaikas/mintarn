// This script goes into stores' OnClosed event, and converts ingame money
// into coin money.
// To alter the currency values or add or remove coin types, view "inc_money".
#include "global_money"

void main()
{
    object oPC = GetLastClosedBy();
    int nGold  = GetGold(oPC);

    if (!GetIsPC(oPC) || !nGold)
        return;

    // Give coin money:
    MONEY_GiveCoinMoneyWorth(nGold, oPC);

    // Destroy the ingame-gold of the player:
    TakeGoldFromCreature(nGold, oPC, TRUE);
}


