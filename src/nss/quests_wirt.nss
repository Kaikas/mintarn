// Löscht das Paket, gibt Belohnung und gibt die Tabakbeutel
void main() {
    // Items aus der Datenbank löschen
    object oPc = GetPCSpeaker();
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (GetTag(oItem) == "QUEST_PaketfuerdenWirt") {
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oPc);
    }
    SetXP(oPc, GetXP(oPc) + 3000);
    GiveGoldToCreature(oPc, 100);
    CreateItemOnObject("sw_qu_tabaktempe", oPc, 1);
    CreateItemOnObject("sw_qu_tabakwache", oPc, 1);
    CreateItemOnObject("sw_qu_tabakschre", oPc, 1);
    CreateItemOnObject("sw_qu_tabakschmi", oPc, 1);
    CreateItemOnObject("sw_qu_tabakleder", oPc, 1);
    CreateItemOnObject("sw_qu_tabakleben", oPc, 1);
    RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
    AddJournalQuestEntry("quests", 2, oPc, FALSE, FALSE, FALSE);
}
