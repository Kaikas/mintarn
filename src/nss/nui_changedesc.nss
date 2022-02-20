#include "nw_inc_nui"

void main() {
    object oPc = GetLastUsedBy();
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();
    json jRow = JsonArray();

    json jInputDescription = NuiTextEdit(JsonString("Beschreibung"), NuiBind("inputdescription"), 10000, TRUE);
    jInputDescription = NuiHeight(jInputDescription, 300.0f);
    jInputDescription = NuiWidth(jInputDescription, 300.0f);
    json jButtonSelect = NuiButton(JsonString("Speichern"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    jCol2 = JsonArrayInsert(JsonArray(), jInputDescription);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));

    json jRoot = NuiCol(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString(GetName(oPc)),
        NuiRect(-1.0, -1.0, 320.0, 400.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "changedesc");

    NuiSetBind(oPc, token, "inputdescription", JsonString(GetDescription(oPc)));
}
