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

    json jText = NuiText(JsonString("Wir freuen uns euch mitzuteilen, dass die Beta von Mintarn am 1.10.2021 gestartet ist.\n\n" +
    "In der Beta erstellte Charaktere werden nicht mehr gelöscht. Wir haben noch zahlreiche Ideen, die wir umsetzen wollen und " +
    "es werden sicherlich auch Fehler während der Beta auftauchen, die angegangen werden müssen. Im Großen und Ganzen sind wir " +
    "aber für einen Regelbetrieb bereit und freuen uns auf eine belebte persistente Welt.\n\n" +
    "Es kann passieren, dass man innerhalb der Beta aus technischen Gründen Charaktere neu erstellen bzw. neu leveln muss. " +
    "Dies kann zum Beispiel erforderlich werden, wenn wir Änderungen an Fertigkeiten, Talenten oder Klassen vornehmen. " +
    "Die Erfahrungspunkte und Gegenstände bleiben euch aber nach Möglichkeit erhalten. Eure Errungenschaften im Rollenspiel bleiben auf jeden Fall unangetastet.\n\n" +
    "Bitte meldet uns aufgetretene Fehler oder Ungereimtheiten im Discord im Kanal fehler-meldungen oder im Spiel über /report. Für eure Ideen, Wünsche oder einfach nur " +
    "Feedback stehen diverse Kanäle im Discord bereit. Konkrete Vorschläge sind in ideen-und-vorschläge gern gesehen.\n\n" +
    "Damit ihr euren Charakter auch individuell gestalten könnt, haben wir im Discord einen Kanal eingerichtet, in dem ihr eure Portraits hochladen könnt, damit sie allen zur Verfügung gestellt werden können." +
    "\n\nBesucht und auf https://mintarn.de oder im Discord https://discord.gg/Tp2qyYp!"));
    jRow = JsonArrayInsert(JsonArray(), jText);

    json jRoot = NuiRow(jRow);
    json jWindow = NuiWindow(jRoot, JsonString("Willkommen in der Mintarn Beta"), NuiRect(-1.0, -1.0, 800.0, 600.0), JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE), JsonBool(FALSE), JsonBool(FALSE));
    NuiCreate(oPc, jWindow, "test");
}
