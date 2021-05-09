//::///////////////////////////////////////////////
// professionelle Verstrickungsfalle
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{

	// Variablen_Stufe
	int nSaveDC = 24;
	float eDauer = RoundsToSeconds(10);
	float fSize = RADIUS_SIZE_GARGANTUAN;

	//Variablen_Fallentyp
	int nSave = SAVING_THROW_FORT;
	effect eStatus = EffectEntangle();
	effect eVis = EffectVisualEffect(VFX_IMP_SLOW);



//:://////////////////////////////////////////////
// Ab hier keine Anpassungen.
//:://////////////////////////////////////////////

	// Konstanten
	object oTarget = GetEnteringObject();
    location lTarget = GetLocation(oTarget);
    int bValid;


    //Get first object in the target area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lTarget);
    //Cycle through the target area until all object have been targeted
       while (GetIsObjectValid(oTarget))
    {
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
        {
            //Apply slow effect and slow effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatus, oTarget, eDauer);
        }
        //Get next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lTarget);
    }
    }

