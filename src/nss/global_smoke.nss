#include "global_helper"

location GetLocationAboveAndInFrontOf(object oPC, float fDist, float fHeight)
{
    float fDistance = -fDist;
    object oTarget = (oPC);
    object oArea = GetArea(oTarget);
    vector vPosition = GetPosition(oTarget);
    vPosition.z += fHeight;
    float fOrientation = GetFacing(oTarget);
    vector vNewPos = AngleToVector(fOrientation);
    float vZ = vPosition.z;
    float vX = vPosition.x - fDistance * vNewPos.x;
    float vY = vPosition.y - fDistance * vNewPos.y;
    fOrientation = GetFacing(oTarget);
    vX = vPosition.x - fDistance * vNewPos.x;
    vY = vPosition.y - fDistance * vNewPos.y;
    vNewPos = AngleToVector(fOrientation);
    vZ = vPosition.z;
    vNewPos = Vector(vX, vY, vZ);
    return Location(oArea, vNewPos, fOrientation);
}

void SmokePipe(object oActivator)
{
    string sEmote1 = GetToken(101) + "*raucht Pfeife*";
    float fHeight = 1.7;
    float fDistance = 0.1;
    // Set height based on race and gender
    if (GetGender(oActivator) == GENDER_MALE)
    {
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF:
                fHeight = 1.7;
                fDistance = 0.12;
                break;

            case RACIAL_TYPE_ELF:
                fHeight = 1.55;
                fDistance = 0.08;
                break;

            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING:
                fHeight = 1.15;
                fDistance = 0.12;
                break;

            case RACIAL_TYPE_DWARF:
                fHeight = 1.2;
                fDistance = 0.12;
                break;

            case RACIAL_TYPE_HALFORC:
                fHeight = 1.9;
                fDistance = 0.2;
                break;
        }
    }
    else
    {
        // FEMALES
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF:
                fHeight = 1.6;
                fDistance = 0.12;
                break;

            case RACIAL_TYPE_ELF:
                fHeight = 1.45;
                fDistance = 0.12;
                break;

            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING:
                fHeight = 1.1;
                fDistance = 0.075;
                break;

            case RACIAL_TYPE_DWARF:
                fHeight = 1.2;
                fDistance = 0.1;
                break;

            case RACIAL_TYPE_HALFORC:
                fHeight = 1.8;
                fDistance = 0.13;
                break;
        }
    }

    location lAboveHead = GetLocationAboveAndInFrontOf(oActivator, fDistance, fHeight);

    // emotes
    if (Random(100) == 0) {
        //AssignCommand(oActivator, ActionSpeakString(sEmote1));

        // glow red
        AssignCommand(oActivator, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_5), oActivator, 0.15)));

        // wait a moment
        AssignCommand(oActivator, ActionWait(3.0));

        // puff of smoke above and in front of head
        AssignCommand(oActivator, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lAboveHead)));

        // if female, turn head to left
        if ((GetGender(oActivator) == GENDER_FEMALE) && (GetRacialType(oActivator) != RACIAL_TYPE_DWARF))
            AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 5.0));

        // funky effect
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectParalyze(), oActivator);
    }
}

