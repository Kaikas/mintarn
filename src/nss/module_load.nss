#include "x2_inc_switches"
#include "x2_inc_restsys"
#include "nwnx_sql"
#include "global_helper"
#include "nwnx_time"
#include "x3_inc_string"
#include "nwnx_webhook"
#include "nwnx_events"
#include "nwnx_skillranks"
#include "global_lighting"

// Erstellt metainformationen die auf der webseite und auf hinweisschildern stehen
void CreateMeta(string tag, string text) {
    string sQuery = "INSERT INTO Meta (tag, text) VALUES (?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, tag);
        NWNX_SQL_PreparedString(1, text);
        NWNX_SQL_ExecutePreparedQuery();
    }
}

// Erstellt news einträge auf der Webseite und auf dem Messageboard
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
   SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
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
    "Mintarn ist eine Insel im Meer der Schwerter westlich von Faerun. Gespielt wird in der Stadt Freihafen und der Umgebung im Jahr 1490 DR (es gilt die D&D 5e Geschichte). " +
    "Schwerpunkt des Servers ist zum einen Rollenspiel zum anderen natürlich das Moschen von Monstern und Erkunden von Dungeons. \n\n" +
    "Mintarn bietet euch ein Questsystem mit dem euch hoffentlich nie langweilig wird, ein handgemachtes Craftingsystem, welches " +
    "möglichst einfach aber allumfassend ist, ein eigenes KI System um eine möglichst lebendige Welt darzustellen und vieles mehr. \n\n" +
    "Mintarn ist ein Rollenspielserver. Bitte denkt euch einen Charakter aus den ihr möglichst gut darstellt. " +
    "Emotes werden in *Sternchen* geschrieben, Out Of Character (OOC) Informationen in (( doppelten Klammern )).\n\n" +
    "Gewürfelt wird mit /befehlen, zum Beispiel ein Wurf auf Stärke geht mit /stärke. Für eine Liste der Befehle gebt /hilfe ein.\n\n" +
    "Die Beschreibung eures Charakters könnt ihr auf der Webseite ändern. Dazu benötigt ihr euren einzigartigen Spielertoken den ihr mit /token bekommt.\n\n" +
    "Wir befinden uns derzeit in der Entwicklungsphase und suchen Dungeon Master und tatkräftige Unterstützung beim Erstellen von Gebieten. " +
    "Wer mitmachen will kommt am besten auf unser Discord (https://discord.gg/9vP7TPT) und schreibt Kaikas an.";
    sWillkommen = ColorStrings(sWillkommen, "*", "*", STRING_COLOR_ROSE);
    sWillkommen = ColorStrings(sWillkommen, "((", "))", "333");
    CreateMeta("willkommen", sWillkommen);
    object oBoard = GetObjectByTag("SIGN_Willkommen");
    SetDescription(oBoard, sWillkommen);
    // Regeln
    string sRegeln = "<c0z0>Regeln</c>\n\n" +
    "Es gelten die üblichen Regeln für gesittetes Rollenspiel [RP]. Also keine Out Of Character [OOC] Informationen verwenden, keine Dinge per RP erzwingen " +
    "auf die euer Gegenüber keinen Einfluss hat und kein Wissensaustausch unter eigenen Charakteren.\n\n" +
    "PvP ist nur erlaubt nach interaktivem Rollenspiel. Es muss also nicht nur eine Rollenspielbegründung für PvP geben, es muss vorher ausführlich eine Begründung erspielt werden. " +
    "Taschendiebstahl ist an jedem Spieler nur ein mal täglich (Echtzeit) erlaubt. Es muss vorher interaktives Rollenspiel geschehen sein.";
    CreateMeta("regeln", sRegeln);
    oBoard = GetObjectByTag("SIGN_Regeln");
    SetDescription(oBoard, sRegeln);
    // Team
    string sTeam = "<c0z0>Team</c>\n\n" +
    "Kaikas: Weltenbau, Scripts, SL \n" +
    "Sonnenfeuer: Weltenbau, Lore\n" +
    "enikross: Weltenbau\n" +
    "Mira: Weltenbau\n" +
    "Victorious: Scripts\n" +
    "zankstelle: Items, Orks\n" +
    "Helfer gesucht! Meldet euch wenn ihr etwas zu dem Projekt beisteuern wollt.";
    CreateMeta("team", sTeam);
    oBoard = GetObjectByTag("SIGN_Team");
    SetDescription(oBoard, sTeam);
    // Description Anleitung
    CreateMeta("description", "Öffnet http://mintarn.de/character.php und gebt folgenden Token ein: ");

    // News Einträge
    sQuery = "DROP TABLE News";
    NWNX_SQL_ExecuteQuery(sQuery);
    sQuery = "CREATE TABLE IF NOT EXISTS News (" +
        "id MEDIUMINT NOT NULL AUTO_INCREMENT, " +
        "text TEXT, " +
        "PRIMARY KEY (id))";
    NWNX_SQL_ExecuteQuery(sQuery);
    // 1. Erstelle neuen sNewsxxxx string
    string sNews0001 = "<c0z0>Emotes, Würfeln und Aussehen</c>\n\n" +
    "Emotes, Würfeln und Aussehen editieren ist nun über /emote, /attribut, /skill, /aussehen möglich. " +
    "Tippe /hilfe für eine Liste der Befehle.";
    string sNews0002 ="<c0z0>Patch 1.80</c>\n\n" +
    "Beamdog veröffentlicht ein Update von NWN EE auf Version 1.80. " +
    "Unsere Server sind auf die neueste Version umgezogen.";
    string sNews0003 ="<c0z0>OOC und Intro</c>\n\n" +
    "Im OOC Gebiet könnt ihr eure Charakterbeschreibung und euer Aussehen ändern. " +
    "Zusätzlich gibt es hier ein Geschäft, in welchem ihr die Minimalausrüstung kaufen könnt. " +
    "Alle weiteren Gegenstände erhaltet ihr über das Crafting";
    string sNews0004 ="<c0z0>Rastsystem</c>\n\n" +
    "Es gibt nun ein Rastsystem. Ihr könnt nur Rasten wenn ihr Nahrung im Inventar " +
    "habt und zwischen eurer letzten Rast eine bestimmte Zeitspanne liegt.";
    string sNews0005 ="<c0z0>Sterben</c>\n\n" +
    "Sterben befördert euch nun ins Jenseits. Vielleicht hilft /beten um die " +
    "Aufmerksamkeit eines Gottes auf euch zu lenken?";
    string sNews0006 ="<c0z0>Freihafen</c>\n\n" +
    "Die Stadt Freihafen ist jetzt im Modul zu finden.";
    string sNews0007 ="<c0z0>Reiten</c>\n\n" +
    "Sofern ihr den Reitskill habt könnt ihr mit /pferd 1 bis /pferd 4 ein Reitpferd für Rollenspielzwecke erzeugen. " +
    "Tippt /pferd ein um wieder abzusteigen.";
    string sNews0008 ="<c0z0>Westmark</c>\n\n" +
    "Das Gebiet Westmark ist nun im Modul zu finden.\n";
    string sNews0009 ="<c0z0>Stadtwache</c>\n\n" +
    "Die Stadtwache ist nun im Modul zu finden.\n";
    string sNews0010 = "<c0z0>Charakter löschen</c>\n\n" +
    "Ihr könnt nun euren Charakter mit dem Befehl /delete endgültig löschen.\n";

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

    // 3. Füge sNewsxxxx an den Anfang der Description mit zwei \n\n hinzu
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


    // Farben für Conversationen
    SetCustomToken(100, "</c>");
    SetCustomToken(101, "<cÙ§`>");
    SetCustomToken(102, "<cuuu>");

    // Fertigkeits-Talente
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
    skillFeat.iSkill = 32;
    skillFeat.iFeat = 1120;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Handwerk: Schreiner
    skillFeat.iSkill = 33;
    skillFeat.iFeat = 1121;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Handwerk: Alchemist
    skillFeat.iSkill = 34;
    skillFeat.iFeat = 1122;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Athletik
    skillFeat.iSkill = 35;
    skillFeat.iFeat = 1123;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Überleben
    skillFeat.iSkill = 36;
    skillFeat.iFeat = 1124;
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
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "global_elc");
    NWNX_Events_SubscribeEvent("NWNX_ON_TRAP_SET_BEFORE", "global_settrap");
    NWNX_Events_SubscribeEvent("NWNX_ON_TRAP_RECOVER_BEFORE", "global_rectrap");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_SKILL_BEFORE", "global_skill");
    NWNX_Events_SubscribeEvent("NWNX_ON_COMBAT_MODE_ON", "global_cmode");

    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_GOLD_AFTER", "global_dmgold");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_XP_AFTER", "global_dmxp");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_LEVEL_AFTER", "global_dmlevel");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_ALIGNMENT_AFTER", "global_dmalignme");

    // Lighting 
    ReplaceLightWaypoints(); 
    ToggleAllLightsWithTag("LIGHT_DAYTIME");
    ToggleAllLightsWithTag("LIGHT_NIGHTTIME");
    ToggleAllLightsWithTag("LIGHT_ALWAYS");
    ToggleDayNightLighting(); // pseudo-heartbeat

}
