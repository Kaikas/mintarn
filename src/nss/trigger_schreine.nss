#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    //SendMessageToPC(oPc, StringToRGBString("Das Feuer knistert und strahlt eine angenehme w�rme aus.", "uuu"));
    FloatingTextStringOnCreature(StringToRGBString("Ihr seid nun in der N�he einer Schreinerwerkbank.", "333"), oPc, FALSE);
}
