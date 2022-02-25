#include "nw_inc_nui"
#include "global_money"
#include "nwnx_webhook"
#include "nwnx_util"
#include "x3_inc_string"
#include "inc_perchest"
#include "nwnx_sql"
#include "nwnx_chat"
#include "inc_nui_downtime"
#include "inc_nui_eltools"


void main() {
    object oPc = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sWindowId  = NuiGetWindowId(oPc, nToken);
    string sType = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();
    json jPayload = NuiGetEventPayload();

    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);

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
        DowntimeEvents(oPc, nToken, sType, sElement);
    }

    if (sWindowId == "eltalk") {
        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                    SetLocalString(oPc, "nui_message", "Eure Nachricht ist bei der Spielleitung angekommen.");
                    //SendMessageToPC(oPc, JsonDump(NuiGetBind(oPc, nToken, "input")));
                    string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_DM");
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " (" + sName +
                        ") " +
                        StringReplace(StringReplace(JsonGetString(NuiGetBind(oPc, nToken, "input")), "\"", ""), "\n", ""), "Mintarn");

                    NuiDestroy(oPc, nToken);
                    ExecuteScript("nui_message", oPc);
            }
        }
    }
    if (sWindowId == "changeitem") {
        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                string sItemName = StringReplace(StringReplace(JsonGetString(NuiGetBind(oPc, nToken, "inputname")), "\n", " "), "\"", "");
                string sDescription = JsonGetString(NuiGetBind(oPc, nToken, "inputdescription"));
                object oTarget = GetLocalObject(oPc, "changename");
                if (oTarget != OBJECT_INVALID) {
                  SetName(oTarget, sItemName);
                  SetDescription(oTarget, sDescription);
                  string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS");
                  NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " (" + sName +
                        ") " +
                        "Changeitem: " + sItemName + " -> " + StringReplace(StringReplace(sDescription, "\"", ""), "\n", ""), "Mintarn");
                }
                NuiDestroy(oPc, nToken);
            }
        }
    }
    if (sWindowId == "changedesc") {
        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                string sDescription = JsonGetString(NuiGetBind(oPc, nToken, "inputdescription"));
                if (oPc != OBJECT_INVALID) {
                  SetDescription(oPc, sDescription);
                }
                NuiDestroy(oPc, nToken);
            }
        }
    }
    if (sWindowId == PC_NUI_WINDOW_ID) {
        PC_HandleNUIEvents(oPc, nToken, sType, sElement, nArrayIndex);
    }
    if (sWindowId == "changegod") {
        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                string sGod = JsonGetString(NuiGetBind(oPc, nToken, "inputgod"));
                if (oPc != OBJECT_INVALID) {
                  SetDeity(oPc, sGod);
                }
                NuiDestroy(oPc, nToken);
            }
        }
    }
    if (sWindowId == "eltools") {
        EltoolsEvents(oPc, nToken, sType, sElement);
    }
}
