void main() {
    object oPc = GetEnteringObject();
    ActionDoCommand(SetCutsceneMode(oPc, TRUE));
    ActionDoCommand(FadeFromBlack(oPc, FADE_SPEED_FAST));
    SendMessageToPC(oPc, "Foo");

    // Teleport to Freihafen
    location lStart = GetLocation(GetObjectByTag("WP_FREIHAFEN"));
    DelayCommand(20.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
