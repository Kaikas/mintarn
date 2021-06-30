//::///////////////////////////////////////////////
// Schwache Blitzfalle
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{

  // Variablen_Stufe
  int nDamage = d3(15);
  int nSaveDC = 12;
  float eDauer = RoundsToSeconds(1);
  float fSize = RADIUS_SIZE_GARGANTUAN;

  //Variablen_Fallentyp
  int nSave = SAVING_THROW_WILL;
  int nDamageType = DAMAGE_TYPE_ELECTRICAL;
  effect eStatus = EffectStunned();
  effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);



  //:://////////////////////////////////////////////
  // Ab hier keine Anpassungen.
  //:://////////////////////////////////////////////

  // Konstanten
  effect eDam = EffectDamage(nDamage, nDamageType);
  object oTarget = GetEnteringObject();
  location lTarget = GetLocation(oTarget);
  int bValid;


  //Get first object in the target area
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lTarget);
  //Cycle through the target area until all object have been targeted
  while(GetIsObjectValid(oTarget))
  {
    if(!GetIsReactionTypeFriendly(oTarget))
    {
      // Rettungswurf Statuseffekt
      if(!MySavingThrow(nSave, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
      {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatus, oTarget, eDauer);
      }
      //Rettungswurf Schaden
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
        //Apply effects to the target.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
      }
    }
    //Get next target in shape
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lTarget);
  }
}
