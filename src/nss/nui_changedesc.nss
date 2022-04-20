#include "nw_inc_nui_insp"
#include "nui_helper"

void main() {
    object oPc = GetLastUsedBy();
    json jRow = JsonArray();
    json jCol = JsonArray();

    //building the portrait box
    json jImg = NuiImage (NuiBind ("port_resref"),JsonInt (NUI_ASPECT_EXACT),JsonInt (NUI_HALIGN_CENTER),JsonInt (NUI_VALIGN_TOP));
    jImg = NuiGroup (jImg);
    jImg = NuiWidth (jImg, 140.0);
    jImg = NuiHeight (jImg, 160.0);

    jRow = JsonArrayInsert (jRow, NuiSpacer ());
    jRow = JsonArrayInsert(jRow, jImg);
    jRow = JsonArrayInsert (jRow, NuiSpacer ());

    jCol = JsonArrayInsert (jCol, NuiRow (jRow));
    jRow = JsonArray();

    jRow = JsonArrayInsert (jRow, NuiSpacer ());
    jRow = CreateButton (jRow, "<", "btn_portrait_prev", 42.0f, 40.0);
    jRow = CreateButton (jRow, "Set", "btn_portrait_ok", 44.0f, 40.0);
    jRow = CreateButton (jRow, ">", "btn_portrait_next", 42.0f, 40.0);
    jRow = JsonArrayInsert (jRow, NuiSpacer ());
    jCol = JsonArrayInsert (jCol, NuiRow (jRow));
    jRow = JsonArray();

    //sets the input box
    json jInputDescription = NuiTextEdit(JsonString("Beschreibung"), NuiBind("inputdescription"), 10000, TRUE);
    jInputDescription = NuiHeight(jInputDescription, 300.0f);
    jInputDescription = NuiWidth(jInputDescription, 300.0f);

    jRow = JsonArrayInsert (jRow, NuiSpacer ());
    jRow = JsonArrayInsert(jRow, jInputDescription);
    jRow = JsonArrayInsert (jRow, NuiSpacer ());

    jCol = JsonArrayInsert (jCol, NuiRow (jRow));
    jRow = JsonArray();

    //sets the "Save" Button
    json jButtonSelect = NuiButton(JsonString("Speichern"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");

    //sets the "Abort" Button
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    jRow = JsonArrayInsert (jRow, NuiSpacer ());
    jRow = JsonArrayInsert(jRow, jButtonSelect);
    jRow = JsonArrayInsert(jRow, jButtonAbort);
    jRow = JsonArrayInsert (jRow, NuiSpacer ());

    jCol = JsonArrayInsert (jCol, NuiRow (jRow));
    jRow = JsonArray();


    json jRoot = NuiCol(jCol);

    json jWindow = NuiWindow(jRoot,
        JsonString(GetName(oPc)),
        NuiRect(-1.0, -1.0, 320.0, 400.0),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "changedesc");

    NuiSetBind(oPc, token, "inputdescription", JsonString(GetDescription(oPc)));
}
