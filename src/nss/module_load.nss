#include "x2_inc_switches"
#include "x2_inc_restsys"
#include "nwnx_sql"
#include "global_helper"
#include "nwnx_time"
#include "x3_inc_string"
#include "nwnx_webhook"
#include "nwnx_events"
#include "nwnx_skillranks"
#include "g_lights"

// Erstellt metainformationen die auf der webseite und auf hinweisschildern stehen
void CreateMeta(string tag, string text) {
    string sQuery = "INSERT INTO Meta (tag, text) VALUES (?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, tag);
        NWNX_SQL_PreparedString(1, text);
        NWNX_SQL_ExecutePreparedQuery();
    }
}

// Erstellt news eintraege auf der Webseite und auf dem Messageboard
void CreateNews(string text) {
    string sQuery = "INSERT INTO News (text) VALUES (?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, text);
        NWNX_SQL_ExecutePreparedQuery();
    }
}

void main() {
    WriteTimestampedLogEntry("Server is coming up.");

    // NWN default
   if (GetGameDifficulty() ==  GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty() ==  GAME_DIFFICULTY_DIFFICULT) {
        SetModuleSwitch (MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
   }
   SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, FALSE);
   if (GetModuleSwitchValue (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE) {
   }
   if (GetModuleSwitchValue(MODULE_SWITCH_USE_XP2_RESTSYSTEM) == TRUE) {
       WMBuild2DACache();
   }

    // Metadaten Datenbank erstellen
    string sQuery = "DROP TABLE Meta";
    NWNX_SQL_ExecuteQuery(sQuery);
    sQuery = "CREATE TABLE IF NOT EXISTS Meta (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "tag TEXT, " +
        "text TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);
    // Willkommen
    string sWillkommen = "Willkommen auf dem Neverwinter Nights Server Mintarn!\n\n" +
    "Wir sind ein deutscher Neverwinter Nights: Enhanced Edition Server mit Fokus auf Rollenspiel in einer detailreichen Spielwelt. Gemeinsam erwecken wir das unabhängige Inselkönigreich Mintarn im Westen Faerûns zum Leben!\n\n" +
    "Alle weiteren Informationen findet ihr auf unserer Homepage und in unserem Wiki auf http://mintarn.de.";
    sWillkommen = ColorStrings(sWillkommen, "*", "*", STRING_COLOR_ROSE);
    sWillkommen = ColorStrings(sWillkommen, "((", "))", "333");
    CreateMeta("willkommen", sWillkommen);
    object oBoard = GetObjectByTag("SIGN_Willkommen");
    SetDescription(oBoard, sWillkommen);
    // Regeln
    string sRegeln = "<c0z0>Regeln und Etikette</c>\n\n" +
    "Um ein angenehmes Miteinander zu ermöglichen, gibt es auf Mintarn Regeln und Etikette. Die Regeln sind unbedingt zu befolgen. Die Etikette bezieht sich auf das Rollenspiel und ist nicht verbindlich, aber dringend erwünscht zum harmonischen Miteinander. Zusätzlich gilt der gesunde Menschenverstand.\n\n" +
    "<c0z0>Regeln</c>\n\n" +
    "- Beleidigungen und Doxing sind nicht erlaubt.\n" +
    "- Beziehungsrollenspiel romantischer Natur ist prinzipiell erlaubt, allerdings sind alle expliziten Handlungen und Erotik-Inhalte nicht erwünscht und zu unterlassen.\n" +
    "- Rassismus (OOC) wird nicht toleriert.\n" +
    "- Bei Charakternamen, die nicht dem Fantasy-Setting entsprechen, behalten wir uns das Löschen des Charakters vor.\n" +
    "- Der Missbrauch von Bugs oder Enginemechaniken ist verboten. Bitte meldet Bugs im entsprechenden Kanal in Discord oder verwendet /report.\n" +
    "- PvP ist nur nach interaktivem Rollenspiel erlaubt. Es muss also nicht nur eine Rollenspielbegründung fuer PvP geben, sondern es muss vorher ausführlich eine Begründung erspielt werden. Unter PvP fallen nicht nur Kampfaktionen, sondern auch andere Handlungen wie zum Beispiel Taschendiebstahl oder Fallen stellen. Vor Beginn des PvPs sollte jedem Beteiligten die Möglichkeit gegeben werden der Situation zu entgehen.\n" +
    "- Alle Spielcharaktere sollten volljährig sein. Dies entspricht bei Menschen einem Alter von 18 Jahren. Bei Orks 15, bei Elfen 40, etc.. Jüngere Charaktere dürfen in Ausnahmefällen und nur mit dem Einverstaendnis der Spielleitung gespielt wird.\n\n" +
    "<c0z0>Etikette</c>\n\n" +
    "- OOC Informationen, also Informationen die euer Charakter nicht weiß, dürfen auch nicht im Rollenspiel verwendet werden (hierzu zählt auch Wissensaustausch zwischen euren eigenen Charakteren).\n" +
    "- Jeder Spieler sollte sich auf einen Charakter pro Plot beschränken, um Login-Hopping zu vermeiden, falls beide Charaktere gleichzeitig für den Spielbetrieb nötig sind.\n" +
    "- Gewaltdarstellungen werden geduldet, sofern sie pietätvoll und nicht exzessiv sind und keine anderen Spieler stören(!).\n" +
    "- OOC Texte beginnen mit // oder werden in (( )) Klammern geschrieben und sind nur geduldet, solange sie keine anderen Spieler stören.\n" +
    "- Emotete Spielhandlungen sollten dem Gegenüber Freiraum zur Reaktion lassen. Die Aktion *klaut jemandem den Giftbeutel* nimmt dem Gegenüber die Entscheidungsfähigkeit und grenzt aus. Stattdessen wäre *versucht jemandem den Giftbeutel zu klauen* sympathischer, da dem Mitspieler die Möglichkeit gegeben wird zu reagieren, indem er es geschehen lässt oder verhindert.\n";


    CreateMeta("regeln", sRegeln);
    oBoard = GetObjectByTag("SIGN_Regeln");
    SetDescription(oBoard, sRegeln);
    // Team
    string sTeam = "<c0z0>Mintarn - Ein Modul zum mitmachen</c>\n\n" +
    "Mit Mintarn möchten wir euch einen Rollenspiel Server bieten, auf den ihr gerne kommt um RP Abende zu verbringen, euren Charakter auszuleben oder einfach Monster zu kloppen. " +
    "Aber auch das so genannte World Building mit dem Modulbau, dem Erstellen von Gebieten, dem Skripten, dem Erfinden von Geschichten und Hintergründen kann sehr viel Spass machen!\n\n" +
    "Hiermit möchten wir euch herzlich einladen euch zu beteiligen und euch in dieser Welt einzubringen. Anteil nehmen und mitarbeiten ist ausdrücklich erlaubt und erwünscht!\n\n" +
    "Bei Interesse meldet einfach im Discord an, dass ihr gerne mithelfen wollt und ihr bekommt eine entsprechende Rolle zugewiesen, mit der weitere Channels freigeschaltet werden.";
    CreateMeta("team", sTeam);
    oBoard = GetObjectByTag("SIGN_Team");
    SetDescription(oBoard, sTeam);
    // Description Anleitung
    CreateMeta("description", "Öffnet http://mintarn.de/character.php und gebt folgenden Token ein: ");

    // News Eintraege
    sQuery = "DROP TABLE News";
    NWNX_SQL_ExecuteQuery(sQuery);
    sQuery = "CREATE TABLE IF NOT EXISTS News (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "text TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);
    // 1. Erstelle neuen sNewsxxxx string
    string sNews0001 = "<c0z0>Emotes, Wuerfeln und Aussehen</c>\n\n" +
    "Emotes, Wuerfeln und Aussehen editieren ist nun ueber /emote, /attribut, /skill, /aussehen moeglich. " +
    "Tippe /hilfe fuer eine Liste der Befehle.";
    string sNews0002 ="<c0z0>Patch 1.80</c>\n\n" +
    "Beamdog veroeffentlicht ein Update von NWN EE auf Version 1.80. " +
    "Unsere Server sind auf die neueste Version umgezogen.";
    string sNews0003 ="<c0z0>OOC und Intro</c>\n\n" +
    "Im OOC Gebiet koennt ihr eure Charakterbeschreibung und euer Aussehen aendern. " +
    "Zusaetzlich gibt es hier ein Geschaeft, in welchem ihr die Minimalausruestung kaufen koennt. " +
    "Alle weiteren Gegenstaende erhaltet ihr ueber das Crafting";
    string sNews0004 ="<c0z0>Rastsystem</c>\n\n" +
    "Es gibt nun ein Rastsystem. Ihr koennt nur Rasten wenn ihr Nahrung im Inventar " +
    "habt und zwischen eurer letzten Rast eine bestimmte Zeitspanne liegt.";
    string sNews0005 ="<c0z0>Sterben</c>\n\n" +
    "Sterben befoerdert euch nun ins Jenseits. Vielleicht hilft /beten um die " +
    "Aufmerksamkeit eines Gottes auf euch zu lenken?";
    string sNews0006 ="<c0z0>Freihafen</c>\n\n" +
    "Die Stadt Freihafen ist jetzt im Modul zu finden.";
    string sNews0007 ="<c0z0>Reiten</c>\n\n" +
    "Sofern ihr den Reitskill habt koennt ihr mit /pferd 1 bis /pferd 4 ein Reitpferd fuer Rollenspielzwecke erzeugen. " +
    "Tippt /pferd ein um wieder abzusteigen.";
    string sNews0008 ="<c0z0>Westmark</c>\n\n" +
    "Das Gebiet Westmark ist nun im Modul zu finden.\n";
    string sNews0009 ="<c0z0>Stadtwache</c>\n\n" +
    "Die Stadtwache ist nun im Modul zu finden.\n";
    string sNews0010 = "<c0z0>Charakter loeschen</c>\n\n" +
    "Ihr koennt nun euren Charakter mit dem Befehl /delete endgueltig loeschen.\n";

    // 2. CreateNews mit dem neuen sNewsxxxx
    CreateNews(sNews0001);
    CreateNews(sNews0002);
    CreateNews(sNews0003);
    CreateNews(sNews0004);
    CreateNews(sNews0005);
    CreateNews(sNews0006);
    CreateNews(sNews0007);
    CreateNews(sNews0008);
    CreateNews(sNews0009);
    CreateNews(sNews0010);
    oBoard = GetObjectByTag("SIGN_News");

    // 3. Fuege sNewsxxxx an den Anfang der Description mit zwei \n\n hinzu
    SetDescription(oBoard,
    sNews0010 + "\n\n" +
    sNews0009 + "\n\n" +
    sNews0008 + "\n\n" +
    sNews0007 + "\n\n" +
    sNews0006 + "\n\n" +
    sNews0005 + "\n\n" +
    sNews0004 + "\n\n" +
    sNews0003 + "\n\n" +
    sNews0002 + "\n\n" +
    sNews0001);

    // Create CD Key table
    sQuery = "CREATE TABLE IF NOT EXISTS CDkey (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "cdkey TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Create Users table if not exist
    sQuery = "CREATE TABLE IF NOT EXISTS Users (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "facing TEXT, " +
        "posx TEXT, " +
        "posy TEXT, " +
        "posz TEXT, " +
        "area TEXT, " +
        "gold INT, " +
        "level1 INT, " +
        "level2 INT, " +
        "level3 INT, " +
        "gender INT, " +
        "race int, " +
        "description TEXT, " +
        "portrait TEXT, " +
        "class1 INT, " +
        "class2 INT, " +
        "class3 INT, " +
        "alignment1 INT, " +
        "alignment2 INT, " +
        "token TEXT, " +
        "rest TEXT, " +
        "god TEXT, " +
        "health INT, " +
        "maxhealth INT, " +
        "house INT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Ressourcen
    sQuery = "CREATE TABLE IF NOT EXISTS Ressources (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "area TEXT, " +
        "posx TEXT, " +
        "posy TEXT, " +
        "posz TEXT, " +
        "facing TEXT, " +
        "tier TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Encounter
    sQuery = "CREATE TABLE IF NOT EXISTS Encounter (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "area TEXT, " +
        "posx TEXT, " +
        "posy TEXT, " +
        "posz TEXT, " +
        "facing TEXT, " +
        "type TEXT, " +
        "chance TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Chests
    sQuery = "CREATE TABLE IF NOT EXISTS Chests (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "area TEXT, " +
        "posx TEXT, " +
        "posy TEXT, " +
        "posz TEXT, " +
        "facing TEXT, " +
        "tier TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Chat
    sQuery = "CREATE TABLE IF NOT EXISTS Chat (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "text TEXT, " +
        "datetime TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);


    // Furniture
    sQuery = "CREATE TABLE IF NOT EXISTS Furniture (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "area TEXT, " +
        "posx TEXT, " +
        "posy TEXT, " +
        "posz TEXT, " +
        "facing TEXT, " +
        "type TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Create Quest Status Table
    sQuery = "CREATE TABLE IF NOT EXISTS QuestStatus (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "quest TEXT, " +
        "stage TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Create Database entry for Backgrounds
    sQuery = "CREATE TABLE IF NOT EXISTS Backgrounds (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "title TEXT, " +
        "text TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // XP penalty
    sQuery = "CREATE TABLE IF NOT EXISTS Experience (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "experience TEXT, " +
        "datetime TEXT, " +
        "type TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Crafting
    sQuery = "CREATE TABLE IF NOT EXISTS Crafting (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "item TEXT, " +
        "datetime TEXT, " +
        "profession TEXT, " +
        "xp TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Familiars and Companions
    sQuery = "CREATE TABLE IF NOT EXISTS Pets (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "type TEXT, " +
        "health TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Downtime activities
    sQuery = "CREATE TABLE IF NOT EXISTS Downtime (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "datetime TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Tribut
    sQuery = "CREATE TABLE IF NOT EXISTS Tribut (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "gold TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // DM actions
    sQuery = "CREATE TABLE IF NOT EXISTS DMactions (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "name TEXT, " +
        "charname TEXT, " +
        "action TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);

    // Server date and time
    sQuery = "CREATE TABLE IF NOT EXISTS Calendar (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "year TEXT, " +
        "month TEXT, " +
        "day TEXT, " +
        "hour TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);
    sQuery = "SELECT * FROM Calendar";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_ExecutePreparedQuery();

        string sId;
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            sId = NWNX_SQL_ReadDataInActiveRow(0);
        }
        if (StringToInt(sId) < 1) {
            string sQuery = "INSERT INTO Calendar (year, month, day, hour) VALUES (?, ?, ?, ?)";
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, "1490");
                NWNX_SQL_PreparedString(1, "1");
                NWNX_SQL_PreparedString(2, "1");
                NWNX_SQL_ExecutePreparedQuery();
            }
        }
        SetCalendar(StringToInt(NWNX_SQL_ReadDataInActiveRow(1)), StringToInt(NWNX_SQL_ReadDataInActiveRow(2)), StringToInt(NWNX_SQL_ReadDataInActiveRow(3)));
        SetTime(StringToInt(NWNX_SQL_ReadDataInActiveRow(4)), 0, 0, 0);
    }


    // Farben fuer Conversationen
    SetCustomTokenEx(100, "</c>");
    SetCustomTokenEx(101, "<cþf >"); //Ã™Â§
    SetCustomTokenEx(102, "<cuuu>");
    SetCustomTokenEx(103, "<cvvv>");
    SetCustomTokenEx(104, "<cL‹ÿ>"); // Blue
    SetCustomTokenEx(105, "<cÿÓ'>"); // Gold
    SetCustomTokenEx(106, "<c´$$>"); // Ruby

    // Fertigkeitsfokus-Talente
    struct NWNX_SkillRanks_SkillFeat skillFeat;

    skillFeat.iModifier = 3;
    skillFeat.iFocusFeat = 1;

    // Motiv erkennen
    skillFeat.iSkill = 28;
    skillFeat.iFeat = 1116;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Wissen: Natur
    skillFeat.iSkill = 29;
    skillFeat.iFeat = 1117;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Wissen: Religion
    skillFeat.iSkill = 30;
    skillFeat.iFeat = 1118;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Handwerk: Lederer
    skillFeat.iSkill = 31;
    skillFeat.iFeat = 1119;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Handwerk: Schmied
    skillFeat.iSkill = 9;
    skillFeat.iFeat = 1120;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Handwerk: Schreiner
    skillFeat.iSkill = 15;
    skillFeat.iFeat = 1121;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Handwerk: Alchemist
    skillFeat.iSkill = 33;
    skillFeat.iFeat = 1122;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Athletik
    skillFeat.iSkill = 34;
    skillFeat.iFeat = 1123;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Ãœberleben
    skillFeat.iSkill = 35;
    skillFeat.iFeat = 1124;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    //Multi-Fertigkeitstalente:

    //Silver Palm
    skillFeat.iModifier = 2;
    skillFeat.iFocusFeat = 1;
    skillFeat.iSkill = 12;
    skillFeat.iFeat = 1127;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = 14;
    skillFeat.iFeat = 1127;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    //Klassen-Fertigkeitstalente:

    //Naturgespuer
    skillFeat.iSkill = 29;
    skillFeat.iFeat = 1129;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = 35;
    skillFeat.iFeat = 1129;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    //struct NWNX_SkillRanks_SkillFeat debug_feat = NWNX_SkillRanks_GetSkillFeat(30, 1116);
    //WriteTimestampedLogEntry("Skill Feat: " + debug_feat.iSkill + " - " + debug_feat.iFeat + " - " + debug_feat.iModifier + " " + debug_feat.iFocusFeat);

    // Wetter
    ExecuteScript("weather", OBJECT_SELF);

    // Date and time
    ExecuteScript("calendar", OBJECT_SELF);

    // Alarm
    ExecuteScript("alarm", OBJECT_SELF);

    // webhook
    string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_MODULE");
    string branch = NWNX_Util_GetEnvironmentVariable("BRANCH");
    WriteTimestampedLogEntry("Webhook:" + webhook);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, "Das Modul wurde neu gestartet. (" + branch + ")", "Mintarn");

    // Events
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "e_elc");
    NWNX_Events_SubscribeEvent("NWNX_ON_TRAP_SET_BEFORE", "e_settrap");
    NWNX_Events_SubscribeEvent("NWNX_ON_TRAP_RECOVER_BEFORE", "e_rectrap");
    NWNX_Events_SubscribeEvent("NWNX_ON_TRAP_EXAMINE_BEFORE", "e_extrap");
    NWNX_Events_SubscribeEvent("NWNX_ON_TRAP_FLAG_BEFORE", "e_flagtrap");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_SKILL_BEFORE", "e_skill");
    NWNX_Events_SubscribeEvent("NWNX_ON_COMBAT_MODE_ON", "e_cmode");
    NWNX_Events_SubscribeEvent("NWNX_ON_REMOVE_ASSOCIATE_BEFORE", "e_assoc");

    NWNX_Events_SubscribeEvent("NWNX_ON_PVP_ATTITUDE_CHANGE_BEFORE", "e_pvp");

    //Kaikas' PVP System
    //NWNX_Events_SubscribeEvent("NWNX_ON_START_COMBAT_ROUND_BEFORE", "e_combatround");


    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_GOLD_AFTER", "e_dmgold");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_XP_AFTER", "e_dmxp");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_LEVEL_AFTER", "e_dmlevel");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_ALIGNMENT_AFTER", "e_dmalignme");

    NWNX_Events_SubscribeEvent("NWNX_ON_DM_PLAYERDM_LOGIN_BEFORE", "e_playerdm");

    NWNX_Events_SubscribeEvent("NWNX_ON_CAST_SPELL_BEFORE", "e_castspell");
    NWNX_Events_SubscribeEvent("NWNX_ON_CAST_SPELL_AFTER", "e_castspella");

    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_NUI_EVENT, "nui_events");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET, "nui_events_t");

    // Lighting
    int iDawn = 7;
    int iDusk = 17;
    CreateLightsAtWaypoints();
    ManipulateAllLightsWithTag("LIGHT_DAYTIME", 1);
    ManipulateAllLightsWithTag("LIGHT_NIGHTTIME", 0);
    ManipulateAllLightsWithTag("LIGHT_ALWAYS", 1);
    ManipulateAllLightsWithTag("LIGHT_Dauerlicht", 1);
    SetLocalString(GetModule(), "LIGHTS_TIME", "INIT");
    LightHeartbeat(iDawn, iDusk); // pseudo-heartbeat

}
