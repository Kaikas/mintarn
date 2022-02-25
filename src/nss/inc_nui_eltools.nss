#include "nw_inc_nui"
#include "nwnx_webhook"
#include "nwnx_util"
#include "x3_inc_string"
#include "nwnx_sql"
#include "nwnx_chat"

int MAX_PLAYERS = 15;

object GetPlayerByName(string sName) {
    object oPlayer = GetFirstPC();
    while (GetIsObjectValid(oPlayer)) {
        if (GetName(oPlayer) == sName) return oPlayer;
        oPlayer = GetNextPC();
    }
    return oPlayer;
}

int CountSelectedCheckboxes(object oPc, int nToken) {
    int i, iCount;
    for (i = 0; i < MAX_PLAYERS; i++) {
        if (NuiGetBind(oPc, nToken, "selected2_" + IntToString(i)) == JsonBool(TRUE)) {
            iCount++;
        }
    }
    return iCount;
}

void SetChatbox(object oPc, int nToken) {
    string sQuery = "SELECT * FROM Chat ORDER BY id DESC LIMIT 50";
    string sText = "";
    int iSelectionCounter = CountSelectedCheckboxes(oPc, nToken);
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            if (iSelectionCounter == 0) {
                sText = sText + NWNX_SQL_ReadDataInActiveRow(2) + ": " + NWNX_SQL_ReadDataInActiveRow(3) + "\n";
            } else {
                int i;
                for (i = 0; i < MAX_PLAYERS; i++) {
                    string sCompare = JsonGetString(NuiGetBind(oPc, nToken, "player_" + IntToString(i)));
                    object oPlayer = GetPlayerByName(NWNX_SQL_ReadDataInActiveRow(2));
                    string sCompare2 = GetSubString(GetName(oPlayer) + " (" + GetName(GetArea(oPlayer)) + ")", 0, 30);
                    if (sCompare == sCompare2) {
                        if (NuiGetBind(oPc, nToken, "selected2_" + IntToString(i)) == JsonBool(TRUE)) {
                            sText = sText + NWNX_SQL_ReadDataInActiveRow(2) + ": " + NWNX_SQL_ReadDataInActiveRow(3) + "\n";
                        }
                    }
                }
            }
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

void EltoolsEvents(object oPc, int nToken, string sType, string sElement) {
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
            string sMessage = JsonGetString(NuiGetBind(oPc, nToken, "input"));
            SendMessageToAllDMs("Erzähler: " + sMessage);
            SendMessageToPC(oPc, "Folgende Spieler haben euch vernommen:");
            int i;
            for (i = 0; i < MAX_PLAYERS; i++) {
                if (NuiGetBind(oPc, nToken, "selected_" + IntToString(i)) == JsonBool(TRUE)) {
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

void EltoolsInit(object oPc) {
    json jRow = JsonArray();
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();

    object oPlayer = GetFirstPC();
    int i;
    for (i = 0; i < MAX_PLAYERS; i++) {
        json jCheck = NuiCheck(NuiBind("player_" + IntToString(i)), NuiBind("selected_" + IntToString(i)));
        jCheck = NuiVisible(jCheck, NuiBind("enabled_" + IntToString(i)));
        jCheck = NuiWidth(jCheck, 300.0f);
        jCheck = NuiHeight(jCheck, 20.0f);
        json jCheck2 = NuiCheck(NuiBind("player2_" + IntToString(i)), NuiBind("selected2_" + IntToString(i)));
        jCheck2 = NuiVisible(jCheck2, NuiBind("enabled_" + IntToString(i)));
        jCheck2 = NuiWidth(jCheck2, 20.0f);
        jCheck2 = NuiHeight(jCheck2, 20.0f);
        json jCheckColumn = JsonArray();
        jCheckColumn = JsonArrayInsert(jCheckColumn, jCheck2);
        jCheckColumn = JsonArrayInsert(jCheckColumn, jCheck);
        jCol = JsonArrayInsert(jCol, NuiRow(jCheckColumn));
    }

    json jTextField = NuiText(NuiBind("chatbox"));
    jTextField = NuiHeight(jTextField, 200.0f);
    jTextField = NuiWidth(jTextField, 650.0f);
    jCol2 = JsonArrayInsert(jCol2, jTextField);

    json jInput = NuiTextEdit(JsonString(""), NuiBind("input"), 1050, FALSE);
    jInput = NuiWidth(jInput, 650.0);

    jCol2 = JsonArrayInsert(jCol2, jInput);


    json jButtonSend = NuiButton(JsonString("Senden (Alle)"));
    jButtonSend = NuiId(jButtonSend, "button_send");

    jCol3 = JsonArrayInsert(jCol3, jButtonSend);

    json jButtonSendSelected = NuiButton(JsonString("Senden (Selektion)"));
    jButtonSendSelected = NuiId(jButtonSendSelected, "button_send_selected");

    jCol3 = JsonArrayInsert(jCol3, jButtonSendSelected);

    jCol2 = JsonArrayInsert(jCol2, NuiRow(jCol3));

    jRow = JsonArrayInsert(jRow, NuiCol(jCol));
    jRow = JsonArrayInsert(jRow, NuiCol(jCol2));
    json jRoot = NuiRow(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("EL Tools"),
        NuiRect(-1.0, -1.0, 990.0, 350.0),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "eltools");

    NuiSetBind(oPc, token, "chatbox", JsonString("Chatbox"));
    for (i = 0; i < MAX_PLAYERS; i++) {
        NuiSetBind(oPc, token, "player_" + IntToString(i), JsonString(""));
        NuiSetBind(oPc, token, "enabled_" + IntToString(i), JsonBool(FALSE));
    }
}
