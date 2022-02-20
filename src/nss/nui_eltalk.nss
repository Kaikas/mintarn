#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();
    json jRow = JsonArray();

    json jTextContent = JsonString("Beschreibt was euer Charakter gerne machen " +
        "würde. Diese Information landet bei der Spielleitung, welche darauf reagieren " +
        "kann.");
    json jText = NuiText(NuiBind("text"));
    jText = NuiHeight(jText, 100.0f);
    jText = NuiId(jText, "text");
    json jButtonSelect = NuiButton(JsonString("Senden"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    json jInput = NuiTextEdit(JsonString("Freitext"), NuiBind("input"), 1000, TRUE);
    jInput = NuiHeight(jInput, 100.0);
    jInput = NuiHeight(jInput, 200.0f);

    jCol = JsonArrayInsert(JsonArray(), jText);
    jCol2 = JsonArrayInsert(JsonArray(), jInput);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));

    json jRoot = NuiCol(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("Geschichtsbuch"),
        NuiRect(-1.0, -1.0, 320.0, 400.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "eltalk");

    NuiSetBind(oPc, token, "text", jTextContent);
    NuiSetBindWatch(oPc, token, "input_watch", TRUE);
    NuiSetBind(oPc, token, "input", JsonString(""));
}
