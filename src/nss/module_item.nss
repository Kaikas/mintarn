#include "x2_inc_switches"
#include "global_helper"
#include "nwnx_sql"
#include "nwnx_time"

const int SKILL_CRAFT_LEATHERER = 31;
const int SKILL_CRAFT_SMITH = 9;
const int SKILL_CRAFT_CARPENTER = 15;
const int SKILL_CRAFT_ALCHEMIST = 33;

// Zählt die items im Inventar
int CountItems(object oPc, string sTag) {
    int i = 0;
    if (sTag == "") {
        return 0;
    }
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID) {
        if (GetTag(oItem) == sTag) {
            i++;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return i;
}

// Löscht items aus dem Inventar des Spielers
void DestroyItems(object oPc, string sTag, int iCount) {
    object oItem = GetFirstItemInInventory(oPc);
    int i = 0;
    while (oItem != OBJECT_INVALID) {
        if (i == iCount) {
            return;
        }
        if (GetTag(oItem) == sTag) {
            i++;
            if (GetItemStackSize(oItem) > 1) {
                SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            } else {
                DestroyObject(oItem);
            }
        }
        oItem = GetNextItemInInventory(oPc);
    }
}

// Craftet ein item
void CraftItem(object oPc, int iAmount, string sItem, string sResource1, int iCount1, string sResource2, int iCount2, string sResource3, int iCount3, string sLocation, string sReceipe, int iDestroy, int iXp, string sProficiency) {
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    if (sLocation == "Schmiede") {
        if ((GetDistanceBetween(GetObjectByTag("WP_SCHMIEDE"), oPc) == 0.0 || GetDistanceBetween(GetObjectByTag("WP_SCHMIEDE"), oPc) > 10.0)) {
            FloatingTextStringOnCreature("Ihr müsst euch am Amboss vor der Schmiede aufhalten um dies herzustellen.", oPc, FALSE);
            return;
        }
    }
    if (sLocation == "Lederer") {
        if ((GetDistanceBetween(GetObjectByTag("WP_LEDERER"), oPc) == 0.0 || GetDistanceBetween(GetObjectByTag("WP_LEDERER"), oPc) > 10.0)) {
            FloatingTextStringOnCreature("Ihr müsst euch an der Werkbank des Lederers aufhalten um dies herzustellen.", oPc, FALSE);
            return;
        }
    }
    if (sLocation == "Schreiner") {
        if ((GetDistanceBetween(GetObjectByTag("WP_SCHREINER"), oPc) == 0.0 || GetDistanceBetween(GetObjectByTag("WP_SCHREINER"), oPc) > 10.0)) {
            FloatingTextStringOnCreature("Ihr müsst euch an der Werkbank des Schreiners aufhalten um dies herzustellen.", oPc, FALSE);
            return;
        }
    }
    if (sLocation == "Alchemie") {
        if ((GetDistanceBetween(GetObjectByTag("WP_ALCHEMIE"), oPc) == 0.0 || GetDistanceBetween(GetObjectByTag("WP_ALCHEMIE"), oPc) > 10.0)) {
            FloatingTextStringOnCreature("Ihr müsst euch an einem Alchemistentisch aufhalten um dies herzustellen.", oPc, FALSE);
            return;
        }
    }
    if (sLocation == "Kueche") {
        if ((GetDistanceBetween(GetObjectByTag("WP_KUECHE"), oPc) == 0.0 || GetDistanceBetween(GetObjectByTag("WP_KUECHE"), oPc) > 10.0)) {
            FloatingTextStringOnCreature("Ihr müsst euch in einer Küche aufhalten um dies herzustellen.", oPc, FALSE);
            return;
        }
    }
    // Check if required crafting level reached
    string sQuery = "SELECT * FROM Crafting WHERE name=? AND charname=? AND profession=?";
    int iCompleteXp = 0;
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_PreparedString(2, sLocation);
        NWNX_SQL_ExecutePreparedQuery();

        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            iCompleteXp = iCompleteXp + StringToInt(NWNX_SQL_ReadDataInActiveRow(6));
        }
    }

    // Add skillpoints
    if (sLocation == "Schreiner") {
        iXp = iXp + GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) * (5 + Random(5));
    }
    if (sLocation == "Lederer") {
        iXp = iXp + GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) * (5 + Random(5));
    }
    if (sLocation == "Schmiede") {
        iXp = iXp + GetSkillRank(SKILL_CRAFT_SMITH, oPc) * (5 + Random(5));
    }
    if (sLocation == "Alchemie") {
        iXp = iXp + GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) * (5 + Random(5));
    }

    if (sProficiency == "Geselle") {
        if (iCompleteXp < 2000) {
            SendMessageToPC(oPc, "Ihr seid nicht erfahren genug um dies herzustellen");
            return;
        }
    }
    if (sProficiency == "Experte") {
        if (iCompleteXp < 8000) {
            SendMessageToPC(oPc, "Ihr seid nicht erfahren genug um dies herzustellen");
            return;
        }
    }
    // Craft item
    if (CountItems(oPc, sResource1) >= iCount1 && CountItems(oPc, sResource2) >= iCount2 && CountItems(oPc, sResource3) >= iCount3) {
        DestroyItems(oPc, sResource1, iCount1);
        if (sResource2 != "") {
            DestroyItems(oPc, sResource2, iCount2);
        }
        if (sResource3 != "") {
            DestroyItems(oPc, sResource3, iCount3);
        }
        object oItem = CreateItemOnObject(sItem, oPc, iAmount);
        SetDescription(oItem, GetDescription(oItem) + "\n\nHergestellt von: " + GetName(oPc), TRUE);

        // Level up profession
        int iFinalXp = iXp + Random(10);
        sQuery = "INSERT INTO Crafting (name, charname, item, datetime, profession, xp) VALUES (?, ?, ?, ?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, sAccountName);
            NWNX_SQL_PreparedString(1, sName);
            NWNX_SQL_PreparedString(2, sItem);
            NWNX_SQL_PreparedString(3, IntToString(NWNX_Time_GetTimeStamp()));
            NWNX_SQL_PreparedString(4, sLocation);
            NWNX_SQL_PreparedString(5, IntToString(iFinalXp));
            NWNX_SQL_ExecutePreparedQuery();
        }


        string sMessage;
        if (sLocation == "Schmiede") {
            sMessage = "Ihr habt " + IntToString(iFinalXp) + " Erfahrung als Schmied gewonnen.";
        }
        if (sLocation == "Lederer") {
            sMessage = "Ihr habt " + IntToString(iFinalXp) + " Erfahrung als Lederer gewonnen.";
        }
        if (sLocation == "Schreiner") {
            sMessage = "Ihr habt " + IntToString(iFinalXp) + " Erfahrung als Schreiner gewonnen.";
        }
        if (sLocation == "Alchemie") {
            sMessage = "Ihr habt " + IntToString(iFinalXp) + " Erfahrung in Alchemie gewonnen.";
        }
        iCompleteXp = iCompleteXp + iFinalXp;
        if (sLocation != "Kueche" && sProficiency != "") {
            if (iCompleteXp < 2000) {
                sMessage = sMessage + " (Lehrling " + IntToString(iCompleteXp) + "/2000)";
            }
            if (iCompleteXp > 1999 && iCompleteXp < 8000) {
                sMessage = sMessage + " (Geselle " + IntToString(iCompleteXp) + "/8000)";
            }
            if (iCompleteXp > 7999) {
                sMessage = sMessage + " (Experte)";
            }
            SendMessageToPC(oPc, sMessage);
        }

        // Check if the receipe has to be destroyed after using it
        int iChanceToDestroy = 0;
        if (sLocation == "Schreiner") {
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 1) iChanceToDestroy = 95;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 2) iChanceToDestroy = 90;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 3) iChanceToDestroy = 85;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 4) iChanceToDestroy = 80;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 5) iChanceToDestroy = 75;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 6) iChanceToDestroy = 71;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 7) iChanceToDestroy = 67;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 8) iChanceToDestroy = 63;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 9) iChanceToDestroy = 59;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 10) iChanceToDestroy = 55;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 11) iChanceToDestroy = 52;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 12) iChanceToDestroy = 49;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 13) iChanceToDestroy = 46;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 14) iChanceToDestroy = 43;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 15) iChanceToDestroy = 40;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 16) iChanceToDestroy = 38;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 17) iChanceToDestroy = 36;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 18) iChanceToDestroy = 34;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 19) iChanceToDestroy = 32;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 20) iChanceToDestroy = 30;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 21) iChanceToDestroy = 29;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 22) iChanceToDestroy = 28;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 23) iChanceToDestroy = 27;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 24) iChanceToDestroy = 26;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) == 25) iChanceToDestroy = 25;
            if (GetSkillRank(SKILL_CRAFT_CARPENTER, oPc) > 25) iChanceToDestroy = 25;
        }
        if (sLocation == "Lederer") {
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 1) iChanceToDestroy = 95;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 2) iChanceToDestroy = 90;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 3) iChanceToDestroy = 85;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 4) iChanceToDestroy = 80;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 5) iChanceToDestroy = 75;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 6) iChanceToDestroy = 71;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 7) iChanceToDestroy = 67;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 8) iChanceToDestroy = 63;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 9) iChanceToDestroy = 59;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 10) iChanceToDestroy = 55;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 11) iChanceToDestroy = 52;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 12) iChanceToDestroy = 49;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 13) iChanceToDestroy = 46;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 14) iChanceToDestroy = 43;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 15) iChanceToDestroy = 40;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 16) iChanceToDestroy = 38;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 17) iChanceToDestroy = 36;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 18) iChanceToDestroy = 34;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 19) iChanceToDestroy = 32;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 20) iChanceToDestroy = 30;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 21) iChanceToDestroy = 29;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 22) iChanceToDestroy = 28;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 23) iChanceToDestroy = 27;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 24) iChanceToDestroy = 26;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) == 25) iChanceToDestroy = 25;
            if (GetSkillRank(SKILL_CRAFT_LEATHERER, oPc) > 25) iChanceToDestroy = 25;
        }
        if (sLocation == "Schmiede") {
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 1) iChanceToDestroy = 95;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 2) iChanceToDestroy = 90;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 3) iChanceToDestroy = 85;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 4) iChanceToDestroy = 80;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 5) iChanceToDestroy = 75;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 6) iChanceToDestroy = 71;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 7) iChanceToDestroy = 67;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 8) iChanceToDestroy = 63;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 9) iChanceToDestroy = 59;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 10) iChanceToDestroy = 55;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 11) iChanceToDestroy = 52;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 12) iChanceToDestroy = 49;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 13) iChanceToDestroy = 46;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 14) iChanceToDestroy = 43;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 15) iChanceToDestroy = 40;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 16) iChanceToDestroy = 38;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 17) iChanceToDestroy = 36;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 18) iChanceToDestroy = 34;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 19) iChanceToDestroy = 32;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 20) iChanceToDestroy = 30;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 21) iChanceToDestroy = 29;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 22) iChanceToDestroy = 28;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 23) iChanceToDestroy = 27;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 24) iChanceToDestroy = 26;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) == 25) iChanceToDestroy = 25;
            if (GetSkillRank(SKILL_CRAFT_SMITH, oPc) > 25) iChanceToDestroy = 25;
        }
        if (sLocation == "Alchemie") {
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 1) iChanceToDestroy = 95;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 2) iChanceToDestroy = 90;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 3) iChanceToDestroy = 85;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 4) iChanceToDestroy = 80;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 5) iChanceToDestroy = 75;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 6) iChanceToDestroy = 71;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 7) iChanceToDestroy = 67;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 8) iChanceToDestroy = 63;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 9) iChanceToDestroy = 59;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 10) iChanceToDestroy = 55;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 11) iChanceToDestroy = 52;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 12) iChanceToDestroy = 49;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 13) iChanceToDestroy = 46;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 14) iChanceToDestroy = 43;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 15) iChanceToDestroy = 40;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 16) iChanceToDestroy = 38;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 17) iChanceToDestroy = 36;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 18) iChanceToDestroy = 34;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 19) iChanceToDestroy = 32;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 20) iChanceToDestroy = 30;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 21) iChanceToDestroy = 29;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 22) iChanceToDestroy = 28;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 23) iChanceToDestroy = 27;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 24) iChanceToDestroy = 26;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) == 25) iChanceToDestroy = 25;
            if (GetSkillRank(SKILL_CRAFT_ALCHEMIST, oPc) > 25) iChanceToDestroy = 25;
        }

        if (iDestroy) {
            if (Random(100) <= iChanceToDestroy) {
                object oItem = GetFirstItemInInventory(oPc);
                while (oItem != OBJECT_INVALID) {
                    if (GetTag(oItem) == sReceipe) {
                        DestroyObject(oItem);
                        return;
                    }
                    oItem = GetNextItemInInventory(oPc);
                }
            }
        }
    } else {
        //SendMessageToPC(oPc, "Ihr habt nicht die nötigen Ressourcen im Inventar.");
        FloatingTextStringOnCreature("Ihr habt nicht die nötigen Ressourcen im Inventar.", oPc, FALSE);
    }
}

