void main()
{
    object oPc = GetPlaceableLastClickedBy();
    int iHitPoints = GetCurrentHitPoints(oPc);
    effect eDamage = EffectDamage(iHitPoints + 1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPc);
}
