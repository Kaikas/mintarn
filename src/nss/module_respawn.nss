#include "nw_i0_plot"

void main() {
    object oRespawner = GetLastRespawnButtonPresser();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oRespawner);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner);
    RemoveEffects(oRespawner);
    location lStart = GetLocation(GetObjectByTag("WP_DEATH"));
    DelayCommand(0.0, AssignCommand(oRespawner, JumpToLocation(lStart)));
 }
