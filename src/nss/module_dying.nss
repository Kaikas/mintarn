#include "nw_i0_plot"

void bleed(object oPc) {
    // Make invisible
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPc, 7.0f);

    // If mutliple enemies hit the player the hp are not 0 at the beginning of the bleeds
    int iHitPoints = GetCurrentHitPoints(oPc);
    if (GetLocalInt(oPc, "DYING_HP") == 1) {
        effect eHeal = EffectHeal(abs(iHitPoints));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);
        SetLocalInt(oPc, "DYING_HP", 0);
    }

    int iRoll = d20();

    // Determine what happens.
    // < 10 get close to death
    // > 10 stay stable
    // 20 ressurect
    if (iRoll <= 10) {
        SendMessageToPC(oPc, "Überleben: " + IntToString(iRoll) + " (d20). Ihr kommt dem Tode näher!");
        effect eDamage = EffectDamage(1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPc);
        if (iHitPoints == -9) {
            SetLocalInt(oPc, "DYING_FOR_REAL", 1);
            SetLocalInt(oPc, "DYING", 0);
            return;
        }
    } else if (iRoll > 10 && iRoll < 20) {
        SendMessageToPC(oPc, "Überleben: " + IntToString(iRoll) + " (d20). Ihr bleibt stabil!");
    } else if (iRoll == 20) {
        SetLocalInt(oPc, "DYING", 0);
        SendMessageToPC(oPc, "Überleben: " + IntToString(iRoll) + " (d20). Ihr seid dem Tod entkommen!");
        effect eHeal = EffectHeal(abs(iHitPoints) + 1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);
    }

    // if we didn't ressurect, start the next bleed
    if (iRoll != 20 && GetCurrentHitPoints(oPc) <= 0) {
        DelayCommand(6.0f, bleed(oPc));
    }
}

void main() {
    object oPc = GetLastPlayerDying();
    // If its the first dying tick, initialize bleeds
    if (GetLocalInt(oPc, "DYING") == 0) {
        int iHitPoints = GetCurrentHitPoints(oPc);
        effect eHeal = EffectHeal(abs(iHitPoints));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPc, 7.0f);
        SetLocalInt(oPc, "DYING", 1);
        SetLocalInt(oPc, "DYING_HP", 1);
        DelayCommand(6.0f, bleed(oPc));
    }
}
