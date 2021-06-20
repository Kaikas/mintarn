// Teleportiert den Spieler in den Freihafen
void main() {
    object oPc = GetLastUsedBy();
    ActionDoCommand(SetCutsceneMode(oPc, TRUE));
    ActionDoCommand(FadeToBlack(oPc, FADE_SPEED_FAST));
    PostString(oPc, "Nach einer langen und beschwerlichen Reise seht ihr am Horizont die Stadt Freihafen leuchten. ", -150, 0, SCREEN_ANCHOR_CENTER, 10.0f, 0xFFFFFFFF, 0xFFFFFFFF, 0, "");
    PostString(oPc, "Willkommen auf Mintarn, Fremder!", -20, 3, SCREEN_ANCHOR_CENTER, 10.0f, 0xFFFFFFFF, 0xFFFFFFFF, 0, "");
    location lLoc = GetLocation(GetObjectByTag("WP_FREIHAFEN"));
    DelayCommand(2.0, ExecuteScript("global_rest", oPc));
    DelayCommand(10.0, AssignCommand(oPc, JumpToLocation(lLoc)));
    DelayCommand(10.0, ActionDoCommand(SetCutsceneMode(oPc, FALSE)));
    DelayCommand(10.0, ActionDoCommand(FadeFromBlack(oPc, FADE_SPEED_FAST)));
}
