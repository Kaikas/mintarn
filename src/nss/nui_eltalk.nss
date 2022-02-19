#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();
    json jRow = JsonArray();

    json jTextContent = JsonString("Beschreibt was euer Charakter gerne machen " +
        "würde. Diese Information landet bei der Spielleitung, welche darauf reagieren " +
        "kann.\n\n" +
        "Hier könnt ihr Einfluss auf die Spielwelt nehmen und in Absprache mit " +
        "einem EL die Welt verändern. Ihr könnt dies aber auch als Tagebuch " +
        "verwenden. In jedem Fall soll dies die Kommunikation zwischen euch und " +
        "der Spielleitung verbessern.");
    json jText = NuiText(NuiBind("text"));
    jText = NuiId(jText, "text");
    json jButtonSelect = NuiButton(JsonString("Senden"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    json jInput = NuiTextEdit(JsonString("Freitext zur Beschreibung der Aktivität."), NuiBind("input"), 1000, TRUE);
    jInput = NuiHeight(jInput, 100.0);

    jCol = JsonArrayInsert(JsonArray(), jText);
    jCol2 = JsonArrayInsert(JsonArray(), jInput);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));

    json jRoot = NuiCol(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("Geschichten und Tagebücher"),
        NuiRect(-1.0, -1.0, 330.0, 400.0),
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
