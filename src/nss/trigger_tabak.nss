#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    NWNX_Chat_SendMessage(1, StringToRGBString("Der orientalisch aussehende H�ndler h�tet eine Sammlung aus Vasen und Gef��en voller Tabak. Die unterschiedlichsten Ger�che kommen in eure Nase.", "333"), GetObjectByTag("TRIGGER_Markt"), oPc);
}
