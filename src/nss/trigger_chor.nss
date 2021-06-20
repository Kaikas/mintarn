#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    NWNX_Chat_SendMessage(1, StringToRGBString("Schon von weitem hört man begleitet vom Klavier einen hellen Kinderchor singen.", "333"), GetObjectByTag("TRIGGER_Chor"), oPc);
}
