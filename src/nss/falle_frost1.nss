//::///////////////////////////////////////////////
// Schwache Frostfalle
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
  int bValid;
  object oTarget = GetEnteringObject();
  location lTarget = GetLocation(oTarget);
  int nDamage;
  effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
  effect eSlow = EffectSlow();
  effect eDam;


  int nSaveDC = 12;

  //Get first object in the target area
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
  //Cycle through the target area until all object have been targeted
  while(GetIsObjectValid(oTarget))
  {
    if(!GetIsReactionTypeFriendly(oTarget))
    {
      //Roll damage
      nDamage = d8(2);
      // Rettungswurf Verlangsamung
      if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
      {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(10));
      }
      //Adjust the trap damage based on the feats of the target
      if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
      {
        if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
        {
          nDamage /= 2;
        }
      }
      else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
      {
        nDamage = 0;
      }
      else
      {
        nDamage /= 2;
      }
      if (nDamage > 0)
      {
        //Set damage effect
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
        if (nDamage > 0)
        {
          //Apply effects to the target.
          eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
          DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
      }
    }
    //Get next target in shape
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
  }
}
