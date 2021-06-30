//::///////////////////////////////////////////////
// professionelle Heiligfalle
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{

  // Variablen_Stufe
  int nDamage = d2(30);
  int nSaveDC = 24;
  //float eDauer = null;
  float fSize = RADIUS_SIZE_COLOSSAL;

  //Variablen_Fallentyp
  int nSave = SAVING_THROW_WILL;
  int nDamageType = DAMAGE_TYPE_DIVINE;
  //effect eStatus = null
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);




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
      /*          if(!MySavingThrow(nSave, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
                  {
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatus, oTarget, eDauer);
                  }*/
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
        if (GetRacialType(oTarget) !=RACIAL_TYPE_UNDEAD)
        {
          nDamage /= 4;
        }
        {

          //Apply effects to the target.
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
          DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
      }
    }
    //Get next target in shape
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lTarget);
  }
}
