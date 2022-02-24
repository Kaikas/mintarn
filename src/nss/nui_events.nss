#include "nw_inc_nui"
#include "global_money"
#include "nwnx_webhook"
#include "nwnx_util"
#include "x3_inc_string"
#include "nwnx_sql"
#include "nwnx_chat"

const int MAX_PLAYERS = 15;

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

void SetChatbox(object oPc, int nToken) {
    string sQuery = "SELECT * FROM Chat ORDER BY id DESC LIMIT 50";
    string sText = "";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            sText = sText + NWNX_SQL_ReadDataInActiveRow(2) + " " + NWNX_SQL_ReadDataInActiveRow(3) + "\n";
        }
    }
    NuiSetBind(oPc, nToken, "chatbox", JsonString(sText));
    if (GetIsDMPossessed(oPc)) SendMessageToPC(oPc, "is being posessed");
    if (NuiGetWindowId(oPc, nToken) != "") DelayCommand(5.0f, SetChatbox(oPc, nToken));
}

void SetPlayerList(object oPc, int nToken) {
    int i;
    for (i = 0; i < MAX_PLAYERS; i++) {
        NuiSetBind(oPc, nToken, "enabled_" + IntToString(i), JsonBool(FALSE));
    }
    object oPlayer = GetFirstPC();
    i = 0;
    while(GetIsObjectValid(oPlayer)) {
        NuiSetBind(oPc, nToken, "player_" + IntToString(i),
            JsonString(GetSubString(GetName(oPlayer) + " (" +
                GetName(GetArea(oPlayer)) + ")", 0, 30)));
        NuiSetBind(oPc, nToken, "enabled_" + IntToString(i),
            JsonBool(TRUE));
        i++;
        oPlayer = GetNextPC();
    }
    if (NuiGetWindowId(oPc, nToken) != "") DelayCommand(5.0f, SetPlayerList(oPc, nToken));
}

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
        if (sType == "open") {
            SetChatbox(oPc, nToken);
            SetPlayerList(oPc, nToken);
        }
        if (sType == "click") {
            if (sElement == "button_send") {
                string sMessage = JsonGetString(NuiGetBind(oPc, nToken, "input"));
                SendMessageToPC(oPc, "Folgende Spieler haben euch vernommen:");
                SendMessageToAllDMs("Erzähler: " + sMessage);
                object oTalkTo = GetFirstPC();
                while (oTalkTo != OBJECT_INVALID) {
                    if (!GetIsDM(oTalkTo)) {
                      NWNX_Chat_SendMessage(4, sMessage, GetObjectByTag("ERZAEHLER"), oTalkTo);
                    }
                    SendMessageToPC(oPc, GetName(oTalkTo));
                  oTalkTo = GetNextPC();
                }
            }
            if (sElement == "button_send_selected") {
                int i;
                for (i = 0; i < MAX_PLAYERS; i++) {
                    if (NuiGetBind(oPc, nToken, "selected_" + IntToString(i)) == JsonBool(TRUE)) {
                        string sMessage = JsonGetString(NuiGetBind(oPc, nToken, "input"));
                        SendMessageToPC(oPc, "Folgende Spieler haben euch vernommen:");
                        SendMessageToAllDMs("Erzähler: " + sMessage);
                        object oTalkTo = GetFirstPC();
                        while (oTalkTo != OBJECT_INVALID) {
                            if (!GetIsDM(oTalkTo)) {
                                string sCompare = JsonGetString(NuiGetBind(oPc, nToken, "player_" + IntToString(i)));
                                string sCompare2 = GetSubString(GetName(oTalkTo) + " (" + GetName(GetArea(oTalkTo)) + ")", 0, 30);
                                if (sCompare == sCompare2) {
                                    NWNX_Chat_SendMessage(4, sMessage, GetObjectByTag("ERZAEHLER"), oTalkTo);
                                    SendMessageToPC(oPc, GetName(oTalkTo));
                                }
                            }
                          oTalkTo = GetNextPC();
                        }
                    }
                }
            }
        }
    }
    if (sWindowId == "sounds") {
        if (sType == "click") {
            SendMessageToPC(oPc, "Playing Emil");
            AssignCommand(oPc, PlaySound("emil"));

            object oSound = GetObjectByTag("Emil_Taverne");
            SoundObjectPlay(oSound);
        }
    }
}
