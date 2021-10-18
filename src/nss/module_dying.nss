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
        SetLocalInt(oPc, "DYING_POINTS", GetLocalInt(oPc, "DYING_POINTS") + 1);
        SendMessageToPC(oPc, "[d20 = " + IntToString(iRoll) + "] Ihr kommt dem Tode näher! (" + IntToString(GetLocalInt(oPc, "DYING_POINTS")) + "/3 Misserfolge)");
     } else if (iRoll > 10 && iRoll < 20) {
        SetLocalInt(oPc, "LIVING_POINTS", GetLocalInt(oPc, "LIVING_POINTS") + 1);
        SendMessageToPC(oPc, "[d20 = " + IntToString(iRoll) + "] Ihr erholt euch! (" + IntToString(GetLocalInt(oPc, "LIVING_POINTS")) + "/3 Erfolge)");
    } else if (iRoll == 20) {
        SetLocalInt(oPc, "LIVING_POINTS", 3);
        SendMessageToPC(oPc, "[d20 = " + IntToString(iRoll) + "] Ihr erholt euch! (" + IntToString(GetLocalInt(oPc, "LIVING_POINTS")) + "/3 Erfolge)");
    } else if (iRoll == 1) {
        SetLocalInt(oPc, "DYING_POINTS", 3);
        SendMessageToPC(oPc, "[d20 = " + IntToString(iRoll) + "] Ihr kommt dem Tode näher! (" + IntToString(GetLocalInt(oPc, "DYING_POINTS")) + "/3 Misserfolge)");
    }

    //SendMessageToPC(oPc, "DYING_POINTS" + IntToString(GetLocalInt(oPc, "DYING_POINTS")));
    //SendMessageToPC(oPc, "LIVING_POINTS" + IntToString(GetLocalInt(oPc, "LIVING_POINTS")));

    // Check if we died
    if (GetLocalInt(oPc, "DYING_POINTS") > 2) {
        SetLocalInt(oPc, "DYING_POINTS", 1);
        SetLocalInt(oPc, "LIVING_POINTS", 1);
        SendMessageToPC(oPc, "Ihr seid gestorben! Gebt nun /sterben ein um endgültig zu sterben oder wartet auf Hilfe.");
        effect eDamage = EffectDamage(11, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
        DelayCommand(5.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPc));
        return;
    }

    // Check if we ressurected
    if (GetLocalInt(oPc, "LIVING_POINTS") > 2 || iHitPoints > 0) {
        SetLocalInt(oPc, "LIVING_POINTS", 1);
        SendMessageToPC(oPc, "Ihr seid dem Tod entkommen!");
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
    if (GetTag(GetArea(oPc)) == "AREA_Testdungeon") {
        effect eHeal = EffectHeal(10000);
    } else {
        int iHitPoints = GetCurrentHitPoints(oPc);
        effect eHeal = EffectHeal(abs(iHitPoints));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPc);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPc, 7.0f);
        DelayCommand(6.0f, bleed(oPc));
    }
}
