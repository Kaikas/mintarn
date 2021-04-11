void main()
{
    object oTarget = GetPlaceableLastClickedBy();
    AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_DARKFIRE, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    if (GetIsObjectValid(oTarget)) AssignCommand(oTarget, SpeakString("target valid"));
    if (GetIsObjectValid(OBJECT_SELF)) AssignCommand(oTarget, SpeakString("self valid"));
}
