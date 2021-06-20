void main() {
    object oPc = GetPCSpeaker();
    DestroyObject(GetObjectByTag("PET_" + GetPCPlayerName(oPc)));
}
