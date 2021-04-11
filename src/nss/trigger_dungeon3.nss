#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    // Den Spieler informieren, dass die Falle scharf gestellt wurde.
    FloatingTextStringOnCreature(StringToRGBString("Das Geröll vor euch sieht aus als könnte es jeden Moment ins rutschen geraten und euch verletzen.", "333"), oPc, FALSE);
    // Falle stellen
    DestroyObject(GetNearestObjectByTag("DUNG_TRAP_NUM2"));
    CreateTrapAtLocation(TRAP_BASE_TYPE_AVERAGE_SPIKE, GetLocation(GetNearestObjectByTag("DUNG_Trap2")), 1.0f, "DUNG_TRAP_NUM2");
}
