int StartingConditional()
{
    // Items aus der Datenbank l�schen
    object oPc = GetPCSpeaker();
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (GetTag(oItem) == "QUEST_PaketfuerdenWirt") {
            return TRUE;
        }
        oItem = GetNextItemInInventory(oPc);
    }

    return FALSE;
}
