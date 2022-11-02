#include "nwnx_sql"
#include "nwnx_time"
#include "global_helper"
#include "nwnx_webhook"
#include "nwnx_feedback"
#include "global_money"
#include "x3_inc_string"
#include "nwnx_chat"
#include "module_downtime"

const float RP_XP_DELAY = 600.0;

float quadratic(float x) {
    return (x/5000) * (x/5000);
}

// Gibt einem Spieler XP
void GiveXP(object oPc, int iCount, int iSumXp, int iToken) {
    //Schutz vor Doppel-XP durch relogg
    if (iToken != GetLocalInt(oPc, "xp_token")) {
        return;
    }

    // Checks if the player is over level 15
    if (GetHitDice(oPc) > 14) return;

    // PrÃ¼ft ob der Spieler in den letzten 5 Minuten etwas geschrieben hat.
    //string sQuery = "SELECT * FROM Chat WHERE name=? AND charname=? ORDER BY id DESC LIMIT 1";

    int iCharacters = 0;
    iCharacters = GetLocalInt(oPc,"RPXP_Counter");
    SetLocalInt(oPc,"RPXP_Counter", 0);

    //if (NWNX_SQL_PrepareQuery(sQuery)) {
    //    NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
    //    NWNX_SQL_PreparedString(1, GetName(oPc));
    //    NWNX_SQL_ExecutePreparedQuery();
    //
    //    while (NWNX_SQL_ReadyToReadNextRow()) {
    //        NWNX_SQL_ReadNextRow();
    //        //SendMessageToPC(oPc, IntToString(NWNX_Time_GetTimeStamp() - StringToInt(NWNX_SQL_ReadDataInActiveRow(4))));
    //        if (NWNX_Time_GetTimeStamp() - StringToInt(NWNX_SQL_ReadDataInActiveRow(4)) < 601) {
    //            if (GetSubString(NWNX_SQL_ReadDataInActiveRow(3), 0, 1) != "/" && GetSubString(NWNX_SQL_ReadDataInActiveRow(3), 0, 1) != "(") {
    //                iTalked = iTalked + 1;
    //                iCharacters = iCharacters + GetStringLength(NWNX_SQL_ReadDataInActiveRow(3));
    //            }
    //        }
    //    }
    //}
    // Basisexp

    int iXp = 400;
    if (iCharacters > 30) iXp = 420;
    if (iCharacters > 60) iXp = 440;
    if (iCharacters > 90) iXp = 460;
    if (iCharacters > 120) iXp = 480;
    if (iCharacters > 150) iXp = 500;

    // Player has spoken, give XP
    if (iCharacters > 0) {
        int iXpPenalty = -1;
        int iDatetime = 0;
        int iMoschEp = 0;
        // Get old xp
        string sQuery = "SELECT * FROM Experience WHERE name=? AND charname=? AND type=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "rp");
            NWNX_SQL_ExecutePreparedQuery();

            while (NWNX_SQL_ReadyToReadNextRow()) {
                NWNX_SQL_ReadNextRow();
                iXpPenalty = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
                iDatetime = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
            }
        }
        // Get moschen xp
        sQuery = "SELECT * FROM Experience WHERE name=? AND charname=? AND type=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "moschen");
            NWNX_SQL_ExecutePreparedQuery();

            while (NWNX_SQL_ReadyToReadNextRow()) {
                NWNX_SQL_ReadNextRow();
                iXpPenalty = iXpPenalty + StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
                iMoschEp = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
            }
        }
        // If no entry exists, create one
        if (iDatetime == 0) {
            sQuery = "INSERT INTO Experience (name, charname, experience, datetime, type) VALUES (?, ?, ?, ?, ?)";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                NWNX_SQL_PreparedString(1, GetName(oPc));
                NWNX_SQL_PreparedString(2, "0");
                NWNX_SQL_PreparedString(3, IntToString(NWNX_Time_GetTimeStamp()));
                NWNX_SQL_PreparedString(4, "rp");
                NWNX_SQL_ExecutePreparedQuery();
            }
        }
        // Check if one week is over
        if (iDatetime != 0) {
            if (NWNX_Time_GetTimeStamp() - iDatetime > 604800) {
                iXpPenalty = 0;
                sQuery = "DELETE FROM Experience WHERE name=? AND charname=? AND type=?";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                    NWNX_SQL_PreparedString(1, GetName(oPc));
                    NWNX_SQL_PreparedString(2, "rp");
                    NWNX_SQL_ExecutePreparedQuery();
                }
                sQuery = "DELETE FROM Experience WHERE name=? AND charname=? AND type=?";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
                    NWNX_SQL_PreparedString(1, GetName(oPc));
                    NWNX_SQL_PreparedString(2, "moschen");
                    NWNX_SQL_ExecutePreparedQuery();
                }
            }
        }

        if (iXpPenalty > 5000) {
            iXp = FloatToInt(IntToFloat(iXp) / quadratic(IntToFloat(iXpPenalty)));
        }
        // failsafe
        if (iXp > 1000) {
            iXp = 1000;
        }

        // Set new xp
        sQuery = "UPDATE Experience SET experience=? WHERE name=? AND charname=? AND type=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, IntToString(iXpPenalty + iXp - iMoschEp));
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(2, GetName(oPc));
            NWNX_SQL_PreparedString(3, "rp");
            NWNX_SQL_ExecutePreparedQuery();
        }
        //NWNX_Feedback_SetFeedbackMessageHidden(182, 1, oPc);
        iXp = iXp + Random(20);
        GiveXPToCreature(oPc, iXp);

        // Determines if the player gets a token
        GiveDowntimeToken(oPc);

        //NWNX_Feedback_SetFeedbackMessageHidden(182, 0, oPc);
        iSumXp = iSumXp + iXp;
        iCount = iCount + 1;
        //if (iCount * 10 % 60 == 0) {
            //SendMessageToPC(oPc, IntToString(iCount * 10) + " Minuten, " + IntToString(iCount * 10 / 60) + " Stunden : " + IntToString(iSumXp) + "Xp");
            //PrintString(IntToString(iCount * 10) + " Minuten, " + IntToString(iCount * 10 / 60) + " Stunden : " + IntToString(iSumXp) + "Xp");
        //}
        //SendMessageToPC(oPc, "FÃ¼r Rollenspiel habt ihr Erfahrung gewonnen.");
    }
    DelayCommand(RP_XP_DELAY, GiveXP(oPc, iCount, iSumXp, iToken));
}

