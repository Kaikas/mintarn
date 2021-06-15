#include "nw_i0_plot"

void bleed(object oPc) {
    // Make invisible
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPc, 7.0f);

    // If mutliple enemies hit the player the hp are not 0 at the beginning of the bleeds
    int iHitPoints = GetCurrentHitPoints(oPc);
    effect eHeal = EffectHeal(abs(iHitPoints));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);

    int iRoll = d20();

    // Determine what happens.
    // < 10 get close to death
    // > 10 stay stable
    // 20 ressurect
    if (iRoll <= 10 && iRoll > 1) {
        SendMessageToPC(oPc, "Überleben: " + IntToString(iRoll) + " (d20). Ihr kommt dem Tode näher!");
        SetLocalInt(oPc, "DYING_POINTS", GetLocalInt(oPc, "DYING_POINTS") + 1);
    } else if (iRoll > 10 && iRoll < 20) {
        SetLocalInt(oPc, "LIVING_POINTS", GetLocalInt(oPc, "LIVING_POINTS") + 1);
        SendMessageToPC(oPc, "Überleben: " + IntToString(iRoll) + " (d20). Ihr erholt euch!");
    } else if (iRoll == 20) {
        SetLocalInt(oPc, "LIVING_POINTS", GetLocalInt(oPc, "LIVING_POINTS") + 3);
    } else if (iRoll == 1) {
        SetLocalInt(oPc, "DYING_POINTS", GetLocalInt(oPc, "DYING_POINTS") + 3);
    }

    //SendMessageToPC(oPc, "DYING_POINTS" + IntToString(GetLocalInt(oPc, "DYING_POINTS")));
    //SendMessageToPC(oPc, "LIVING_POINTS" + IntToString(GetLocalInt(oPc, "LIVING_POINTS")));

    // Check if we died
    if (GetLocalInt(oPc, "DYING_POINTS") > 2) {
        SetLocalInt(oPc, "DYING_POINTS", 1);
        SetLocalInt(oPc, "LIVING_POINTS", 1);
        effect eDamage = EffectDamage(10, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPc);
        return;
    }

    // Check if we ressurected
    if (GetLocalInt(oPc, "LIVING_POINTS") > 2 || iHitPoints > 0) {
        SetLocalInt(oPc, "LIVING_POINTS", 1);
        SendMessageToPC(oPc, "Überleben: Ihr seid dem Tod entkommen!");
        effect eHeal = EffectHeal(abs(iHitPoints) + 1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);
        return;
    }

    // if we didn't ressurect and didn't die, start the next bleed
    DelayCommand(6.0f, bleed(oPc));
}

void main() {
    object oPc = GetLastPlayerDying();

    int iHitPoints = GetCurrentHitPoints(oPc);
    effect eHeal = EffectHeal(abs(iHitPoints));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPc, 7.0f);
    DelayCommand(6.0f, bleed(oPc));
}
