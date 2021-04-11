#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    // Falle stellen
    DestroyObject(GetNearestObjectByTag("SPIDER_TRAP_NUM1"));
    CreateTrapAtLocation(TRAP_BASE_TYPE_AVERAGE_TANGLE, GetLocation(GetNearestObjectByTag("SPIDER_TRAP")), 3.0f, "SPIDER_TRAP_NUM1");
}
