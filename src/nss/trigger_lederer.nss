#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    //NWNX_Chat_SendMessage(1, StringToRGBString("Der unangenehme Gestank der so typisch für eine Gerberei ist steigt euch in die Nase.", "333"), GetObjectByTag("TRIGGER_Gasse"), oPc);
    FloatingTextStringOnCreature(StringToRGBString("Der unangenehme Gestank der so typisch für eine Gerberei ist steigt euch in die Nase.", "333"), oPc, FALSE);
}
