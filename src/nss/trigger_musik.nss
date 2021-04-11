#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    NWNX_Chat_SendMessage(1, StringToRGBString("Die schöne Musikverkäuferin lächelt euch, als ihr Ihre Waren betrachtet, verführerisch an.", "333"), GetObjectByTag("TRIGGER_Markt"), oPc);
}
