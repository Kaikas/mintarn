#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jRow = JsonArray();

    json jButtonPlay = NuiButton(JsonString("Abspielen"));
    jButtonPlay = NuiId(jButtonPlay, "button_play");

    jRow = JsonArrayInsert(JsonArray(), jButtonPlay);

    json jRoot = NuiCol(jRow);

    //SendMessageToPC(oPc, JsonDump(jRoot));

    json jWindow = NuiWindow(jRoot,
        JsonString("Musik"),
        NuiRect(-1.0, -1.0, 330.0, 400.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "sounds");
}
