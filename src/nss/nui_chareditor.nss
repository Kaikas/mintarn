#include "nw_inc_nui"

const int MAX_PLAYERS = 15;

void main() {
    object oPc = OBJECT_SELF;

    json jRow = JsonArray();
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();

    json jButtonChoose = NuiButton(JsonString("Wählen"));
    jButtonChoose = NuiId(jButtonChoose, "button_choose");

    json jButtonSave = NuiButton(JsonString("Speichern"));
    jButtonSave = NuiId(jButtonSave, "button_save");

    jCol3 = JsonArrayInsert(jCol3, jButtonChoose);
    jCol3 = JsonArrayInsert(jCol3, jButtonSave);

    jCol2 = JsonArrayInsert(jCol2, NuiRow(jCol3));

    jRow = JsonArrayInsert(jRow, NuiCol(jCol));
    jRow = JsonArrayInsert(jRow, NuiCol(jCol2));
    json jRoot = NuiRow(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("Chareditor"),
        NuiRect(-1.0, -1.0, 990.0, 350.0),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "chareditor");
}
