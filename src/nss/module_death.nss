#include "global_helper"
#include "nw_i0_plot"

// Handles player death
void main() {
    object oPc = GetLastPlayerDied();
    if (GetLocalInt(oPc, "DYING_FOR_REAL") == 1) {
        SetLocalInt(oPc, "DYING_FOR_REAL", 0);
        location lStart = GetLocation(GetObjectByTag("WP_DEATH"));
        AssignCommand(oPc, JumpToLocation(lStart));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPc);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPc)), oPc);
        RemoveEffects(oPc);

    } else {
        effect eRessurect = EffectResurrection();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRessurect, oPc);
        effect eDamage = EffectDamage(1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPc);
    }
}
