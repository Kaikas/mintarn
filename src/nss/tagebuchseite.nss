#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetLastUsedBy();
    string sMessage = "So begibt es sich, dass ich auf der Insel Mintarn einige Wochen verbringe. Es ist eine kleine Insel mit einer einzigen, lebendigen Stadt namens Freihafen. Hier herrscht alle paar Jahre ein anderer Tyrann, der sich, man glaubt es kaum, auch 'Tyrann' nennen lässt. Ich fand Unterkunft in einem kleinen Zimmer in der Taverne 'Zum rettenden Ufer', in der tagsüber Musik gespielt wird und abends gezecht.\n";
    string sMessage2 = "Der Wirt, ein knurriger Geselle, der ständig Pfeife raucht, und Seemannsgarn aus der guten alten Zeit erzählt, gab gestern Abend eine Geschichte von einem großen, feuerroten Drachen, der 'Roter Zorn Mintarns' genannt wird, zum besten. Dieser Drache, 'Hoondarrh' mit Namen, terrorisiert wohl seit vielen Jahren die Insel und fordert Tribut. Bei uns in Shou Lung völlig unvorstellbar. Unser Drache liegt ";
    string sMessage3 = "versteinert und Kilometerlang als Mauer an unseren Außengrenzen. Wie sich herausstellte, sammelt die Bevölkerung ihr wohl verdientes Gold und bietet es dem Drachen als Zahlung dar, damit er sie verschont. Und wer am Rathaus vorbei schreitet, der kann dort tatsächlich einen Steuereintreiber finden, der das Gold für den Drachen hortet. Es wundert mich nun also nicht mehr, dass sich ein Besucher der Taverne als Drachentöter ausgab.\n";
    string sMessage4 = "Die Insel Mintarn importierte über Jahre hinweg Holz, da alles leicht zugängliche Holz abgeholzt wurde. Erst durch zahlreiche Anbaumaßnamen konnte sich die Baumpopulation erholen. Auf Mintarn sieht man große Birkenwälder, die allesamt von den Arbeitern der Insel angepflanzt sind. Nur tiefer auf der Insel findet man noch große, alte Wälder die damals wundersamerweise die Rodungen überlebten. Was da wohl für eine Geschichte dahinter steckt? So viel kann ich aber festhalten, Holz wird immer noch importiert\n";
    string sMessage5 = "Als ich heute durch Freihafen schlenderte fiel mir auf, wieviele Söldner sich auf den Straßen tummeln. Als ich einen ansprach erzählte er mir, dass die Stadtwache in Freihafen nur aus einer kleinen, festen Einheit besteht und die restliche Truppe mit Söldnern aufgefüllt wird. Wie mir scheint, nehmen es die Söldner mit Recht und Gesetz aber nicht so genau. Bei dem Gesindel, dass sich hier teilweise rumtreibt aber kein Wunder. Was man so hört sind hier Freibeuter, Piraten und Vogelwilde willkommen, ";
    string sMessage6 = "solange sie sich an die Gesetze des Tyrannen halten. Nicht umsonst ist Mintarn für seine Neutralität in außenpolitischen Angelegenheiten bekannt.";
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage2, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage3, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage4, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage5, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage6, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);

}
