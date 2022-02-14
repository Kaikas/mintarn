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
    json wndlst = JsonArray();
    wndlst = JsonArrayInsert(wndlst, NuiComboEntry("name", 3));
    wndlst = JsonArrayInsert(wndlst, NuiComboEntry("foo", 1));
    wndlst = JsonArrayInsert(wndlst, NuiComboEntry("bar", 2));
    NuiSetBind(oPc, 0, "window_id_list", wndlst);
    NuiSetBind(oPc, 1, "selected_window_token", JsonArray());
    jRow = JsonArrayInsert(jRow, NuiCombo(NuiBind("window_id_list"), NuiBind("selected_window_token")));

    jCol = JsonArrayInsert(JsonArray(), jText);
    jCol2 = JsonArrayInsert(JsonArray(), jButtonJob);
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
    NuiCreate(oPc, jWindow, "downtime");
}
