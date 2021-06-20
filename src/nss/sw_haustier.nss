void main() {
    object oPc = GetPCSpeaker();
    string sTag = "PET_" + GetPCPlayerName(oPc);
    object oPet = GetObjectByTag(sTag);
    DestroyObject(oPet);
    oPet = CreateObject(OBJECT_TYPE_CREATURE, GetScriptParam("pet"), GetLocation(oPc), TRUE, sTag);
}
