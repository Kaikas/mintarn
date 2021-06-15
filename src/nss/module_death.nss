#include "global_helper"
#include "nw_i0_plot"

// Handles player death
void main() {
    object oPc = GetLastPlayerDied();
    location lStart = GetLocation(GetObjectByTag("WP_DEATH"));
    AssignCommand(oPc, JumpToLocation(lStart));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPc);
    RemoveEffects(oPc);
}