// On Actviate Item
void main() {
    object oPc = GetItemActivator();
    object oItem = GetItemActivated();
    location oLocation = GetItemActivatedTargetLocation();

    // Weiteres
    if (GetTag(oItem) == "CRAFT_RezeptMagischerBeutel")
        CraftItem(oPc, 1, "sw_we_beutel", "CRAFT_GutesLeder", 5, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptMagischerBeutel", TRUE, 90, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptFackel")
        CraftItem(oPc, 1, "sw_we_fackel", "CRAFT_Birkenholz", 1, "", 0, "", 0, "", "CRAFT_RezeptFackel", FALSE, 0, "");
    if (GetTag(oItem) == "CRAFT_RezeptEisenbarren")
        CraftItem(oPc, 1, "sw_ro_eisenbarre", "CRAFT_Eisenerz", 2, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptEisenbarren", FALSE, 60, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptAdamantbarren")
        CraftItem(oPc, 1, "sw_ro_adamantbar", "CRAFT_Adamanterz", 2, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptAdamantbarren", FALSE, 60, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptMithrilbarren")
        CraftItem(oPc, 1, "sw_ro_mithrilbar", "CRAFT_Mithrilerz", 2, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptMithrilbarren", FALSE, 60, "Lehrling");
    // Waffen
    if (GetTag(oItem) == "CRAFT_RezeptBastardschwert")
        CraftItem(oPc, 1, "sw_wa_bastardsch", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptBastardschwert", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptDolch")
        CraftItem(oPc, 1, "sw_wa_dolch", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptDolch", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptDreizack")
        CraftItem(oPc, 1, "sw_wa_dreizack", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptDreizack", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptFlegel")
        CraftItem(oPc, 1, "sw_wa_flegel", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptFlegel", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptGrossschwert")
        CraftItem(oPc, 1, "sw_wa_grossschwe", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptGrossschwert", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptHammer")
        CraftItem(oPc, 1, "sw_wa_hammer", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptHammer", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptHandaxt")
        CraftItem(oPc, 1, "sw_wa_handaxt", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptHandaxt", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptHellebarde")
        CraftItem(oPc, 1, "sw_wa_hellebarde", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptHellebarde", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKama")
        CraftItem(oPc, 1, "sw_wa_kama", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptKama", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKatana")
        CraftItem(oPc, 1, "sw_wa_katana", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptKatana", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKeule")
        CraftItem(oPc, 1, "sw_wa_keule", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptKeule", FALSE, 4, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKriegsaxt")
        CraftItem(oPc, 1, "sw_wa_kriegsaxt", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "", 0, "Schmiede", "CRAFT_RezeptKriegsaxt", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKriegshammer")
        CraftItem(oPc, 1, "sw_wa_kriegshamm", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptKriegshammer", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKukri")
        CraftItem(oPc, 1, "sw_wa_kukri", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptKukri", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKurzbogen")
        CraftItem(oPc, 1, "sw_wa_kurzbogen", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptKurzbogen", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKurzschwert")
        CraftItem(oPc, 1, "sw_wa_kurzschwer", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptKurzschwert", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptLangbogen")
        CraftItem(oPc, 1, "sw_wa_langbogen", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptLangbogen", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptLangschwert")
        CraftItem(oPc, 1, "sw_wa_langschwer", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptLangschwert", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptLeichteArmbrust")
        CraftItem(oPc, 1, "sw_wa_leichtearm", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptLeichteArmbrust", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptMorgenstern")
        CraftItem(oPc, 1, "sw_wa_morgenster", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptMorgenstern", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptPeitsche")
        CraftItem(oPc, 1, "sw_wa_peitsche", "CRAFT_Leder", 1, "CRAFT_Birkenholz", 1, "CRAFT_Gerbstoff", 1, "Lederer", "CRAFT_RezeptPeitsche", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptRapier")
        CraftItem(oPc, 1, "sw_wa_rapier", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptRapier", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSaebel")
        CraftItem(oPc, 1, "sw_wa_saebel", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptSaebel", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSchleuder")
        CraftItem(oPc, 1, "sw_wa_schleuder", "CRAFT_Leder", 1, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptSchleuder", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSchwereArmbrust")
        CraftItem(oPc, 1, "sw_wa_schwarmbru", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptSchwereArmbrust", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSchwererFlegel")
        CraftItem(oPc, 1, "sw_wa_schwererfl", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptSchwererFlegel", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSense")
        CraftItem(oPc, 1, "sw_wa_sense", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptSense", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptShuriken")
        CraftItem(oPc, 10, "sw_wa_shuriken", "CRAFT_Eisenbarren", 1, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptShuriken", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSichel")
        CraftItem(oPc, 1, "sw_wa_sichel", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptSichel", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptSpeer")
        CraftItem(oPc, 1, "sw_wa_speer", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptSpeer", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptStab")
        CraftItem(oPc, 1, "sw_wa_stab", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptStab", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptStreitkolben")
        CraftItem(oPc, 1, "sw_wa_streitkolb", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptStreitkolben", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptWurfaxt")
        CraftItem(oPc, 10, "sw_wa_wurfaxt", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptWurfaxt", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptWurfpfeil")
        CraftItem(oPc, 10, "sw_wa_wurfpfeil", "CRAFT_Eisenbarren", 1, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptWurfpfeil", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptZweihaendigeAxt")
        CraftItem(oPc, 1, "sw_wa_zhaxt", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptZweihaendigeAxt", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptZweiseitigeAxt")
        CraftItem(oPc, 1, "sw_wa_zweiaxt", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptZweiseitigeAxt", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptZweiseitigerStreitko")
        CraftItem(oPc, 1, "sw_wa_zweistreit", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptZweiseitigerStreitko", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptZweiseitigesSchwert")
        CraftItem(oPc, 1, "sw_wa_zweischwer", "CRAFT_Eisenbarren", 1, "CRAFT_Birkenholz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptZweiseitigesSchwert", FALSE, 40, "Lehrling");
    // Waffen +1
    if (GetTag(oItem) == "CRAFT_RezeptKompositbogen")
        CraftItem(oPc, 1, "sw_wa_kompositbo", "CRAFT_Birkenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptKompositbogen", TRUE, 40, "Lehrling");

    // Rüstungen
    if (GetTag(oItem) == "CRAFT_RezeptKettenpanzer")
        CraftItem(oPc, 1, "sw_ru_kettenpanz", "CRAFT_Eisenbarren", 5, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptKettenpanzer", FALSE, 190, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptLederruestung")
        CraftItem(oPc, 1, "sw_ru_lederruest", "CRAFT_Leder", 25, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptLederruestung", FALSE, 190, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptPlattenharnisch")
        CraftItem(oPc, 1, "sw_ru_plattenhar", "CRAFT_Eisenbarren", 10, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptPlattenharnisch", FALSE, 390, "Lehrling");
    // Schilde
    if (GetTag(oItem) == "CRAFT_RezeptGrosserSchild")
        CraftItem(oPc, 1, "sw_sc_grossersch", "CRAFT_Birkenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptGrosserSchild", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKleinerSchild")
        CraftItem(oPc, 1, "sw_sc_kleinersch", "CRAFT_Birkenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptKleinerSchild", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptTurmschild")
        CraftItem(oPc, 1, "sw_sc_turmschild", "CRAFT_Birkenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptTurmschild", FALSE, 40, "Lehrling");

    if (GetTag(oItem) == "CRAFT_RezeptStabileGrosserSchild")
        CraftItem(oPc, 1, "sw_sc_grossers", "CRAFT_Eschenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptStabileGrosserSchild", TRUE, 90, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptStabileKleinerSchild")
        CraftItem(oPc, 1, "sw_sc_kleiners", "CRAFT_Eschenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptStabileKleinerSchild", TRUE, 90, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptStabileTurmschild")
        CraftItem(oPc, 1, "sw_sc_turmschs", "CRAFT_Eschenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptStabileTurmschild", TRUE, 90, "Geselle");

    if (GetTag(oItem) == "CRAFT_RezeptRobustGrosserSchild")
        CraftItem(oPc, 1, "sw_sc_grossers", "CRAFT_Eschenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptRobustGrosserSchild", TRUE, 190, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptRobustKleinerSchild")
        CraftItem(oPc, 1, "sw_sc_kleinerr", "CRAFT_Eschenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptRobustKleinerSchild", TRUE, 190, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptRobustTurmschild")
        CraftItem(oPc, 1, "sw_sc_turmschr", "CRAFT_Eschenholz", 5, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptRobustTurmschild", TRUE, 190, "Experte");


    // Helme
    if (GetTag(oItem) == "CRAFT_RezeptHelm")
        CraftItem(oPc, 1, "sw_he_helm", "CRAFT_Eisenbarren", 5, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptHelm", FALSE, 40, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptHelmDesSchutzes")
        CraftItem(oPc, 1, "sw_he_helmschutz", "CRAFT_Adamantbarren", 5, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptHelmDesSchutzes", TRUE, 490, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptHelmDesGrossSchutzes")
        CraftItem(oPc, 1, "sw_he_helmschgro", "CRAFT_Mithrilbarren", 5, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptHelmDesGrossSchutzes", TRUE, 990, "Experte");

    // Munition
    if (GetTag(oItem) == "CRAFT_RezeptBolzen")
        CraftItem(oPc, 100, "sw_mu_bolzen", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptBolzen", FALSE, 10, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptKugel")
        CraftItem(oPc, 100, "sw_mu_kugel", "CRAFT_Eisenbarren", 1, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptKugel", FALSE, 10, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptPfeil")
        CraftItem(oPc, 100, "sw_mu_pfeil", "CRAFT_Birkenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptPfeil", FALSE, 10, "Lehrling");

    if (GetTag(oItem) == "CRAFT_RezeptGuterBolzen")
        CraftItem(oPc, 100, "sw_mu_bolzeng", "CRAFT_Eschenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptGuterBolzen", TRUE, 20, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGuterPfeil")
        CraftItem(oPc, 100, "sw_mu_pfeilg", "CRAFT_Eschenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptGuterPfeil", TRUE, 20, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGuteKugel")
        CraftItem(oPc, 100, "sw_mu_kugelg", "CRAFT_Adamantbarren", 1, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptGuteKugel", FALSE, 20, "Geselle");

    if (GetTag(oItem) == "CRAFT_RezeptSehrGuterBolzen")
        CraftItem(oPc, 100, "sw_mu_bolzens", "CRAFT_Eichenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptSehrGuterBolzen", TRUE, 40, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptSehrGuterPfeil")
        CraftItem(oPc, 100, "sw_mu_pfeils", "CRAFT_Eichenholz", 1, "CRAFT_Holzrohling", 1, "", 0, "Schreiner", "CRAFT_RezeptSehrGuterPfeil", TRUE, 40, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptSehrGuteKugel")
        CraftItem(oPc, 100, "sw_mu_kugels", "CRAFT_Mithrilbarren", 1, "CRAFT_Schmiederohling", 1, "", 0, "Schmiede", "CRAFT_RezeptSehrGuteKugel", FALSE, 40, "Experte");

    // Umhänge
    if (GetTag(oItem) == "CRAFT_RezeptUmhang")
        CraftItem(oPc, 1, "sw_um_umhang", "CRAFT_Leder", 1, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptUmhang", FALSE, 40, "Lehrling");
    // Amulette
    if (GetTag(oItem) == "CRAFT_RezeptAmuDex")
        CraftItem(oPc, 1, "sw_am_amulettdex", "CRAFT_Eisenbarren", 2, "CRAFT_Malachit", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuDex", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptAmuInt")
        CraftItem(oPc, 1, "sw_am_int", "CRAFT_Eisenbarren", 2, "CRAFT_Diamant", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuInt", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptAmuCon")
        CraftItem(oPc, 1, "sw_am_con", "CRAFT_Eisenbarren", 2, "CRAFT_Achat", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuCon", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptAmuStr")
        CraftItem(oPc, 1, "sw_am_amulettstr", "CRAFT_Eisenbarren", 2, "CRAFT_Amethyst", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuStr", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptAmuWis")
        CraftItem(oPc, 1, "sw_am_amulettwis", "CRAFT_Eisenbarren", 2, "CRAFT_Quartz", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuWis", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptAmuCha")
        CraftItem(oPc, 1, "sw_am_amulettcha", "CRAFT_Eisenbarren", 2, "CRAFT_Onyx", 1, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuCha", TRUE, 90, "Lehrling");

    if (GetTag(oItem) == "CRAFT_RezeptAmuDexG")
        CraftItem(oPc, 1, "sw_am_dex2", "CRAFT_Adamantbarren", 2, "CRAFT_Malachit", 2, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuDexG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptAmuIntG")
        CraftItem(oPc, 1, "sw_am_int2", "CRAFT_Adamantbarren", 2, "CRAFT_Diamant", 2, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuIntG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptAmuConG")
        CraftItem(oPc, 1, "sw_am_con2", "CRAFT_Adamantbarren", 2, "CRAFT_Achat", 2, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuConG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptAmuStrG")
        CraftItem(oPc, 1, "sw_am_str2", "CRAFT_Adamantbarren", 2, "CRAFT_Amethyst", 2, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuStrG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptAmuWisG")
        CraftItem(oPc, 1, "sw_am_wis2", "CRAFT_Adamantbarren", 2, "CRAFT_Quartz", 2, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuWisG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptAmuChaG")
        CraftItem(oPc, 1, "sw_am_cha2", "CRAFT_Adamantbarren", 2, "CRAFT_Onyx", 2, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuChaG", TRUE, 190, "Geselle");

    if (GetTag(oItem) == "CRAFT_RezeptAmuDexR")
        CraftItem(oPc, 1, "sw_am_dex3", "CRAFT_Mithrilbarren", 2, "CRAFT_Malachit", 5, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuDexR", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptAmuIntR")
        CraftItem(oPc, 1, "sw_am_int3", "CRAFT_Mithrilbarren", 2, "CRAFT_Diamant", 5, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuIntR", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptAmuConR")
        CraftItem(oPc, 1, "sw_am_con3", "CRAFT_Mithrilbarren", 2, "CRAFT_Achat", 5, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuConR", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptAmuStrR")
        CraftItem(oPc, 1, "sw_am_str3", "CRAFT_Mithrilbarren", 2, "CRAFT_Amethyst", 5, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuStrR", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptAmuWisR")
        CraftItem(oPc, 1, "sw_am_wis3", "CRAFT_Mithrilbarren", 2, "CRAFT_Quartz", 5, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuWisR", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptAmuChaR")
        CraftItem(oPc, 1, "sw_am_cha3", "CRAFT_Mithrilbarren", 2, "CRAFT_Onyx", 5, "CRAFT_Schmiederohling", 1, "Schmiede", "CRAFT_RezeptAmuChaR", TRUE, 490, "Experte");

    // Gürtel
    if (GetTag(oItem) == "CRAFT_RezeptGuertelElemente")
        CraftItem(oPc, 1, "sw_gu_elemente", "CRAFT_Leder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelElemente", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelEnergie")
        CraftItem(oPc, 1, "sw_gu_energie", "CRAFT_Leder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelEnergie", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelKrankheit")
        CraftItem(oPc, 1, "sw_gu_krankheit", "CRAFT_Leder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelKrankheit", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelGift")
        CraftItem(oPc, 1, "sw_gu_gift", "CRAFT_Leder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelGift", TRUE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelVerstand")
        CraftItem(oPc, 1, "sw_gu_verstand", "CRAFT_Leder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelVerstand", TRUE, 90, "Lehrling");

    if (GetTag(oItem) == "CRAFT_RezeptGuertelElementeG")
        CraftItem(oPc, 1, "sw_gu_element2", "CRAFT_GutesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelElementeG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelEnergieG")
        CraftItem(oPc, 1, "sw_gu_energie2", "CRAFT_GutesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelEnergieG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelKrankheitG")
        CraftItem(oPc, 1, "sw_gu_krankhe2", "CRAFT_GutesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelKrankheitG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelGiftG")
        CraftItem(oPc, 1, "sw_gu_gift2", "CRAFT_GutesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelGiftG", TRUE, 190, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelVerstandesG")
        CraftItem(oPc, 1, "sw_gu_verstan2", "CRAFT_GutesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelVerstandesG", TRUE, 190, "Geselle");

    if (GetTag(oItem) == "CRAFT_RezeptGuertelElementeM")
        CraftItem(oPc, 1, "sw_gu_melement", "CRAFT_EdlesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelElementeM", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelEnergieM")
        CraftItem(oPc, 1, "sw_gu_menergie", "CRAFT_EdlesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelEnergieM", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelKrankheitM")
        CraftItem(oPc, 1, "sw_gu_mkrankhe", "CRAFT_EdlesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelKrankheitM", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelGiftM")
        CraftItem(oPc, 1, "sw_gu_mgift", "CRAFT_EdlesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelGiftM", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelGiftM")
        CraftItem(oPc, 1, "sw_gu_mgift", "CRAFT_EdlesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelGiftM", TRUE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptGuertelVerstandM")
        CraftItem(oPc, 1, "sw_gu_mverstan", "CRAFT_EdlesLeder", 10, "CRAFT_Gerbstoff", 1, "", 0, "Lederer", "CRAFT_RezeptGuertelVerstandM", TRUE, 490, "Experte");


    // Nahrung
    if (GetTag(oItem) == "CRAFT_RezeptPilzragout")
        CraftItem(oPc, 1, "sw_na_pilzragout", "CRAFT_Pilz", 5, "", 0, "", 0, "Kueche", "CRAFT_RezeptPilzragout", FALSE, 0, "");
    if (GetTag(oItem) == "CRAFT_RezeptBraten")
        CraftItem(oPc, 1, "sw_na_braten", "CRAFT_Fleisch", 5, "", 0, "", 0, "Kueche", "CRAFT_RezeptBraten", FALSE, 0, "");
    // Tränke
    if (GetTag(oItem) == "CRAFT_RezeptKleinerHeiltrank")
        CraftItem(oPc, 1, "sw_tr_kleineheil", "CRAFT_LeereFlasche", 1, "CRAFT_Arganwurzel", 1, "", 0, "Alchemie", "CRAFT_RezeptKleinerHeiltrank", FALSE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptMittlererHeiltrank")
        CraftItem(oPc, 1, "sw_tr_mittlerehe", "CRAFT_LeereFlasche", 1, "CRAFT_Arkasu", 1, "", 0, "Alchemie", "CRAFT_RezeptMittlererHeiltrank", FALSE, 150, "Geselle");
    if (GetTag(oItem) == "CRAFT_RezeptGrosserHeiltrank")
        CraftItem(oPc, 1, "sw_tr_grosseheil", "CRAFT_LeereFlasche", 1, "CRAFT_Chronichinis", 1, "", 0, "Alchemie", "CRAFT_RezeptGrosserHeiltrank", FALSE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptTrankDesKlarenVersta")
        CraftItem(oPc, 1, "sw_tr_klarervers", "CRAFT_LeereFlasche", 1, "CRAFT_Brorkwilb", 1, "", 0, "Alchemie", "CRAFT_RezeptTrankDesKlarenVersta", FALSE, 90, "Lehrling");
    if (GetTag(oItem) == "CRAFT_RezeptTrankDerUnsichtbarke")
        CraftItem(oPc, 1, "sw_tr_unsichtbar", "CRAFT_LeereFlasche", 1, "CRAFT_Wirselkraut", 1, "", 0, "Alchemie", "CRAFT_RezeptTrankDerUnsichtbarke", FALSE, 990, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptTrankDerNachtsicht")
        CraftItem(oPc, 1, "sw_tr_nachtsicht", "CRAFT_LeereFlasche", 1, "CRAFT_Carlog", 1, "", 0, "Alchemie", "CRAFT_RezeptTrankDerNachtsicht", FALSE, 490, "Experte");
    if (GetTag(oItem) == "CRAFT_RezeptTrankDesGegenmittels")
        CraftItem(oPc, 1, "sw_tr_gegenmitte", "CRAFT_LeereFlasche", 1, "CRAFT_Hiradwurz", 1, "", 0, "Alchemie", "CRAFT_RezeptTrankDesGegenmittels", FALSE, 90, "Lehrling");

    // DM Items

    // Unsichtbarkeitsitem
    if (GetTag(oItem) == "SW_Unsichtbarkeit") {
        effect eEffect = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPc, 180.0f);
    }
    // Belohnungsitem
    if (GetTag(oItem) == "SW_Belohnung") {
        object oTarget = GetItemActivatedTarget();
        SetLocalString(oPc, "targetaccount", GetPCPlayerName(oTarget));
        SetLocalString(oPc, "targetname", GetName(oTarget));
        SetLocalObject(oPc, "target", oTarget);
        AssignCommand(oPc, ActionStartConversation(oPc, "belohnung", TRUE));
    }
    // DM Sprich als System
    if (GetTag(oItem) == "SW_SprichAls1") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "dmspeak1", oTarget);
        SendMessageToPC(oPc, ":1 spricht nun als " + GetName(oTarget));
    }
    if (GetTag(oItem) == "SW_SprichAls2") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "dmspeak2", oTarget);
        SendMessageToPC(oPc, ":2 spricht nun als " + GetName(oTarget));
    }
    if (GetTag(oItem) == "SW_SprichAls3") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "dmspeak3", oTarget);
        SendMessageToPC(oPc, ":3 spricht nun als " + GetName(oTarget));
    }
    if (GetTag(oItem) == "SW_SprichAls4") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "dmspeak4", oTarget);
        SendMessageToPC(oPc, ":4 spricht nun als " + GetName(oTarget));
    }
    if (GetTag(oItem) == "SW_SprichAls5") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "dmspeak5", oTarget);
        SendMessageToPC(oPc, ":5 spricht nun als " + GetName(oTarget));
    }
    // Fraktion ändern
    if (GetTag(oItem) == "SW_FraktionAendern") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "fraktion", oTarget);
        SendMessageToPC(oPc, "Ändere Fraktion von " + GetName(oTarget));
        AssignCommand(oPc, ActionStartConversation(oPc, "fraktion", TRUE));
    }
    // SW Placer
    if (GetTag(oItem) == "SW_Placer") {
        object oArea = GetAreaFromLocation(oLocation);
        vector vPosition = GetPositionFromLocation(oLocation);
        float fFacing = GetFacingFromLocation(oLocation);
        SetLocalString(oPc, "placer_area", GetTag(oArea));
        SetLocalFloat(oPc, "placer_x", vPosition.x);
        SetLocalFloat(oPc, "placer_y", vPosition.y);
        SetLocalFloat(oPc, "placer_z", vPosition.z);
        SetLocalFloat(oPc, "placer_facing", fFacing);
        AssignCommand(oPc, ActionStartConversation(oPc, "placer", TRUE));
    }
    // Change Name
    if (GetTag(oItem) == "SW_ChangeName") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "changename", oTarget);
    }
    // Change description
    if (GetTag(oItem) == "SW_ChangeDesc") {
        object oTarget = GetItemActivatedTarget();
        SetLocalObject(oPc, "changedesc", oTarget);
    }
    // Feenstaub
    if (GetTag(oItem) == "CRAFT_Feenstaub") {
        // Macht den Spieler confused
        effect eConfused = EffectConfused();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfused, oPc, 3.0f);
        // Setze Konstitution runter
        effect eConstitution = EffectAbilityDecrease(ABILITY_CONSTITUTION, 4);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConstitution, oPc, 60.0f);
        // Setze Konzentration hoch
        effect eConcentration = EffectSkillIncrease(SKILL_CONCENTRATION, 4);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConcentration, oPc, 60.0f);
        // Zeige Effekt an
        //effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPc);
    }
    // SW Rasten
    if (GetTag(oItem) == "SW_Rasten") {
        object oTarget = GetItemActivatedTarget();
        string sQuery = "UPDATE Users SET rest=? WHERE name=? AND charname=?";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, "0");
            NWNX_SQL_PreparedString(1, GetPCPlayerName(oTarget));
            NWNX_SQL_PreparedString(2, GetName(oTarget));

            NWNX_SQL_ExecutePreparedQuery();
        }
        CreateItemOnObject("sw_na_braten", oTarget);
        SetLocalInt(oTarget, "rast", 1);
        ExecuteScript("global_rest", oTarget);
    }
    // SW Würfelbeutel
    if (GetTag(oItem) == "CRAFT_Wuerfelbeutel") {
        object oArea = GetAreaFromLocation(oLocation);
        vector vPosition = GetPositionFromLocation(oLocation);
        float fFacing = GetFacingFromLocation(oLocation);
        SetLocalString(oPc, "wuerfel_area", GetTag(oArea));
        SetLocalFloat(oPc, "wuerfel_x", vPosition.x);
        SetLocalFloat(oPc, "wuerfel_y", vPosition.y);
        SetLocalFloat(oPc, "wuerfel_z", vPosition.z);
        SetLocalFloat(oPc, "wuerfel_facing", fFacing);
        AssignCommand(oPc, ActionStartConversation(oPc, "wuerfel", TRUE));
    }
    // SW PlotFlag
    if (GetTag(oItem) == "SW_Plot") {
        object oTarget = GetItemActivatedTarget();
        if (GetPlotFlag(oTarget)) {
            SetPlotFlag(oTarget, FALSE);
            SendMessageToPC(oPc, GetName(oTarget) + " ist nicht mehr Plot.");
        } else {
            SetPlotFlag(oTarget, TRUE);
            SendMessageToPC(oPc, GetName(oTarget) + " ist nun Plot.");
        }
    }

    // SW Nebel
    if (GetTag(oItem) == "SW_Nebel") {
        object oArea = GetObjectByTag("AREA_Freihafen");
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);
        oArea = GetObjectByTag("AREA_Banditenfestung");
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);
        oArea = GetObjectByTag("AREA_Insel");
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);
        oArea = GetObjectByTag("AREA_Hgelland");
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);
        oArea = GetObjectByTag("AREA_versteckterHain");
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);
        oArea = GetObjectByTag("AREA_Westmark");
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea, "fog_sun"), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea, "fog_moon"), oArea);

        int i;
        object oFog;
        for (i = 0; i < 1000; i++) {
            oFog = GetObjectByTag("WEATHER_FOG", i);
            if (oFog != OBJECT_INVALID) {
                DestroyObject(oFog);
            }
        }
    }

    // SW Zeit
    if (GetTag(oItem) == "SW_Zeit") {
        AssignCommand(oPc, ActionStartConversation(oPc, "sw_zeit", TRUE));
    }
    // SW Haustier
    if (GetTag(oItem) == "SW_Haustier") {
        AssignCommand(oPc, ActionStartConversation(oPc, "sw_haustier", TRUE));
    }

    // SW Rueckruf
    if (GetTag(oItem) == "SW_Rueckruf") {
        /*if (GetTag(GetArea(oPc)) == "AREA_Banditenfestung" ||
            GetTag(GetArea(oPc)) == "AREA_AlteHtte" ||
            GetTag(GetArea(oPc)) == "AREA_Friedhof" ||
            GetTag(GetArea(oPc)) == "AREA_Hgelland" ||
            GetTag(GetArea(oPc)) == "AREA_versteckterHain" ||
            GetTag(GetArea(oPc)) == "AREA_Wald" ||
            GetTag(GetArea(oPc)) == "AREA_Westmark") {
            */
        if (GetTag(GetArea(oPc)) != "AREA_Nether") {
            AssignCommand(oPc, ClearAllActions());
            if (GetItemStackSize(oItem) < 2) {
                DestroyObject(oItem);
            } else {
                SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            }
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPc, 5.0f);
            AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0f));
            location lRueckruf = GetLocation(GetObjectByTag("WP_RUECKRUF"));
            DelayCommand(5.0, AssignCommand(oPc, JumpToLocation(lRueckruf)));
        } else {
            SendMessageToPC(oPc, "Das könnt ihr hier nicht benutzen!");
        }
    }

    // SW Alpha Badge
    if (GetTag(oItem) == "SW_Alpha") {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectVisualEffect(VFX_DUR_LIGHT_RED_5)), "eff_alphalight"), oPc);
        DelayCommand(2.0f, RemoveEffectByName(oPc, "eff_alphalight"));
    }

}
