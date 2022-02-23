#include "nw_inc_nui"

int MAX_PLAYERS = 15;

void main() {
    object oPc = OBJECT_SELF;

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
        jCol = JsonArrayInsert(jCol, jCheck);
    }

    json jTextField = NuiText(NuiBind("chatbox"));
    jTextField = NuiHeight(jTextField, 200.0f);
    jTextField = NuiWidth(jTextField, 650.0f);
    jCol2 = JsonArrayInsert(jCol2, jTextField);

    json jInput = NuiTextEdit(JsonString(""), NuiBind("input"), 1000, FALSE);
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
