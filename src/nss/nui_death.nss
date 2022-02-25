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

    json jText = NuiText(JsonString("Ihr seid gestorben. Mit etwas Glück wird euch jemand finden und euren Leichnam ins Hospitium bringen. " +
        "Dort können euch die Priester wiederbeleben. Um die Chance zu erhöhen solltet ihr besser alles tun " +
        "was ihr noch tun könnt: beten. ((Gebt /beten ein.))"));
    jRow = JsonArrayInsert(JsonArray(), jText);

    json jRoot = NuiRow(jRow);
    json jWindow = NuiWindow(jRoot, JsonString("Astralebene"), NuiRect(-1.0, -1.0, 330.0, 200.0), JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE), JsonBool(FALSE), JsonBool(FALSE));
    NuiCreate(oPc, jWindow, "death");
}
