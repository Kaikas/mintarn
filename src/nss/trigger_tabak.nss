#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    NWNX_Chat_SendMessage(1, StringToRGBString("Der orientalisch aussehende Händler hütet eine Sammlung aus Vasen und Gefäßen voller Tabak. Die unterschiedlichsten Gerüche kommen in eure Nase.", "333"), GetObjectByTag("TRIGGER_Markt"), oPc);
}
