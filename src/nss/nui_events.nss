#include "nw_inc_nui"
#include "global_money"

int CountItems(object oPc, string sTag) {
    int iResult = 0;
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (sTag == GetScriptParam("item")) {
            iResult = iResult + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return iResult;
}

void main()
{
    object oPc = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sWindowId  = NuiGetWindowId(oPc, nToken);
    string sType = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();
    json jPayload = NuiGetEventPayload();

    /*
    SendMessageToPC(oPc, "" +
        "\nEVENTTYPE: " + sType +
        "\nELEMENT: " + sElement +
        "\nARRAYINDEX: " + IntToString(nArrayIndex) +
        "\nPAYLOAD: " + JsonDump(jPayload));
    */
    //"Token: " + IntToString(nToken) +
    //"\nWindowID:" + sWindowId +

    if (sWindowId == "downtime") {

        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                // Tagewerk
                if (JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected")) == 1) {
                    if (CountItems(oPc, "CRAFT_Aktivität")) {
                        MONEY_GiveCoinMoneyWorth(200, oPc);
                    } else {
                        SendMessageToPC(oPc, "Ihr habt nicht genügend Aktivitätstoken");
                    }
                }
            }
        }
        if (sType == "watch" && sElement == "dropdownbox_selected") {
            if (JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected")) == 1) {
                SendMessageToPC(oPc, "Tagewerk");
                NuiSetBind(oPc, nToken, "text", JsonString("Tagewerk: Ihr geht einem Beruf nach. "));
            }
            SendMessageToPC(oPc, "\nSELECTED: " + IntToString(JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected"))) + "\n");
        }
    }

}
