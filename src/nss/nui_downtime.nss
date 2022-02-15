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
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Arbeiten", 0));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Eine Zauberschriftrolle herstellen", 1));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Einen Gegenstand herstellen", 2));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Einen magischen Gegenstand kaufen", 3));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Einen magischen Gegenstand verkaufen", 4));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Entspannung", 5));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Glücksspiel", 6));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Gottesdienste", 7));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Grubenkämpfe", 8));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Recherche", 9));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Training", 10));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Verbrechen", 11));
    jDropdownbox = JsonArrayInsert(jDropdownbox, NuiComboEntry("Zechen", 12));

    jRow = JsonArrayInsert(jRow, NuiCombo(NuiBind("dropdownbox"), NuiBind("dropdownbox_selected")));

    jCol = JsonArrayInsert(JsonArray(), jText);
    jCol2 = JsonArrayInsert(JsonArray(), jButtonJob);
    jCol2 = JsonArrayInsert(jCol2, jButtonItem);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));

    json jRoot = NuiCol(jRow);

    SendMessageToPC(oPc, JsonDump(jRoot));

    json jWindow = NuiWindow(jRoot,
        JsonString("Aktivitäten"),
        NuiRect(-1.0, -1.0, 330.0, 300.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "downtime");

    NuiSetBind(oPc, token, "dropdownbox", jDropdownbox);
    NuiSetBind(oPc, token, "dropdownbox_selected", NuiBind("dropdownbox"));
}
