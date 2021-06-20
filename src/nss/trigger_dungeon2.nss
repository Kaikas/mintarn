#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    // Den Spieler informieren, dass die Falle scharf gestellt wurde.
    if (d20() + GetSkillRank(SKILL_SPOT, oPc) > 12) {
        FloatingTextStringOnCreature(StringToRGBString("Ihr hört ein seltsames klicken in der Wand. Fast als würde ein Mechanismus scharf gestellt.", "333"), oPc, FALSE);
    }
    // Falle stellen
    DestroyObject(GetNearestObjectByTag("DUNG_TRAP_NUM1"));
    CreateTrapAtLocation(TRAP_BASE_TYPE_MINOR_SPIKE, GetLocation(GetNearestObjectByTag("DUNG_Trap1")), 1.0f, "DUNG_TRAP_NUM1");
}
