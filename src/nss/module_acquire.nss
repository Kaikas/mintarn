#include "global_money"

void main() {
    object oItem = GetModuleItemAcquired();
    object oPc = GetModuleItemAcquiredBy();
    object oPcPosessor = GetItemPossessor(oItem);
    object oLostBy = GetModuleItemAcquiredFrom();

/*    if(GetIsObjectValid(oPc)) {
        int iGold = MONEY_CountCoins(oPc);
        if (iGold > 1000) {

        }
    }
*/
}


// Not used
//#include "x2_inc_switches"
// * Generic Item Script Execution Code
// * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
// * it will execute a script that has the same name as the item's tag
// * inside this script you can manage scripts for all events by checking against
// * GetUserDefinedItemEventNumber(). See x2_it_example.nss
/*if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
{
SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
if (nRet == X2_EXECUTE_SCRIPT_END)
{
   return;
}

}
*/
