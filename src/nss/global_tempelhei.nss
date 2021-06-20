void main()
{
    int iHealLevel = StringToInt(GetScriptParam("heal_level"));
    int iGold = StringToInt(GetScriptParam("gold"));
    object oPc = GetPCSpeaker();
    object oCleric = OBJECT_SELF;

    if (GetGold(oPc) >= iGold) {
        TakeGoldFromCreature(iGold, oPc);
        if(iHealLevel == 1) {
            AssignCommand(oCleric, ActionCastSpellAtObject(SPELL_HEAL, oPc, 0, TRUE));
        }
        if(iHealLevel == 2) {
            AssignCommand(oCleric, ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oPc, 0, TRUE));
        }
    } else {
        SendMessageToPC(oPc, "Ihr könnt euch das nicht leisten.");
    }
}
