#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jRow = JsonArray();

    json jText = NuiText(JsonString("Dies sind Aktivitäten denen euer " +
        "Charakter nachgehen kann, während ihr nicht eingeloggt seid."));
    json jButtonJob = NuiButton(JsonString("Wählen"));
    json jButtonItem = NuiButton(JsonString("Abbrechen"));

    // Dropdown
    json jDropdownbox = JsonArray();
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("name", 0));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("foo", 1));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("bar", 2));
    jRow = JsonArrayInsert(jRow, NuiCombo(NuiBind("dropdownbox"), NuiBind("dropdownbox_selected")));

    jCol = JsonArrayInsert(JsonArray(), jText);
    jCol2 = JsonArrayInsert(JsonArray(), jButtonJob);
    jCol2 = JsonArrayInsert(jCol2, jButtonItem);
    jCol2 = JsonArrayInsert(jCol2, jButtonItem);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));

    json jRoot = NuiCol(jRow);

    SendMessageToPC(oPc, JsonDump(jRoot));

    json jWindow = NuiWindow(jRoot,
        JsonString("Aktivitäten"),
        NuiRect(-1.0, -1.0, 800.0, 600.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "downtime");

    NuiSetBind(oPc, token, "dropdownbox", jDropdownbox);
    NuiSetBind(oPc, token, "dropdownbox_selected", NuiBind("dropdownbox"));
}
