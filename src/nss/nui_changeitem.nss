#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();
    json jRow = JsonArray();

    json jInputName = NuiTextEdit(JsonString("Name"), NuiBind("inputname"), 100, FALSE);
    jInputName = NuiId(jInputName, "inputname");
    json jInputDescription = NuiTextEdit(JsonString("Beschreibung"), NuiBind("inputdescription"), 10000, TRUE);
    jInputDescription = NuiHeight(jInputDescription, 250.0f);
    jInputDescription = NuiWidth(jInputDescription, 300.0f);
    json jButtonSelect = NuiButton(JsonString("Speichern"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    jCol = JsonArrayInsert(JsonArray(), jInputName);
    jCol2 = JsonArrayInsert(JsonArray(), jInputDescription);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));

    json jRoot = NuiCol(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("Name und Beschreibung"),
        NuiRect(-1.0, -1.0, 320.0, 400.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "changeitem");

    object oTarget = GetLocalObject(oPc, "changename");
    if (oTarget != OBJECT_INVALID) {
        NuiSetBind(oPc, token, "inputname", JsonString(GetName(oTarget)));
        NuiSetBind(oPc, token, "inputdescription", JsonString(GetDescription(oTarget)));
    } else {
        NuiSetBind(oPc, token, "inputname", JsonString(""));
        NuiSetBind(oPc, token, "inputdescription", JsonString(""));
    }

}
