#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    FloatingTextStringOnCreature(StringToRGBString("Die Liege zu eurer linken Hand wurde euch zugewiesen. Um fortzufahren geht dort schlafen.", "333"), oPc, FALSE);
}

