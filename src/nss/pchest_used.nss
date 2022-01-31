void main() {
    object oPc = GetLastUsedBy();
    string PlayerID = GetPCPublicCDKey(oPc);

    if (PlayerID != GetLocalString(OBJECT_SELF, "OPENEDBY")) {
        AssignCommand(oPc, ClearAllActions());
        SetCutsceneMode(oPc, TRUE);
        AssignCommand(oPc, ActionMoveAwayFromObject(OBJECT_SELF, TRUE, 50.0));
        FloatingTextStringOnCreature("Die Kiste wird bereits benutzt!", oPc);
        SendMessageToAllDMs(GetName(oPc) + " versucht eine persistente Kiste " +
                                           "welche bereits benutzt wird zu öffnen.");
        DelayCommand(5.0, SetCutsceneMode(oPc, FALSE));
    }
}
