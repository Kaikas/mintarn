void main()
{
    object oPc = OBJECT_SELF;
    if(GetHasSpellEffect(916, oPc)){
        effect eEff = GetFirstEffect(oPc);
            while (GetIsEffectValid(eEff)){
                if (GetEffectSpellId(eEff) == 916){
                    RemoveEffect(oPc,eEff);
                }
                eEff = GetNextEffect(oPc);
            }
        }

}