// Erzeugt einen zufÃ¤lligen Token
string GenerateToken() {
    string sToken = IntToString(Random(9)) +
    IntToString(Random(9)) +
    IntToString(Random(9)) +
    IntToString(Random(9)) +
    IntToString(Random(9)) +
    IntToString(Random(9)) +
    IntToString(Random(9)) +
    IntToString(Random(9));
    return sToken;
}

void GiveGeschichtsbuch(object oPc) {
    if (CountItemsByTag(oPc, "CRAFT_Geschichte") == 0) {
        CreateItemOnObject("sw_we_geschichte", oPc);
    }
}

void main() {
    // Default Script
    ExecuteScript("x3_mod_pre_enter", OBJECT_SELF);

    object oPc = GetEnteringObject();

    // Send branch info
    string branch = NWNX_Util_GetEnvironmentVariable("BRANCH");
    SendMessageToPC(oPc, "Willkommen auf Mintarn. Aktueller Branch: " + branch);

    // Set to commoner faction
    ChangeToStandardFaction(oPc, STANDARD_FACTION_COMMONER);
    // Reputation
    AdjustReputation(oPc, GetObjectByTag("FACTION_MERCHANT"), 100);
    AdjustReputation(oPc, GetObjectByTag("FACTION_COMMONER"), 100);
    AdjustReputation(oPc, GetObjectByTag("FACTION_DEFENDER"), 100);
    AdjustReputation(oPc, GetObjectByTag("FACTION_TIERE"), 100);
    AdjustReputation(oPc, GetObjectByTag("FACTION_ENTS"), 100);
    AdjustReputation(oPc, GetObjectByTag("FACTION_HOSTILE"), -100);

    // Failsafe
    if (GetIsDM(oPc) || GetIsPC(oPc) == FALSE) {
        PrintString("Login durch unbekanntes Object " + GetTag(oPc));
    }

    // SW Placer
    SetLocalInt(oPc, "SW_PLACER_CHANCE", 100);

    // DM Items
    if (GetIsDM(oPc)) {
        CreateItemOnObject("sw_we_placer", oPc);
        CreateItemOnObject("sw_we_belohnung", oPc);
        CreateItemOnObject("sw_we_charinfo", oPc);
        CreateItemOnObject("sw_we_changename", oPc);
        CreateItemOnObject("sw_we_sprichals", oPc);
        CreateItemOnObject("sw_we_sprichals2", oPc);
        CreateItemOnObject("sw_we_sprichals3", oPc);
        CreateItemOnObject("sw_we_sprichals4", oPc);
        CreateItemOnObject("sw_we_sprichals5", oPc);
        CreateItemOnObject("sw_we_fraktion", oPc);
        CreateItemOnObject("sw_we_rasten", oPc);
        CreateItemOnObject("sw_we_wuerfelbeu", oPc);
        CreateItemOnObject("sw_we_zeit", oPc);
    }

    // Create user in database if not exists
    if (GetIsPC(oPc)) {
        // Userdata
        string sAccountName = GetPCPlayerName(oPc);
        string sName = GetName(oPc);
        if (!GetIsDM(oPc)) {
            string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_MODULE");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " hat sich eingeloggt.", "Mintarn");
        } else {
            //string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_MODULE");
            //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, "Ein Spielleiter hat sich eingeloggt.", "Mintarn");
            string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " hat sich eingeloggt.", "Mintarn");
        }
        location loc = GetLocation(oPc);
        object oArea = GetAreaFromLocation(loc);
        vector vPosition = GetPositionFromLocation(loc);
        float fFacing = GetFacingFromLocation(loc);

        // Insert user if first login
        string sQuery = "SELECT * FROM Users WHERE name=? AND charname=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, sAccountName);
            NWNX_SQL_PreparedString(1, sName);
            NWNX_SQL_ExecutePreparedQuery();

            string sId;
            while (NWNX_SQL_ReadyToReadNextRow()) {
                NWNX_SQL_ReadNextRow();
                sId = NWNX_SQL_ReadDataInActiveRow(0);
            }
            if (StringToInt(sId) > 0) {
                // Teleport
                location lStart = GetLocation(GetObjectByTag("WP_START_OOC"));
                // DelayCommand(0.0, AssignCommand(oPc, JumpToLocation(lStart)));
                // Description
                string sDescription = NWNX_SQL_ReadDataInActiveRow(14);
                //SendMessageToPC(oPc, sDescription);
                StringReplace(sDescription, "<br>", "\n");
                StringReplace(sDescription, "<br />", "\n");
                StringReplace(sDescription, "\r", "");
                //SendMessageToPC(oPc, sDescription);
                //SetDescription(oPc, sDescription);
                // Hitpoints
                //NWNX_Feedback_SetCombatLogMessageHidden(11, 1);
                NWNX_Feedback_SetCombatLogMessageHidden(3, 1, oPc);
                if (StringToInt(NWNX_SQL_ReadDataInActiveRow(24)) != GetMaxHitPoints(oPc)) {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPc)), oPc);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oPc) - StringToInt(NWNX_SQL_ReadDataInActiveRow(24))), oPc);
                }
                //NWNX_Feedback_SetCombatLogMessageHidden(11, 0);
                NWNX_Feedback_SetCombatLogMessageHidden(3, 0, oPc);
            } else {
                // Found none, so we insert
                sQuery = "INSERT INTO Users (" +
                "name, " +
                "charname, " +
                "facing, " +
                "posx, " +
                "posy, " +
                "posz, " +
                "area, " +
                "gold, " +
                "level1, " +
                "level2, " +
                "level3, " +
                "gender, " +
                "race, " +
                "description, " +
                "portrait, " +
                "class1, " +
                "class2, " +
                "class3, " +
                "alignment1, " +
                "alignment2, " +
                "token, " +
                "rest, " +
                "health, " +
                "maxhealth, " +
                "house" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    // Remove gold from player
                    int nGold  = GetGold(oPc);
                    AssignCommand (oPc, TakeGoldFromCreature(nGold, oPc, TRUE));
                    // Give gold to new player
                    GiveGoldToCreature(oPc, 15000);
                    // Destroy equipped items
                    object oItem;
                    int nSlot;
                    for (nSlot=0; nSlot < NUM_INVENTORY_SLOTS; nSlot++) {
                       oItem = GetItemInSlot(nSlot, oPc);
                       DestroyObject(oItem);
                    }
                    // Destroy items in inventory
                    oItem = GetFirstItemInInventory(oPc);
                    while (oItem != OBJECT_INVALID) {
                        DestroyObject(oItem);
                        oItem = GetNextItemInInventory(oPc);
                    }
                    // Give beginner clothes
                    object oArmor = CreateItemOnObject("sw_ru_einfachekl", oPc);
                    AssignCommand(oPc, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
                    // Gib Dolch und crafting ressources
                    //CreateItemOnObject("sw_re_dolch", oPc);
                    //CreateItemOnObject("sw_ro_eisenbarre", oPc);
                    //CreateItemOnObject("sw_ro_birkenholz", oPc);
                    // Gib Nahrung
                    CreateItemOnObject("sw_na_braten", oPc);
                    CreateItemOnObject("sw_na_braten", oPc);
                    CreateItemOnObject("sw_na_braten", oPc);

                    // Gib den Wunderbeutel
                    CreateItemOnObject("sw_we_wuerfelbeu", oPc);
                    // Gib das Pet Item
                    CreateItemOnObject("sw_we_haustier", oPc);
                    // Gib Schurke Fallen
                    if (GetLevelByClass(CLASS_TYPE_ROGUE, oPc) > 0) {
                        CreateItemOnObject("sw_fa_klin1", oPc);
                        CreateItemOnObject("sw_fa_klin1", oPc);
                        CreateItemOnObject("sw_fa_klin1", oPc);
                        CreateItemOnObject("sw_fa_klin1", oPc);
                        CreateItemOnObject("sw_fa_klin1", oPc);
                    }
                    // Gib Alpha Testern ihre Belohnung
                    if (GetPCPlayerName(oPc) == "Kaikas" ||
                        GetPCPlayerName(oPc) == "enikross" ||
                        GetPCPlayerName(oPc) == "Nordwind" ||
                        GetPCPlayerName(oPc) == "Martermaske" ||
                        GetPCPlayerName(oPc) == "Sonnenfeuer" ||
                        GetPCPlayerName(oPc) == "Grashnak1" ||
                        GetPCPlayerName(oPc) == "Lina" ||
                        GetPCPlayerName(oPc) == "Victorious" ||
                        GetPCPlayerName(oPc) == "Morgenstern" ||
                        GetPCPlayerName(oPc) == "Northeast" ||
                        GetPCPlayerName(oPc) == "Geonox" ||
                        GetPCPlayerName(oPc) == "Bolgfred" ||
                        GetPCPlayerName(oPc) == "Astraios" ||
                        GetPCPlayerName(oPc) == "Kane" ||
                        GetPCPlayerName(oPc) == "Mira" ||
                        GetPCPlayerName(oPc) == "Silberfunken73" ||
                        GetPCPlayerName(oPc) == "Wilbur" ||
                        GetPCPlayerName(oPc) == "Void" ||
                        GetPCPlayerName(oPc) == "Darkside" ||
                        GetPCPlayerName(oPc) == "Sanginius") {
                        CreateItemOnObject("sw_we_alpha", oPc);
                    }
                    // Update database
                    NWNX_SQL_PreparedString(0, sAccountName);
                    NWNX_SQL_PreparedString(1, sName);
                    NWNX_SQL_PreparedString(2, FloatToString(fFacing));
                    NWNX_SQL_PreparedString(3, FloatToString(vPosition.x));
                    NWNX_SQL_PreparedString(4, FloatToString(vPosition.y));
                    NWNX_SQL_PreparedString(5, FloatToString(vPosition.z));
                    NWNX_SQL_PreparedString(6, GetTag(oArea));
                    NWNX_SQL_PreparedString(7, IntToString(GetGold(oPc)));
                    NWNX_SQL_PreparedInt(8, GetLevelByPosition(1, oPc));
                    NWNX_SQL_PreparedInt(9, GetLevelByPosition(2, oPc));
                    NWNX_SQL_PreparedInt(10, GetLevelByPosition(3, oPc));
                    NWNX_SQL_PreparedInt(11, GetGender(oPc));
                    NWNX_SQL_PreparedInt(12, GetRacialType(oPc));
                    NWNX_SQL_PreparedString(13, GetDescription(oPc));
                    NWNX_SQL_PreparedString(14, GetPortraitResRef(oPc));
                    NWNX_SQL_PreparedInt(15, GetClassByPosition(1, oPc));
                    NWNX_SQL_PreparedInt(16, GetClassByPosition(2, oPc));
                    NWNX_SQL_PreparedInt(17, GetClassByPosition(3, oPc));
                    NWNX_SQL_PreparedInt(18, GetAlignmentGoodEvil(oPc));
                    NWNX_SQL_PreparedInt(19, GetAlignmentLawChaos(oPc));
                    NWNX_SQL_PreparedString(20, GenerateToken());
                    NWNX_SQL_PreparedString(21, "0"); //IntToString(NWNX_Time_GetTimeStamp())
                    NWNX_SQL_PreparedInt(22, GetCurrentHitPoints(oPc));
                    NWNX_SQL_PreparedInt(23, GetMaxHitPoints(oPc));
                    NWNX_SQL_PreparedInt(24, 0);
                    NWNX_SQL_ExecutePreparedQuery();
                }
                // Create beginner quest
                sQuery = "INSERT INTO QuestStatus (name, charname, quest, stage) VALUES (?, ?, ?, ?)";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, sAccountName);
                    NWNX_SQL_PreparedString(1, sName);
                    NWNX_SQL_PreparedString(2, "0");
                    NWNX_SQL_PreparedString(3, "0");
                    NWNX_SQL_ExecutePreparedQuery();
                }
                // Create CDKey
                sQuery = "INSERT INTO CDkey (name, cdkey) VALUES (?, ?)";
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, sAccountName);
                    NWNX_SQL_PreparedString(1, GetPCPublicCDKey(oPc));
                    NWNX_SQL_ExecutePreparedQuery();
                }
            }
        }
    }

    // Check if CDkey matches accountname
    string sQuery = "SELECT * FROM CDkey WHERE name=? AND cdkey=?";
    int iCDkeyFound = 0;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetPCPublicCDKey(oPc));
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iCDkeyFound = 1;
        }
    }
    if (iCDkeyFound == 0) {
        string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS");
        NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, GetPCPlayerName(oPc) + " und " + GetPCPublicCDKey(oPc) + " passen nicht zu den Datenbankwerten!", "Mintarn");
    }

    // Money
    int nGold  = GetGold(oPc);
    MONEY_GiveCoinMoneyWorth(nGold, oPc);
    AssignCommand (oPc, TakeGoldFromCreature(nGold, oPc, TRUE));

    // Quests
    //ExecuteScript("quests_enter", OBJECT_SELF);
    //string sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";

    // Willkommen auf Mintarn
    object oItem = GetFirstItemInInventory(oPc);
    int iFound = 0;
    while (oItem != OBJECT_INVALID)
    {
        if (GetTag(oItem) == "QUEST_TabakFuerLebensm") {
            iFound = iFound + 1;
        }
        if (GetTag(oItem) == "QUEST_TabakFuerLederer") {
            iFound = iFound + 1;
        }
        if (GetTag(oItem) == "QUEST_TabakFuerSchmied") {
            iFound = iFound + 1;
        }
        if (GetTag(oItem) == "QUEST_TabakFuerSchrein") {
            iFound = iFound + 1;
        }
        if (GetTag(oItem) == "QUEST_TabakFuerTempel") {
            iFound = iFound + 1;
        }
        if (GetTag(oItem) == "QUEST_TabakFuerWache") {
            iFound = iFound + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    if (iFound > 0) {
        AddJournalQuestEntry("quests", 2, oPc, FALSE, FALSE, TRUE);
    }

    // Schmied
    sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
    int iStage = -1;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, "schmied_intro");
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        }
    }
    if (iStage == 0) {
        AddJournalQuestEntry("schmied", 1, oPc, FALSE, FALSE, TRUE);
    }

    // Lederer
    sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
    iStage = -1;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, "lederer_intro");
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        }
    }
    if (iStage == 0) {
        AddJournalQuestEntry("lederer", 1, oPc, FALSE, FALSE, TRUE);
    }

    // Schreiner
    sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
    iStage = -1;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, "schreiner_intro");
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        }
    }
    if (iStage == 0) {
        AddJournalQuestEntry("schreiner", 1, oPc, FALSE, FALSE, TRUE);
    }
    // Lebensmittel
    sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
    iStage = -1;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, "lebensmittel_intro");
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        }
    }
    if (iStage == 0 || iStage == 1) {
        AddJournalQuestEntry("lebensm", 1, oPc, FALSE, FALSE, TRUE);
    }
    // Stadtwache
    sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
    iStage = -1;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, "stadtwache_intro");
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iStage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        }
    }
    PrintString("DEBUG: Stadtwache: iStage = " + IntToString(iStage) + " Player = " + GetName(oPc) + " Account = " + GetPCPlayerName(oPc));
    if (iStage == 0) {
        AddJournalQuestEntry("wache", 1, oPc, FALSE, FALSE, TRUE);
    }

    GiveGeschichtsbuch(oPc);

    // Give XP every 10 Minutes
    int nSeed = Random(1000000);
    SetLocalInt(oPc, "xp_token", nSeed);
    DelayCommand(RP_XP_DELAY, GiveXP(oPc, 1, 0, nSeed));

    //Remove the familiar buff so it doesn't persist without familiar
    if(GetHasSpellEffect(916, oPc)){
        effect eEff = GetFirstEffect(oPc);
        while (GetIsEffectValid(eEff)){
            if (GetEffectSpellId(eEff) == 916){
                RemoveEffect(oPc,eEff);
            }
            eEff = GetNextEffect(oPc);
        }
    }

    // Start nui
    //ExecuteScript("nui_dice", oPc);
    /*string sBeta = "Wir freuen uns euch mitzuteilen, dass die Beta von Mintarn am 1.10.2021 gestartet ist.\n\n" +
    "In der Beta erstellte Charaktere werden nicht mehr gelöscht. Wir haben noch zahlreiche Ideen, die wir umsetzen wollen und " +
    "es werden sicherlich auch Fehler während der Beta auftauchen, die angegangen werden müssen. Im Großen und Ganzen sind wir " +
    "aber für einen Regelbetrieb bereit und freuen uns auf eine belebte persistente Welt.\n\n" +
    "Es kann passieren, dass man innerhalb der Beta aus technischen Gründen Charaktere neu erstellen bzw. neu leveln muss. " +
    "Dies kann zum Beispiel erforderlich werden, wenn wir Änderungen an Fertigkeiten, Talenten oder Klassen vornehmen. " +
    "Die Erfahrungspunkte und Gegenstände bleiben euch aber nach Möglichkeit erhalten. Eure Errungenschaften im Rollenspiel bleiben auf jeden Fall unangetastet.\n\n" +
    "Bitte meldet uns aufgetretene Fehler oder Ungereimtheiten im Discord im Kanal fehler-meldungen oder im Spiel über /report. Für eure Ideen, Wünsche oder einfach nur " +
    "Feedback stehen diverse Kanäle im Discord bereit. Konkrete Vorschläge sind in ideen-und-vorschläge gern gesehen.\n\n" +
    "Damit ihr euren Charakter auch individuell gestalten könnt, haben wir im Discord einen Kanal eingerichtet, " +
    "in dem ihr eure Portraits hochladen könnt, damit sie allen zur Verfügung gestellt werden können." +
    "\n\nBesucht und auf https://mintarn.de oder im Discord https://discord.gg/Tp2qyYp!";
    SendMessageToPC(oPc, sBeta);
    NWNX_Chat_SendMessage(4, sBeta, GetObjectByTag("ERZAEHLER"), oPc);
    */
}
