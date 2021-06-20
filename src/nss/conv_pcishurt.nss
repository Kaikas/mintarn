int StartingConditional() {
    object oPc = GetPCSpeaker();

    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oPc) - 1), oPc);

    if (GetMaxHitPoints(oPc) == GetCurrentHitPoints(oPc)) return FALSE;
    return TRUE;
}
