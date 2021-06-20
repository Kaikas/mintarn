int StartingConditional() {
    int iResult;

    iResult = 0;
    object oPc = GetPCSpeaker();
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (GetTag(oItem) == GetScriptParam("item")) {
            iResult = 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return iResult;
}
