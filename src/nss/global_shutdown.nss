// Gets called when the server shuts down
void main() {
    object oPlayer = GetFirstPC();
    while (GetIsObjectValid(oPlayer) == TRUE) {
        BootPC(oPlayer);
        oPlayer = GetNextPC();
    }
}
