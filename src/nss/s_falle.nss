#include "x3_inc_string"

void main() {
    object oPc = GetEnteringObject();
    // Den Spieler informieren, dass die Falle scharf gestellt wurde.
    if (d20() + GetSkillRank(SKILL_SPOT, oPc) > 12) {
        FloatingTextStringOnCreature(StringToRGBString("Ihr hört ein seltsames klicken, fast so, als würde ein Mechanismus scharf gestellt.", "333"), oPc, FALSE);
    }
    // Falle stellen
    DestroyObject(GetNearestObjectByTag("DUNG_TRAP_NUM1"));
    CreateTrapAtLocation(50, GetLocation(GetNearestObjectByTag("DUNG_Trap1")), 1.0f, "DUNG_TRAP_NUM1");
}
