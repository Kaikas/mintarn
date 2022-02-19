#include "nw_inc_nui"
#include "global_money"
#include "nwnx_webhook"
#include "nwnx_util"
#include "x3_inc_string"

int CountItems(object oPc, string sTag) {
    int iResult = 0;
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (sTag == GetTag(oItem)) {
            iResult = iResult + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return iResult;
}

void DestroyItem(object oPc, string sTag) {
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (sTag == GetTag(oItem)) {
            if (GetItemStackSize(oItem) > 1) {
                SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            } else {
                DestroyObject(oItem);
            }
            return;
        }
        oItem = GetNextItemInInventory(oPc);
    }
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
                    if (CountItems(oPc, "CRAFT_Aktivitaet")) {
                        DestroyItem(oPc, "CRAFT_Aktivitaet");
                        MONEY_GiveCoinMoneyWorth(1000, oPc);
                        SetLocalString(oPc, "nui_message", "Für eure Arbeit habt ihr 10 Gold erhalten.");
                        //SendMessageToPC(oPc, JsonDump(NuiGetBind(oPc, nToken, "input")));
                        string sAccountName = GetPCPlayerName(oPc);
                        string sName = GetName(oPc);
                        string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_DOWNTIME");
                        NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " (" + sName +
                            ") hat die Aktivität Tagewerk gewählt und dafür 10 Gold erhalten.", "Mintarn");
                        //StringReplace(JsonGetString(NuiGetBind(oPc, nToken, "input")), "\n", " ")
                        NuiDestroy(oPc, nToken);
                        ExecuteScript("nui_message", oPc);
                    } else {
                        NuiDestroy(oPc, nToken);
                        SetLocalString(oPc, "nui_message", "Ihr habt nicht genügend Aktivitätstoken!");
                        ExecuteScript("nui_message", oPc);
                    }
                }
            }
        }
        if (sType == "watch" && sElement == "dropdownbox_selected") {
            if (JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected")) == 1) {
                NuiSetBind(oPc, nToken, "text", JsonString("Tagewerk: Ihr geht einem Beruf nach. "));
            }
        }
    }

    if (sWindowId == "eltalk") {
        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                    SetLocalString(oPc, "nui_message", "Eure Nachricht ist bei der Spielleitung angekommen.");
                    //SendMessageToPC(oPc, JsonDump(NuiGetBind(oPc, nToken, "input")));
                    string sAccountName = GetPCPlayerName(oPc);
                    string sName = GetName(oPc);
                    string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_DM");
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " (" + sName +
                        ") " +
                        StringReplace(StringReplace(JsonGetString(NuiGetBind(oPc, nToken, "input")), "\n", " "), "\"", ""), "Mintarn");

                    NuiDestroy(oPc, nToken);
                    ExecuteScript("nui_message", oPc);
            }
        }
    }
}
