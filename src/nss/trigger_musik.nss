#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    NWNX_Chat_SendMessage(1, StringToRGBString("Die sch�ne Musikverk�uferin l�chelt euch, als ihr Ihre Waren betrachtet, verf�hrerisch an.", "333"), GetObjectByTag("TRIGGER_Markt"), oPc);
}
