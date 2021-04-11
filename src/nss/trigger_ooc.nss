#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    NWNX_Chat_SendMessage(1, StringToRGBString("Das Feuer knistert und strahlt eine angenehme wärme aus.", "333"), GetObjectByTag("TRIGGER_Ofen"), oPc);
}
