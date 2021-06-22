#include "nwnx_sql"
#include "nw_i0_tool"
#include "global_money"

void main() {
    object oPc = GetPCSpeaker();
    string sQuery;
    // Schmied
    if (GetScriptParam("item") == "sw_we_spitzhacke") {
        // Prüfe ob der Spieler Tabakschachteln über hat
        int count = 0;
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
                DestroyObject(oItem);
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerWache") {
                count = count + 1;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        if (count == 0) {
            RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
        }
        CreateItemOnObject(GetScriptParam("item"), oPc, 1);
        CreateItemOnObject(GetScriptParam("sw_ha_spitzhacke"), oPc, 1);
        AddJournalQuestEntry("schmied", 1, oPc, FALSE, FALSE, FALSE);
        sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "schmied_intro");
            NWNX_SQL_PreparedString(3, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }
    }

    // Schreiner
    if (GetScriptParam("item") == "sw_we_axt") {
        // Prüfe ob der Spieler Tabakschachteln über hat
        int count = 0;
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
                DestroyObject(oItem);
            }
            if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerWache") {
                count = count + 1;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        if (count == 0) {
            RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
        }
        CreateItemOnObject(GetScriptParam("item"), oPc, 1);
        AddJournalQuestEntry("schreiner", 1, oPc, FALSE, FALSE, FALSE);
        sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "schreiner_intro");
            NWNX_SQL_PreparedString(3, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }
    }

    // Lederer
    if (GetScriptParam("item") == "sw_we_lederer") {
        // Prüfe ob der Spieler Tabakschachteln über hat
        int count = 0;
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
                DestroyObject(oItem);
            }
            if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerWache") {
                count = count + 1;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        if (count == 0) {
            RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
        }
        CreateItemOnObject("sw_re_fackel", oPc, 1);
        AddJournalQuestEntry("lederer", 1, oPc, FALSE, FALSE, FALSE);
        sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "lederer_intro");
            NWNX_SQL_PreparedString(3, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }
    }
    // Tempel
    if (GetScriptParam("item") == "sw_we_tempel") {
        // Prüfe ob der Spieler Tabakschachteln über hat
        int count = 0;
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
                DestroyObject(oItem);
            }
            if (GetTag(oItem) == "QUEST_TabakFuerWache") {
                count = count + 1;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        if (count == 0) {
            RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
        }
        //CreateItemOnObject(GetScriptParam("item"), oPc, 1);
        //AddJournalQuestEntry("tempel", 1, oPc, FALSE, FALSE, FALSE);
        sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "tempel_intro");
            NWNX_SQL_PreparedString(3, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }

        // Give potions
        CreateItemOnObject("sw_tr_kleineheil", oPc);
        CreateItemOnObject("sw_tr_kleineheil", oPc);
        CreateItemOnObject("sw_tr_kleineheil", oPc);
        CreateItemOnObject("sw_tr_kleineheil", oPc);
        CreateItemOnObject("sw_tr_kleineheil", oPc);
    }
    // Lebensmittel
    if (GetScriptParam("item") == "sw_we_lebensm") {
        // Prüfe ob der Spieler Tabakschachteln über hat
        int count = 0;
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
                DestroyObject(oItem);
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerWache") {
                count = count + 1;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        if (count == 0) {
            RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
        }
        CreateItemOnObject("sw_na_pilzragout", oPc, 5);
        AddJournalQuestEntry("lebensm", 1, oPc, FALSE, FALSE, FALSE);
        sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "lebensmittel_intro");
            NWNX_SQL_PreparedString(3, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }
    }
    // Stadtwache
    if (GetScriptParam("item") == "sw_we_wache") {
        // Prüfe ob der Spieler Tabakschachteln über hat
        int count = 0;
        object oPc = GetPCSpeaker();
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
                count = count + 1;
            }
            if (GetTag(oItem) == "QUEST_TabakFuerWache") {
                DestroyObject(oItem);
            }
            oItem = GetNextItemInInventory(oPc);
        }
        if (count == 0) {
            RemoveJournalQuestEntry("quests", oPc, FALSE, FALSE);
        }
        AddJournalQuestEntry("wache", 1, oPc, FALSE, FALSE, FALSE);
        sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "stadtwache_intro");
            NWNX_SQL_PreparedString(3, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }
    }
    // Schmied intro
    if (GetScriptParam("item") == "schmied_intro") {
        object oPc = GetPCSpeaker();
        object oItem = GetFirstItemInInventory(oPc);
        int iCount = 5;
        while (oItem != OBJECT_INVALID) {
            if (GetTag(oItem) == "CRAFT_Eisenerz") {
                if (iCount > 0) {
                    if (GetItemStackSize(oItem) > 1) {
                        SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
                    } else {
                        DestroyObject(oItem);
                    }
                    iCount = iCount - 1;
                }
            }
            oItem = GetNextItemInInventory(oPc);
        }
        RemoveJournalQuestEntry("schmied", oPc, FALSE, FALSE);
        sQuery = "UPDATE QuestStatus SET stage = ? WHERE name=? AND charname=? AND quest=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, "1");
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(2, GetName(oPc));
            NWNX_SQL_PreparedString(3, "schmied_intro");
            NWNX_SQL_ExecutePreparedQuery();
        }
        GiveXPToCreature(oPc, 1000);
        GiveGoldToCreature(oPc, 50);
        CreateItemOnObject("sw_ro_eisenbarre", oPc);
    }
    // Lederer intro
    if (GetScriptParam("item") == "lederer_intro") {
        object oPc = GetPCSpeaker();
        object oItem = GetFirstItemInInventory(oPc);
        int iFound = 0;
        while (oItem != OBJECT_INVALID) {
            if (GetTag(oItem) == "CRAFT_Fackel") {
                if (GetItemStackSize(oItem) > 1) {
                    SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
                } else {
                    DestroyObject(oItem);
                }
                break;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        RemoveJournalQuestEntry("lederer", oPc, FALSE, FALSE);
        sQuery = "UPDATE QuestStatus SET stage = ? WHERE name=? AND charname=? AND quest=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, "1");
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(2, GetName(oPc));
            NWNX_SQL_PreparedString(3, "lederer_intro");
            NWNX_SQL_ExecutePreparedQuery();
        }
        GiveXPToCreature(oPc, 1000);
        GiveGoldToCreature(oPc, 50);
    }
    // Schreiner intro
    if (GetScriptParam("item") == "schreiner_intro") {
        object oPc = GetPCSpeaker();
        RemoveJournalQuestEntry("schreiner", oPc, FALSE, FALSE);
        sQuery = "UPDATE QuestStatus SET stage = ? WHERE name=? AND charname=? AND quest=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, "1");
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(2, GetName(oPc));
            NWNX_SQL_PreparedString(3, "schreiner_intro");
            NWNX_SQL_ExecutePreparedQuery();
        }
        GiveXPToCreature(oPc, 1000);
        GiveGoldToCreature(oPc, 50);
    }
    // Bedürftige
    if (GetScriptParam("item") == "25gold") {
        object oPc = GetPCSpeaker();
        int nGold  = GetGold(oPc);

        if (!GetLocalInt(oPc, "COIN_DESTRUCTION_PREVENTION")) {
            MONEY_TurnCoinsIntoGP(oPc);
            SetLocalInt(oPc, "COIN_DESTRUCTION_PREVENTION", TRUE);
            DelayCommand(0.1, DeleteLocalInt(oPc, "COIN_DESTRUCTION_PREVENTION"));

            // Remove the coins
            TakeGold(3, oPc);

            if (!GetIsPC(oPc) || !nGold)
                return;
            // Give coin money:
            MONEY_GiveCoinMoneyWorth(nGold, oPc);

            // Destroy the ingame-gold of the player:
            TakeGoldFromCreature(nGold, oPc, TRUE);
        }
    }
    // Bedürftige Pilzragout
    if (GetScriptParam("item") == "sw_we_beduerftige") {
        object oPc = GetPCSpeaker();
        object oItem = GetFirstItemInInventory(oPc);
        while (oItem != OBJECT_INVALID)
        {
            if (GetTag(oItem) == "CRAFT_Pilzragout") {
                if (GetItemStackSize(oItem) > 1) {
                    SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
                } else {
                    DestroyObject(oItem);
                }
                break;
            }
            oItem = GetNextItemInInventory(oPc);
        }
        int iStage;
        string sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "lebensmittel_intro");
            NWNX_SQL_ExecutePreparedQuery();
            while (NWNX_SQL_ReadyToReadNextRow()) {
                NWNX_SQL_ReadNextRow();
                iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
            }
        }
        if (iStage == 0) {
            sQuery = "UPDATE QuestStatus SET stage = ? WHERE name=? AND charname=? AND quest=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, "1");
                NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
                NWNX_SQL_PreparedString(2, GetName(oPc));
                NWNX_SQL_PreparedString(3, "lebensmittel_intro");
                NWNX_SQL_ExecutePreparedQuery();
            }
        }

    }
    // Bedürftige Pilzragout
    if (GetScriptParam("item") == "sw_we_beduerftige2") {
        object oPc = GetPCSpeaker();
        sQuery = "UPDATE QuestStatus SET stage = ? WHERE name=? AND charname=? AND quest=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, "2");
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(2, GetName(oPc));
            NWNX_SQL_PreparedString(3, "lebensmittel_intro");
            NWNX_SQL_ExecutePreparedQuery();
        }
        GiveXPToCreature(oPc, 1000);
        GiveGoldToCreature(oPc, 50);
        RemoveJournalQuestEntry("lebensm", oPc, FALSE, FALSE);
    }
}
