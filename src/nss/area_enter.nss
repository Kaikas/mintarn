#include "nwnx_sql"
#include "global_helper"
#include "nwnx_time"

// Spawnt Ressourcen und Encounter
void main() {
    string sQuery;

    // Prüfe ob ein anderer Spieler im Gebiet ist
    object oPc = GetEnteringObject();
    if (GetIsPC(oPc) || GetIsDM(oPc)) {
        string sAccountName = GetPCPlayerName(oPc);
        string sName = GetName(oPc);
        if (GetTag(OBJECT_SELF) == "AREA_Freihafen") {
            // Make area visible
            ExploreAreaForPlayer(OBJECT_SELF, oPc);
            // Anfänger Quest
            sQuery = "SELECT * FROM QuestStatus WHERE name=? AND charname=? AND quest=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, sAccountName);
                NWNX_SQL_PreparedString(1, sName);
                NWNX_SQL_PreparedInt(2, 0);
                NWNX_SQL_ExecutePreparedQuery();
                NWNX_SQL_ReadNextRow();
                if (NWNX_SQL_ReadDataInActiveRow(4) == "0") {
                    sQuery = "UPDATE QuestStatus SET stage=? WHERE name=? AND charname=? AND quest=?";
                    if (NWNX_SQL_PrepareQuery(sQuery)) {
                        NWNX_SQL_PreparedString(0, "1");
                        NWNX_SQL_PreparedString(1, sAccountName);
                        NWNX_SQL_PreparedString(2, sName);
                        NWNX_SQL_PreparedString(3, "0");
                        NWNX_SQL_ExecutePreparedQuery();
                        AddJournalQuestEntry("quests", 1, oPc, FALSE, FALSE, FALSE);
                        CreateItemOnObject("sw_qu_paket", oPc, 1);
                        object oKapitaen = GetObjectByTag("NPC_KapitaenQuest");
                        AssignCommand(oKapitaen, ActionStartConversation(oPc, "conv_queststart", TRUE));
                    }
                }
            }
        }
        // Weather
        object oModule = GetModule();
        string sDay = IntToString(GetCalendarYear()) + "." + IntToString(GetCalendarMonth()) + "." + IntToString(GetCalendarDay());
        int iTemperatur = GetLocalInt(oModule, sDay) - 100;
        if (iTemperatur == -100) return;
        int iWindStrength = GetLocalInt(oModule, "windstrength");
        string sWindDirection = GetLocalString(oModule, "sWindDirection");
        int iRain = GetLocalInt(oModule, "rain");
        SendMessageToPC(oPc, GetToken(103) + "Es ist der " +
            LeadingZeros(IntToString(GetCalendarDay()), 2) +
            "." + LeadingZeros(IntToString(GetCalendarMonth()), 2) +
            "." + LeadingZeros(IntToString(GetCalendarYear()), 2) +
            " DR " +
            " " + LeadingZeros(IntToString(GetTimeHour()), 2) +
            ":" +
            LeadingZeros(IntToString(GetTimeMinute()), 2) +
            "Uhr.</c>");
        SendMessageToPC(oPc, GetToken(103) + "Die Außentemperatur beträgt " + IntToString(iTemperatur) + "°C</c>");
        string sWindStrength;
        // Possible: N, NO, O, SO, S, SW, W, NW
        // Sehr stark (5), Strong (4), medium (3), weak (2), windstill (1)
        if (iWindStrength == 1) {
            SendMessageToPC(oPc, GetToken(103) + "Es ist windstill.</c>");
        } else if (iWindStrength == 2) {
            SendMessageToPC(oPc, GetToken(103) + "Es weht ein schwacher " + sWindDirection + " .</c>");
        } else if (iWindStrength == 3) {
            SendMessageToPC(oPc, GetToken(103) + "Es weht ein mittelstarker " + sWindDirection + ".</c>");
        } else if (iWindStrength == 4) {
            SendMessageToPC(oPc, GetToken(103) + "Es weht ein starker " + sWindDirection + "</c>");
        } else if (iWindStrength == 5) {
            SendMessageToPC(oPc, GetToken(103) + "Es weht ein sehr starker " + sWindDirection + ".</c>");
        }
        if (GetTimeHour() > GetLocalInt(oModule, sDay + "fog_start") && GetTimeHour() < GetLocalInt(oModule, sDay + "fog_end") && iWindStrength < 3 && (iRain == 1 || iRain == 3)) {
            SendMessageToPC(oPc, GetToken(103) + "Nebel schränkt die Sicht ein.</c>");
        }
        // Nether
        if (GetTag(OBJECT_SELF) == "AREA_Nether") {
            string sMessage = "Ihr seid gestorben. Wenn ihr betet könnte sich ein Gott eurer annehmen. (( Gebt /beten ein. ))";
            SendMessageToPC(oPc, sMessage);
            return;
        }

        // If first player, fill area
        int iPlayers = 0;
        object oPlayer = GetFirstPC();
        while(GetIsObjectValid(oPlayer)) {
            if (GetTag(GetArea(oPlayer)) ==  GetTag(GetArea(oPlayer))) {
              if (!GetIsDM(oPlayer)) {
                iPlayers++;
              }
            }
            oPlayer = GetNextPC();
        }
        SendMessageToPC(oPc, "DEBUG: Es sind " + IntToString(iPlayers) + " im Gebiet");
        if (iPlayers < 2) {
            // Set refresh tag
            SetLocalInt(GetArea(oPc), "area_enter", NWNX_Time_GetTimeStamp());
            // Delete items in area
            object oObject = GetFirstObjectInArea(OBJECT_SELF);
            string sFirstChars;
            while(GetIsObjectValid(oObject)) {
                sFirstChars = GetSubString(GetTag(oObject), 0, 6);
                // Ressources
                if (sFirstChars == "PLACE_") {
                    DestroyObject(oObject);
                }
                // Mobs and bosses
                if (sFirstChars == "ENEMY_") {
                   DestroyObject(oObject);
                }
                // Chests
                if (sFirstChars == "CHEST_") {
                   DestroyObject(oObject);
                }
                oObject = GetNextObjectInArea(OBJECT_SELF);
            }

            // Create Traps
            oObject = GetFirstObjectInArea(OBJECT_SELF);
            while(GetIsObjectValid(oObject)) {
                 if(GetTag(oObject) == "TRAP") {
                     DestroyObject(oObject);
                 }
                 oObject = GetNextObjectInArea(OBJECT_SELF);
            }
            while(GetIsObjectValid(oObject)) {
                 if(GetTag(oObject) == "FALLE_KLINGE1") {
                     CreateTrapAtLocation(50, GetLocation(GetNearestObjectByTag("FALLE_KLINGE1")), 1.0f, "TRAP");
                 }
                 oObject = GetNextObjectInArea(OBJECT_SELF);
            }

            // Create new ressource
            sQuery = "SELECT * FROM Ressources WHERE area=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, GetTag(OBJECT_SELF));
                NWNX_SQL_ExecutePreparedQuery();

                vector vPosition;
                float fFacing;
                int iTier;

                // For each ressource in area
                while (NWNX_SQL_ReadyToReadNextRow()) {
                    NWNX_SQL_ReadNextRow();
                    vPosition.x = StringToFloat(NWNX_SQL_ReadDataInActiveRow(2));
                    vPosition.y = StringToFloat(NWNX_SQL_ReadDataInActiveRow(3));
                    vPosition.z = StringToFloat(NWNX_SQL_ReadDataInActiveRow(4));
                    fFacing = StringToFloat(NWNX_SQL_ReadDataInActiveRow(5));
                    iTier = StringToInt(NWNX_SQL_ReadDataInActiveRow(6));

                    int iRand = Random(100);
                    int iRandRessource;
                    location locTarget = Location(OBJECT_SELF, vPosition, fFacing);
                    if (iRand < 90 && iRand > 30) {
                        // Tier 1
                        iRandRessource = Random(5);
                        if (iRandRessource == 0) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_arganwurze", locTarget);
                        if (iRandRessource == 1) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_hiradwurz", locTarget);
                        if (iTier == 1) {
                            if (iRandRessource == 2) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_birke", locTarget);
                        }
                        if (iRandRessource == 3) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_eisenerz", locTarget);
                        if (iRandRessource == 4) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_pilz", locTarget);
                    } else if (iRand > 96 && iRand < 99) {
                        // Tier 2
                        iRandRessource = Random(7);
                        if (iRandRessource == 0) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_arksau", locTarget);
                        if (iRandRessource == 1) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_brorkwilb", locTarget);
                        if (iRandRessource == 2) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_carlog", locTarget);
                        if (iTier == 1) {
                            if (iRandRessource == 3 || iRandRessource == 4) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_esche", locTarget);
                        }
                        if (iRandRessource == 5 || iRandRessource == 6) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_adamanterz", locTarget);
                    } else if (iRand > 98) {
                        // Tier 3
                        iRandRessource = Random(6);
                        if (iRandRessource == 0) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_chronichin", locTarget);
                        if (iRandRessource == 1) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_wirselkrau", locTarget);
                        if (iTier == 1) {
                            if (iRandRessource == 2 || iRandRessource == 3) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_eiche", locTarget);
                        }
                        if (iRandRessource == 4 || iRandRessource == 5) CreateObject(OBJECT_TYPE_PLACEABLE, "sw_pl_mithrilerz", locTarget);
                    }
                }
            }
            // Create new mob/boss
            sQuery = "SELECT * FROM Encounter WHERE area=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, GetTag(OBJECT_SELF));
                NWNX_SQL_ExecutePreparedQuery();

                vector vPosition;
                float fFacing;
                string sType;

                // For each creature in area
                while (NWNX_SQL_ReadyToReadNextRow()) {
                    NWNX_SQL_ReadNextRow();
                    vPosition.x = StringToFloat(NWNX_SQL_ReadDataInActiveRow(2));
                    vPosition.y = StringToFloat(NWNX_SQL_ReadDataInActiveRow(3));
                    vPosition.z = StringToFloat(NWNX_SQL_ReadDataInActiveRow(4));
                    fFacing = StringToFloat(NWNX_SQL_ReadDataInActiveRow(5));
                    sType = NWNX_SQL_ReadDataInActiveRow(6);
                    int iChance = StringToInt(NWNX_SQL_ReadDataInActiveRow(7));
                    location locTarget = Location(OBJECT_SELF, vPosition, fFacing);
                    if (Random(100) + 1 > 100 - iChance) {
                        object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sType, locTarget);
                        SendMessageToPC(oPc, "DEBUG: platziere Gegner");
                        SetLocalInt(oCreature, "id", StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
                    }
                }
            }
            // Create new chests
            sQuery = "SELECT * FROM Chests WHERE area=?";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, GetTag(OBJECT_SELF));
                NWNX_SQL_ExecutePreparedQuery();
                vector vPosition;
                float fFacing;
                string sType;
                while (NWNX_SQL_ReadyToReadNextRow()) {
                    NWNX_SQL_ReadNextRow();
                    vPosition.x = StringToFloat(NWNX_SQL_ReadDataInActiveRow(2));
                    vPosition.y = StringToFloat(NWNX_SQL_ReadDataInActiveRow(3));
                    vPosition.z = StringToFloat(NWNX_SQL_ReadDataInActiveRow(4));
                    fFacing = StringToFloat(NWNX_SQL_ReadDataInActiveRow(5));
                    string sTier = NWNX_SQL_ReadDataInActiveRow(6);

                    location locTarget = Location(OBJECT_SELF, vPosition, fFacing);
                    if (sTier == "1") {
                        if (Random(50) == 0) {
                            object oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "kiste", locTarget);
                            if (Random(2) == 0) {
                                ActionLockObject(oChest);
                            }
                            int iTreasure = Random(115);
                            if (iTreasure < 10) {
                                CreateItemOnObject("NW_IT_GOLD001", oChest, Random(50) + 450);
                            } else {
                                CreateItemOnObject("NW_IT_GOLD001", oChest, Random(50) + 200);
                            }
                            if (iTreasure == 10) CreateItemOnObject("sw_re_amudex", oChest, 1);
                            if (iTreasure == 11) CreateItemOnObject("sw_re_amudexg", oChest, 1);
                            if (iTreasure == 12) CreateItemOnObject("sw_re_amuintg", oChest, 1);
                            if (iTreasure == 13) CreateItemOnObject("sw_re_amucong", oChest, 1);
                            if (iTreasure == 14) CreateItemOnObject("sw_re_amustrg", oChest, 1);
                            if (iTreasure == 15) CreateItemOnObject("sw_re_amuwisg", oChest, 1);
                            if (iTreasure == 16) CreateItemOnObject("sw_re_amuint", oChest, 1);
                            if (iTreasure == 17) CreateItemOnObject("sw_re_amucon", oChest, 1);
                            if (iTreasure == 18) CreateItemOnObject("sw_re_amudexr", oChest, 1);
                            if (iTreasure == 19) CreateItemOnObject("sw_re_amuintr", oChest, 1);
                            if (iTreasure == 20) CreateItemOnObject("sw_re_amuconr", oChest, 1);
                            if (iTreasure == 21) CreateItemOnObject("sw_re_amustrr", oChest, 1);
                            if (iTreasure == 22) CreateItemOnObject("sw_re_amuwisr", oChest, 1);
                            if (iTreasure == 23) CreateItemOnObject("sw_re_amuwis", oChest, 1);
                            if (iTreasure == 24) CreateItemOnObject("sw_re_amucha", oChest, 1);
                            if (iTreasure == 25) CreateItemOnObject("sw_re_amuchag", oChest, 1);
                            if (iTreasure == 26) CreateItemOnObject("sw_re_amuchar", oChest, 1);
                            if (iTreasure == 27) CreateItemOnObject("sw_re_guertelele", oChest, 1);
                            if (iTreasure == 28) CreateItemOnObject("sw_re_guertelene", oChest, 1);
                            if (iTreasure == 29) CreateItemOnObject("sw_re_guertelelg", oChest, 1);
                            if (iTreasure == 30) CreateItemOnObject("sw_re_guerteleng", oChest, 1);
                            if (iTreasure == 31) CreateItemOnObject("sw_re_guertelkrg", oChest, 1);
                            if (iTreasure == 32) CreateItemOnObject("sw_re_guertelkra", oChest, 1);
                            if (iTreasure == 33) CreateItemOnObject("sw_re_guertelelm", oChest, 1);
                            if (iTreasure == 34) CreateItemOnObject("sw_re_guertelenm", oChest, 1);
                            if (iTreasure == 35) CreateItemOnObject("sw_re_guertelkrm", oChest, 1);
                            if (iTreasure == 36) CreateItemOnObject("sw_re_guertelgif", oChest, 1);
                            if (iTreasure == 37) CreateItemOnObject("sw_re_guertelgig", oChest, 1);
                            if (iTreasure == 38) CreateItemOnObject("sw_re_guertelveg", oChest, 1);
                            if (iTreasure == 39) CreateItemOnObject("sw_re_guertelgim", oChest, 1);
                            if (iTreasure == 40) CreateItemOnObject("sw_re_guertelvem", oChest, 1);
                            if (iTreasure == 41) CreateItemOnObject("sw_re_guertelver", oChest, 1);
                            if (iTreasure == 42) CreateItemOnObject("sw_re_helm", oChest, 1);
                            if (iTreasure == 43) CreateItemOnObject("sw_re_helmschgrs", oChest, 1);
                            if (iTreasure == 44) CreateItemOnObject("sw_re_helmschutz", oChest, 1);
                            if (iTreasure == 45) CreateItemOnObject("sw_re_bolzen", oChest, 1);
                            if (iTreasure == 46) CreateItemOnObject("sw_re_bolzeng", oChest, 1);
                            if (iTreasure == 47) CreateItemOnObject("sw_re_pfeilg", oChest, 1);
                            if (iTreasure == 48) CreateItemOnObject("sw_re_kugel", oChest, 1);
                            if (iTreasure == 49) CreateItemOnObject("sw_re_pfeil", oChest, 1);
                            if (iTreasure == 50) CreateItemOnObject("sw_re_bolzens", oChest, 1);
                            if (iTreasure == 51) CreateItemOnObject("sw_re_pfeils", oChest, 1);
                            if (iTreasure == 52) CreateItemOnObject("sw_re_braten", oChest, 1);
                            if (iTreasure == 53) CreateItemOnObject("sw_re_pilzragout", oChest, 1);
                            if (iTreasure == 54) CreateItemOnObject("sw_re_kettenpanz", oChest, 1);
                            if (iTreasure == 55) CreateItemOnObject("sw_re_lederruest", oChest, 1);
                            if (iTreasure == 56) CreateItemOnObject("sw_re_plattenhar", oChest, 1);
                            if (iTreasure == 57) CreateItemOnObject("sw_re_grossersch", oChest, 1);
                            if (iTreasure == 58) CreateItemOnObject("sw_re_kleinschil", oChest, 1);
                            if (iTreasure == 59) CreateItemOnObject("sw_re_grosserr", oChest, 1);
                            if (iTreasure == 60) CreateItemOnObject("sw_re_kleinerr", oChest, 1);
                            if (iTreasure == 61) CreateItemOnObject("sw_re_turmr", oChest, 1);
                            if (iTreasure == 62) CreateItemOnObject("sw_re_grossers", oChest, 1);
                            if (iTreasure == 63) CreateItemOnObject("sw_re_kleiners", oChest, 1);
                            if (iTreasure == 64) CreateItemOnObject("sw_re_turmschils", oChest, 1);
                            if (iTreasure == 65) CreateItemOnObject("sw_re_turmschild", oChest, 1);
                            if (iTreasure == 66) CreateItemOnObject("sw_re_grosserhei", oChest, 1);
                            if (iTreasure == 67) CreateItemOnObject("sw_re_kleinerhei", oChest, 1);
                            if (iTreasure == 68) CreateItemOnObject("sw_re_mittlererh", oChest, 1);
                            if (iTreasure == 69) CreateItemOnObject("sw_re_trankderna", oChest, 1);
                            if (iTreasure == 70) CreateItemOnObject("sw_re_trankderun", oChest, 1);
                            if (iTreasure == 71) CreateItemOnObject("sw_re_trankdesge", oChest, 1);
                            if (iTreasure == 72) CreateItemOnObject("sw_re_trankdeskl", oChest, 1);
                            if (iTreasure == 73) CreateItemOnObject("sw_re_umhang", oChest, 1);
                            if (iTreasure == 74) CreateItemOnObject("sw_re_bastardsch", oChest, 1);
                            if (iTreasure == 75) CreateItemOnObject("sw_re_dolch", oChest, 1);
                            if (iTreasure == 76) CreateItemOnObject("sw_re_dreizack", oChest, 1);
                            if (iTreasure == 77) CreateItemOnObject("sw_re_flegel", oChest, 1);
                            if (iTreasure == 78) CreateItemOnObject("sw_re_grossschwe", oChest, 1);
                            if (iTreasure == 79) CreateItemOnObject("sw_re_hammer", oChest, 1);
                            if (iTreasure == 80) CreateItemOnObject("sw_re_handaxt", oChest, 1);
                            if (iTreasure == 81) CreateItemOnObject("sw_re_hellebarde", oChest, 1);
                            if (iTreasure == 82) CreateItemOnObject("sw_re_kama", oChest, 1);
                            if (iTreasure == 83) CreateItemOnObject("sw_re_katana", oChest, 1);
                            if (iTreasure == 84) CreateItemOnObject("sw_re_keule", oChest, 1);
                            if (iTreasure == 85) CreateItemOnObject("sw_re_kriegsaxt", oChest, 1);
                            if (iTreasure == 86) CreateItemOnObject("sw_re_kriegshamm", oChest, 1);
                            if (iTreasure == 87) CreateItemOnObject("sw_re_kukri", oChest, 1);
                            if (iTreasure == 88) CreateItemOnObject("sw_re_kurzbogen", oChest, 1);
                            if (iTreasure == 89) CreateItemOnObject("sw_re_kurzschwer", oChest, 1);
                            if (iTreasure == 90) CreateItemOnObject("sw_re_langbogen", oChest, 1);
                            if (iTreasure == 91) CreateItemOnObject("sw_re_langschwer", oChest, 1);
                            if (iTreasure == 92) CreateItemOnObject("sw_re_leicharmbr", oChest, 1);
                            if (iTreasure == 93) CreateItemOnObject("sw_re_morgenster", oChest, 1);
                            if (iTreasure == 94) CreateItemOnObject("sw_re_peitsche", oChest, 1);
                            if (iTreasure == 95) CreateItemOnObject("sw_re_rapier", oChest, 1);
                            if (iTreasure == 96) CreateItemOnObject("sw_re_saebel", oChest, 1);
                            if (iTreasure == 97) CreateItemOnObject("sw_re_schleuder", oChest, 1);
                            if (iTreasure == 98) CreateItemOnObject("sw_re_schwarmbru", oChest, 1);
                            if (iTreasure == 99) CreateItemOnObject("sw_re_schwflegel", oChest, 1);
                            if (iTreasure == 100) CreateItemOnObject("sw_re_sense", oChest, 1);
                            if (iTreasure == 101) CreateItemOnObject("sw_re_shuriken", oChest, 1);
                            if (iTreasure == 102) CreateItemOnObject("sw_re_sichel", oChest, 1);
                            if (iTreasure == 103) CreateItemOnObject("sw_re_speer", oChest, 1);
                            if (iTreasure == 104) CreateItemOnObject("sw_re_stab", oChest, 1);
                            if (iTreasure == 105) CreateItemOnObject("sw_re_streitlkol", oChest, 1);
                            if (iTreasure == 106) CreateItemOnObject("sw_re_wurfaxt", oChest, 1);
                            if (iTreasure == 107) CreateItemOnObject("sw_re_wurfpfeil", oChest, 1);
                            if (iTreasure == 108) CreateItemOnObject("sw_re_zhaxt", oChest, 1);
                            if (iTreasure == 109) CreateItemOnObject("sw_re_zweiaxt", oChest, 1);
                            if (iTreasure == 110) CreateItemOnObject("sw_re_zweistreit", oChest, 1);
                            if (iTreasure == 111) CreateItemOnObject("sw_re_zweischwer", oChest, 1);
                            if (iTreasure == 112) CreateItemOnObject("sw_re_kompositbo", oChest, 1);
                            if (iTreasure == 113) CreateItemOnObject("sw_re_kugelg", oChest, 1);
                            if (iTreasure == 114) CreateItemOnObject("sw_re_kugels", oChest, 1);
                        }
                    }
                }
            }
        }
    }
}
