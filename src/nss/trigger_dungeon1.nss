#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    //SendMessageToPC(oPc, StringToRGBString("Das Feuer knistert und strahlt eine angenehme wärme aus.", "uuu"));
    FloatingTextStringOnCreature(StringToRGBString("Die einstmals schöne Elfenstatue wurde beschmiert und entstellt.", "333"), oPc, FALSE);
}
