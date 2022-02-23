#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;

    json jRow = JsonArray();
    json jCol = JsonArray();
    json jCol2 = JsonArray();

    object oPlayer = GetFirstPC();
    while(GetIsObjectValid(oPlayer)) {
        json jCheck = NuiCheck(JsonString(GetSubString(GetName(oPlayer) + " (" + GetName(GetArea(oPlayer)) + ")", 0, 30)), NuiBind("check"));
        jCol = JsonArrayInsert(jCol, jCheck);
        oPlayer = GetNextPC();
    }

    json jTextField = NuiText(NuiBind("chatbox"));
    jTextField = NuiHeight(jTextField, 200.0f);
    jCol2 = JsonArrayInsert(jCol2, jTextField);


    /*
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();
    json jRow = JsonArray();

    json jTextContent = JsonString("Dies sind Aktivitäten denen euer " +
        "Charakter nachgehen kann, während ihr nicht eingeloggt seid.");
    json jText = NuiText(NuiBind("text"));
    jText = NuiId(jText, "text");
    json jButtonSelect = NuiButton(JsonString("Wählen"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    //json jInput = NuiTextEdit(JsonString("Freitext zur Beschreibung der Aktivität."), NuiBind("input"), 1000, TRUE);
    //jInput = NuiHeight(jInput, 100.0);
    //jInput = NuiId(jInput, "input");

    jCol = JsonArrayInsert(JsonArray(), jText);
    //jCol2 = JsonArrayInsert(JsonArray(), jInput);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    //jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));


    */
    jRow = JsonArrayInsert(jRow, NuiCol(jCol));
    jRow = JsonArrayInsert(jRow, NuiCol(jCol2));
    json jRoot = NuiRow(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("EL Tools"),
        NuiRect(-1.0, -1.0, 1000.0, 400.0),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "eltools");

    NuiSetBind(oPc, token, "chatbox", JsonString("Chatbox"));
    /*
    NuiSetBind(oPc, token, "dropdownbox_selected", jDropdownboxElement);
    NuiSetBindWatch(oPc, token, "dropdownbox_selected", TRUE);
    NuiSetBindWatch(oPc, token, "dropdownbox", TRUE);
    NuiSetBindWatch(oPc, token, "select_downtime", TRUE);
    NuiSetBind(oPc, token, "text", jTextContent);
    //NuiSetBindWatch(oPc, token, "input_watch", TRUE);
    //NuiSetBind(oPc, token, "input", JsonString(""));
    */
}
