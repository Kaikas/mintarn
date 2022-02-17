#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jTextContent = JsonString(GetLocalString(oPc, "nui_message"));
    json jText = NuiText(NuiBind("text"));
    json jRow = JsonArrayInsert(JsonArray(), jText);
    json jRoot = NuiCol(jRow);

    json jWindow = NuiWindow(jRoot,
        JsonString("Nachricht"),
        NuiRect(-1.0, -1.0, 330.0, 200.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "message");
    NuiSetBind(oPc, token, "text", jTextContent);
}
