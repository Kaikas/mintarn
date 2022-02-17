#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
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

    // Dropdown
    json jDropdownboxElement = JsonArray();
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Wähle eine Aktion", 0));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Tagewerk", 1));
    /*
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Eine Zauberschriftrolle herstellen", 2));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Einen Gegenstand herstellen", 3));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Einen magischen Gegenstand kaufen", 4));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Einen magischen Gegenstand verkaufen", 5));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Entspannung", 6));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Glücksspiel", 7));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Gottesdienste", 8));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Grubenkämpfe", 9));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Recherche", 10));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Training", 11));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Verbrechen", 12));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Zechen", 13));
    */
    json jDropdownbox = NuiCombo(NuiBind("dropdownbox"), NuiBind("dropdownbox_selected"));
    //jDropdownbox = NuiWidth(jDropdownbox, 35);
    jDropdownbox = NuiId(jDropdownbox, "select_downtime");

    jRow = JsonArrayInsert(jRow, jDropdownbox);

    json jInput = NuiTextEdit(JsonString("Freitext zur Beschreibung der Aktivität."), NuiBind("input"), 10000, TRUE);
    jInput = NuiHeight(jInput, 100.0);

    jCol = JsonArrayInsert(JsonArray(), jText);
    jCol2 = JsonArrayInsert(JsonArray(), jInput);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));

    json jRoot = NuiCol(jRow);

    SendMessageToPC(oPc, JsonDump(jRoot));

    json jWindow = NuiWindow(jRoot,
        JsonString("Aktivitäten"),
        NuiRect(-1.0, -1.0, 330.0, 400.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "downtime");

    NuiSetBind(oPc, token, "dropdownbox", jDropdownboxElement);
    NuiSetBind(oPc, token, "dropdownbox_selected", jDropdownboxElement);
    NuiSetBindWatch(oPc, token, "dropdownbox_selected", TRUE);
    NuiSetBindWatch(oPc, token, "dropdownbox", TRUE);
    NuiSetBindWatch(oPc, token, "select_downtime", TRUE);
    NuiSetBind(oPc, token, "text", jTextContent);
    NuiSetBind(oPc, token, "input", jInput);
}
