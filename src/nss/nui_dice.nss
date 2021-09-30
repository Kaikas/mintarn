#include "nw_inc_nui"

void main() {
    object oPc = OBJECT_SELF;
    json jWidget = NuiSpacer();

    json jPoints = JsonArrayInsert(JsonArray(), JsonFloat(0.0));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(10.0));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(10.0));
    json jLine = NuiDrawListPolyLine(JsonBool(TRUE), NuiColor(255, 0, 0), JsonBool(TRUE), JsonFloat(1.0), jPoints);
    json jDrawList = NuiDrawList(jWidget, JsonBool(TRUE), JsonArrayInsert(JsonArray(), jLine));

    json jRow = JsonArrayInsert(JsonArray(), jDrawList);

    json jText = NuiText(JsonString("Würfeln"));
    jRow = JsonArrayInsert(JsonArray(), jText);

    json jRoot = NuiRow(jRow);
    json jWindow = NuiWindow(jRoot, JsonString("Würfelbeutel"), NuiRect(-10.0, -10.0, 100.0, 100.0), JsonBool(FALSE), JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE), JsonBool(TRUE));
    NuiCreate(oPc, jWindow, "test");
}
