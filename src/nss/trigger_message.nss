#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    string sTag = GetTag(OBJECT_SELF);
    if(sTag == "trigger_schmied"){
        FloatingTextStringOnCreature(StringToRGBString("Ihr seid nun in der N�he der Schmiede.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_chor"){
       FloatingTextStringOnCreature(StringToRGBString("Schon von weitem h�rt man begleitet vom Klavier einen hellen Kinderchor singen.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_schreiner"){
        FloatingTextStringOnCreature(StringToRGBString("Ihr seid nun in der N�he einer Schreinerwerkstatt.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_lederer"){
         FloatingTextStringOnCreature(StringToRGBString("Der unangenehme Gestank der so typisch f�r eine Gerberei ist steigt euch in die Nase.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_musik"){
        FloatingTextStringOnCreature(StringToRGBString("Die sch�ne Instrumentenverk�uferin l�chelt euch, als ihr Ihre Waren betrachtet, verf�hrerisch an.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_tabak"){
        FloatingTextStringOnCreature(StringToRGBString("Der orientalisch aussehende H�ndler h�tet eine Sammlung aus Vasen und Gef��en voller Tabak. Die unterschiedlichsten Ger�che kommen in eure Nase.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_unterdeck"){
        FloatingTextStringOnCreature(StringToRGBString("Die Liege zu eurer linken Hand wurde euch zugewiesen. Um fortzufahren geht dort schlafen.", "333"), oPc, FALSE);
    }
    if(sTag == "trigger_kueche"){
        FloatingTextStringOnCreature(StringToRGBString("Ihr befindet euch nun in einer K�che.", "333"), oPc, FALSE);
    }

    //Messages unused:
    // Das Feuer knistert und strahlt eine angenehme w�rme aus.

    // Die einstmals sch�ne Elfenstatue wurde beschmiert und entstellt

    // Den Spieler informieren, dass die Falle scharf gestellt wurde.
    //FloatingTextStringOnCreature(StringToRGBString("Das Ger�ll vor euch sieht aus als k�nnte es jeden Moment ins rutschen geraten und euch verletzen.", "333"), oPc, FALSE);
    // Falle stellen
    //DestroyObject(GetNearestObjectByTag("DUNG_TRAP_NUM2"));
    //CreateTrapAtLocation(TRAP_BASE_TYPE_AVERAGE_SPIKE, GetLocation(GetNearestObjectByTag("DUNG_Trap2")), 1.0f, "DUNG_TRAP_NUM2");

    //object oPc = GetEnteringObject();
    // Den Spieler informieren, dass die Falle scharf gestellt wurde.
    //if (d20() + GetSkillRank(SKILL_SPOT, oPc) > 12) {
    //    FloatingTextStringOnCreature(StringToRGBString("Ihr h�rt ein seltsames klicken in der Wand. Fast als w�rde ein Mechanismus scharf gestellt.", "333"), oPc, FALSE);
    //}
    // Falle stellen
    //DestroyObject(GetNearestObjectByTag("DUNG_TRAP_NUM1"));
    //CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, GetLocation(GetNearestObjectByTag("DUNG_Trap1")), 1.0f, "DUNG_TRAP_NUM1");

    //if (Random(20) + GetSkillRank(SKILL_SPOT, oPc) > 12) {
    //    NWNX_Chat_SendMessage(1, StringToRGBString("Ihr habt etwas seltsames bemerkt als ihr den Schrank begutachtet. Er scheint eine falsche R�ckwand zu haben. Gebt /hindurchzw�ngen ein um auf die andere Seite zu kommen.", "333"), GetObjectByTag("TRIGGER_Schrank"), oPc);
    //}

}
