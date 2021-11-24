//::///////////////////////////////////////////////
//:: Name x2_def_ondamage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnDamaged script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{
    //--------------------------------------------------------------------------
    // GZ: 2003-10-16
    // Make Plot Creatures Ignore Attacks
    //--------------------------------------------------------------------------
    if (GetPlotFlag(OBJECT_SELF))
    {
        return;
    }

    //--------------------------------------------------------------------------
    // Execute old NWN default AI code
    //--------------------------------------------------------------------------
    ExecuteScript("nw_c2_default6", OBJECT_SELF);
    if(GetTag(OBJECT_SELF) == "ENEMY_Troll" || GetTag(OBJECT_SELF) == "ENEMY_TrollBerserker"){
        if(GetDamageDealtByType(DAMAGE_TYPE_FIRE) > 0 || GetDamageDealtByType(DAMAGE_TYPE_ACID) > 0){
            SetImmortal(OBJECT_SELF, FALSE);
        }

    }

}
