#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetLastUsedBy();
    string sMessage = "So begibt es sich, dass ich auf der Insel Mintarn einige Wochen verbringe. Es ist eine kleine Insel mit einer einzigen, lebendigen Stadt namens Freihafen. Hier herrscht alle paar Jahre ein anderer Tyrann, der sich, man glaubt es kaum, auch 'Tyrann' nennen l�sst. Ich fand Unterkunft in einem kleinen Zimmer in der Taverne 'Zum rettenden Ufer', in der tags�ber Musik gespielt wird und abends gezecht.\n";
    string sMessage2 = "Der Wirt, ein knurriger Geselle, der st�ndig Pfeife raucht, und Seemannsgarn aus der guten alten Zeit erz�hlt, gab gestern Abend eine Geschichte von einem gro�en, feuerroten Drachen, der 'Roter Zorn Mintarns' genannt wird, zum besten. Dieser Drache, 'Hoondarrh' mit Namen, terrorisiert wohl seit vielen Jahren die Insel und fordert Tribut. Bei uns in Shou Lung v�llig unvorstellbar. Unser Drache liegt ";
    string sMessage3 = "versteinert und Kilometerlang als Mauer an unseren Au�engrenzen. Wie sich herausstellte, sammelt die Bev�lkerung ihr wohl verdientes Gold und bietet es dem Drachen als Zahlung dar, damit er sie verschont. Und wer am Rathaus vorbei schreitet, der kann dort tats�chlich einen Steuereintreiber finden, der das Gold f�r den Drachen hortet. Es wundert mich nun also nicht mehr, dass sich ein Besucher der Taverne als Drachent�ter ausgab.\n";
    string sMessage4 = "Die Insel Mintarn importierte �ber Jahre hinweg Holz, da alles leicht zug�ngliche Holz abgeholzt wurde. Erst durch zahlreiche Anbauma�namen konnte sich die Baumpopulation erholen. Auf Mintarn sieht man gro�e Birkenw�lder, die allesamt von den Arbeitern der Insel angepflanzt sind. Nur tiefer auf der Insel findet man noch gro�e, alte W�lder die damals wundersamerweise die Rodungen �berlebten. Was da wohl f�r eine Geschichte dahinter steckt? So viel kann ich aber festhalten, Holz wird immer noch importiert\n";
    string sMessage5 = "Als ich heute durch Freihafen schlenderte fiel mir auf, wieviele S�ldner sich auf den Stra�en tummeln. Als ich einen ansprach erz�hlte er mir, dass die Stadtwache in Freihafen nur aus einer kleinen, festen Einheit besteht und die restliche Truppe mit S�ldnern aufgef�llt wird. Wie mir scheint, nehmen es die S�ldner mit Recht und Gesetz aber nicht so genau. Bei dem Gesindel, dass sich hier teilweise rumtreibt aber kein Wunder. Was man so h�rt sind hier Freibeuter, Piraten und Vogelwilde willkommen, ";
    string sMessage6 = "solange sie sich an die Gesetze des Tyrannen halten. Nicht umsonst ist Mintarn f�r seine Neutralit�t in au�enpolitischen Angelegenheiten bekannt.";
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage2, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage3, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage4, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage5, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);
    NWNX_Chat_SendMessage(1, StringToRGBString(sMessage6, "333"), GetObjectByTag("TAGEBUCHSEITE"), oPc);

}
