//::///////////////////////////////////////////////
//:: ZEP_STATICLIGHT.nss
//:: Copyright (c) 2001 Bioware Corp.
//:: Modified by Dan Heidel 1/14/04 for CEP
//:://////////////////////////////////////////////
/*
    Turns the placeable object's light on/off and forces clients to
    recompute area lighting. Place in slot "OnUse" of the placeable.

    Since the activation state for a placeable cannot
    be queried, this state must be stored in the
    local int CEP_L_AMION.  If the placeable is
    activated by default, CEP_L_AMION must be set to 1 by the builder.
    If the placeable is deactivated by default, CEP_L_AMION must
    be set to 0 or else incorrect behavior will result.
    All CEP placeables have local variables set properly.

    In additions, sounds can be specified to be played on state change.
    CEP_L_SOUND1 is the name of the WAV file to play
    when the placeable is activated.
    CEP_L_SOUND2 is the name of the WAV file to play
    when the placeable is deactivated.
    If either of these is not defined, no sound will
    be played for that anim.
    By default, all CEP placeables that have sounds
    attached to them already have local variables
    defined for them.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////
// Manuel Fierlbeck, 15.11.2014: created, based on zep_onoff

void main()
{
    if (GetLocalInt(OBJECT_SELF, "CEP_L_AMION")) {
        DeleteLocalInt(OBJECT_SELF, "CEP_L_AMION");
        PlaySound(GetLocalString(OBJECT_SELF, "CEP_L_SOUND2"));
        DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
        DelayCommand(2.0, SetPlaceableIllumination(OBJECT_SELF, FALSE));
    } else {
        SetLocalInt(OBJECT_SELF, "CEP_L_AMION",1);
        PlaySound(GetLocalString(OBJECT_SELF, "CEP_L_SOUND1"));
        DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
        DelayCommand(2.0, SetPlaceableIllumination(OBJECT_SELF, TRUE));
    }
    DelayCommand(2.1, RecomputeStaticLighting(GetArea(OBJECT_SELF)));
}
