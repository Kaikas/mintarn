#include "global_helper"
#include "nwnx_sql"
#include "nwnx_time"
#include "nwnx_admin"
#include "global_smoke"
#include "x3_inc_horse"
#include "nwnx_chat"
#include "x0_i0_position"
#include "nwnx_webhook"

// CUSTOM SKILL CONSTANTS
// Some constants are predefined in nwscripts.nss
const int SKILL_ANIMAL_HANDLING = 0;
// const int SKILL_CONCENTRATION = 1;
// const int SKILL_HEAL = 4;
// const int SKILL_HIDE = 5;
// const int SKILL_LISTEN = 6;
const int SKILL_KNOW_LORE = 7;
// const int SKILL_MOVE_SILENTLY = 8;
const int SKILL_DISABLE_DEVICE = 9;
// const int SKILL_PERFORM = 11;
// const int SKILL_PERSUADE = 12;
const int SKILL_SLEIGHT_OF_HAND = 13;
// int SKILL_SEARCH = 14;
const int SKILL_KNOW_ARCANA = 16;
// int SKILL_SPOT = 17;
// int SKILL_USE_MAGIC_DEVICE = 19;
const int SKILL_ACROBATICS = 21;
const int SKILL_DECEPTION = 23;
// int SKILL_INTIMIDATE = 24;
const int SKILL_SENSE_MOTIVE = 28;
const int SKILL_KNOW_NATURE = 29;
const int SKILL_KNOW_RELIGION = 30;
const int SKILL_CRAFT_LEATHERER = 31;
const int SKILL_CRAFT_SMITH = 32;
const int SKILL_CRAFT_CARPENTER = 33;
const int SKILL_CRAFT_ALCHEMIST = 34;
const int SKILL_ATHLETICS = 35;
const int SKILL_SURVIVAL = 36;

// Setzt einen Würfel wurf zusammen
string PrintRoll(string sValue, int iRand, int iBonus) {
    return StringToRGBString("[" +
        sValue +
        ": " +
        IntToString(iRand) +
        " + (" +
        IntToString(iBonus) +
        ") = " +
        IntToString(iRand + iBonus) +
        "]", "333");
}

// Setzt einen Würfel wurf für einen skill zusammen
string PrintRollSkill(string sValue, int iRand, int iBonus, int iAbilityBonus) {
    return StringToRGBString("[" +
        sValue +
        ": " +
        IntToString(iRand) +
        " + (" +
        IntToString(iAbilityBonus) +
        " + " +
        IntToString(iBonus) +
        ") = " +
        IntToString(iRand + iAbilityBonus + iBonus) +
        "]", "333");
}

void RollSkillCheck(string sOutput, int iSkill, int iCheckAbility, int iKeyAbility, int iChatVolume, object oPc) {
    int iRand = Random(20) + 1;
    int iBonus = GetSkillRank(iSkill, oPc);
    int iAbilityBonus = GetAbilityModifier(iCheckAbility, oPc);
    string sMessage = PrintRollSkill(sOutput, iRand, iBonus - GetAbilityModifier(iKeyAbility, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
}

// Applies or removes a mask
void applyMask(object oPc, int iVFX) {
    if (GetLocalInt(oPc, "maske") == 1) {
        SetLocalInt(oPc, "maske", 0);
        effect eEffect = GetFirstEffect(oPc);
        while(GetIsEffectValid(eEffect)) {
            if(GetEffectTag(eEffect) == "eff_maske") {
                RemoveEffect(oPc, eEffect);
            }
            eEffect = GetNextEffect(oPc);
        }
    } else {
        SetLocalInt(oPc, "maske", 1);
        int iIncBy = 0;
        int iRace = GetRacialType(oPc);
        int iGender = GetGender(oPc);
        int iPheno = GetPhenoType(oPc);
        string sGender = "Male";
        string sRace;
        switch(iRace) {
            case RACIAL_TYPE_DWARF: iIncBy = 2; sRace = "Dwarf"; break;
            case RACIAL_TYPE_ELF: iIncBy = 4; sRace = "Elf"; break;
            case RACIAL_TYPE_GNOME: iIncBy = 6; sRace = "Gnome"; break;
            case RACIAL_TYPE_HALFLING: iIncBy = 8; sRace = "Halfling"; break;
            case RACIAL_TYPE_HALFORC: iIncBy = 10; sRace = "Halforc"; break;
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_HUMAN:  break;
        }
        if (iGender == GENDER_FEMALE) {
            iIncBy++;
            sGender = "Female";
        }
        int iVFXNumber = iVFX + iIncBy;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectVisualEffect(iVFXNumber), "eff_maske"), oPc);
    }
}

// Chat befehle
void main() {
    int iChatVolume = GetPCChatVolume();
    object oPc = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    string sQuery;
    string sFirstChar = GetSubString(sMessage, 0, 1);
    string sSecondChar = GetSubString(sMessage, 1, 1);
    string sBan = GetSubString(sMessage, 0, 4);
    string sUnban = GetSubString(sMessage, 0, 6);
    string sPferd= GetSubString(sMessage, 0, 4);
    int iRand = Random(20) + 1;
    int iBonus;
    int iAbilityBonus;


    // DM speak as char
    if (sFirstChar == ":") {
        object oTarget1 = GetLocalObject(oPc, "dmspeak1");
        object oTarget2 = GetLocalObject(oPc, "dmspeak2");
        object oTarget3 = GetLocalObject(oPc, "dmspeak3");
        object oTarget4 = GetLocalObject(oPc, "dmspeak4");
        object oTarget5 = GetLocalObject(oPc, "dmspeak5");
        sMessage = GetSubString(sMessage, 2, 10000);

        if (oTarget1 != OBJECT_INVALID && sSecondChar == "1" && !GetIsPC(oTarget1) || GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            //AssignCommand(oTarget1, ActionSpeakString(sMessage, iChatVolume));
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            SetLocalString(oTarget1, "sMessage", sMessage);
            SetLocalInt(oTarget1, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oTarget1);
        }
        if (oTarget2 != OBJECT_INVALID && sSecondChar == "2" && !GetIsPC(oTarget2) || GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            //AssignCommand(oTarget2, ActionSpeakString(sMessage, iChatVolume));
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            SetLocalString(oTarget2, "sMessage", sMessage);
            SetLocalInt(oTarget2, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oTarget2);
        }
        if (oTarget3 != OBJECT_INVALID && sSecondChar == "3" && !GetIsPC(oTarget3) || GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            //AssignCommand(oTarget3, ActionSpeakString(sMessage, iChatVolume));
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            SetLocalString(oTarget3, "sMessage", sMessage);
            SetLocalInt(oTarget3, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oTarget3);
        }
        if (oTarget4 != OBJECT_INVALID && sSecondChar == "4" && !GetIsPC(oTarget4) || GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            //AssignCommand(oTarget4, ActionSpeakString(sMessage, iChatVolume));
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            SetLocalString(oTarget4, "sMessage", sMessage);
            SetLocalInt(oTarget4, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oTarget4);
        }
        if (oTarget5 != OBJECT_INVALID && sSecondChar == "5" && !GetIsPC(oTarget5) || GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            //AssignCommand(oTarget5, ActionSpeakString(sMessage, iChatVolume));
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            SetLocalString(oTarget5, "sMessage", sMessage);
            SetLocalInt(oTarget5, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oTarget5);
        }
    } else if (sFirstChar == "/") {
        // // ooc chat
        if (sSecondChar == "/") {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            sMessage = StringToRGBString(sMessage, "333");
            //AssignCommand(oPc, ActionSpeakString(sMessage));
            SetLocalString(oPc, "sMessage", sMessage);
            SetLocalInt(oPc, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oPc);
        // Ban player
        } else if (sBan == "/ban" && GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            string sBanPlayer = GetSubString(sMessage, 5, 1000);
            NWNX_Administration_AddBannedCDKey(sBanPlayer);
            SendMessageToPC(oPc, sBanPlayer + " banned!");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), GetPCPlayerName(oPc) + " hat " + sBanPlayer + " gebannt!" , "Mintarn");
        // unban player
        } else if (sUnban == "/unban" && GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            string sBanPlayer = GetSubString(sMessage, 7, 1000);
            NWNX_Administration_RemoveBannedCDKey(sBanPlayer);
            SendMessageToPC(oPc, sBanPlayer + " unbanned!");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), GetPCPlayerName(oPc) + " hat " + sBanPlayer + " entbannt!" , "Mintarn");
        // List cdkeys
        } else if (sMessage == "/cdkeys" && GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            object oPlayer = GetFirstPC();
            while (GetIsObjectValid(oPlayer) == TRUE) {
                SendMessageToPC(oPc, GetPCPlayerName(oPlayer) + " (" + GetName(oPlayer) + "): " + GetPCPublicCDKey(oPlayer));
                oPlayer = GetNextPC();
            }
            SendMessageToPC(oPc, NWNX_Administration_GetBannedList());
        // Change name
        } else if (GetSubString(sMessage, 0, 11) == "/changename") {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            object oTarget = GetLocalObject(oPc, "changename");
            if (oTarget != OBJECT_INVALID) {
                SetName(oTarget, GetSubString(sMessage, 11, 1000));
            }
        // Reiten
        } else if (sUnban == "/pferd") {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            if (HorseGetIsMounted(oPc)) {
                HorseInstantDismount(oPc);
            } else {
                //if (GetSkillRank(SKILL_RIDE, oPc) > 0) {
                string sHorse = GetSubString(sMessage, 7, 7);
                if (sHorse == "1" || sHorse == "2" || sHorse == "3" || sHorse == "4") {
                    object oHorse = GetObjectByTag("HORSE_" + sHorse);
                    HorseInstantMount(oPc, HorseGetMountTail(oHorse));
                }
                    //} else {
                //    SendMessageToPC(oPc, "Eure Reitfähigkeit ist nicht hoch genug.");
                //}
            }
        // Shutdown
        } else if (sMessage == "/shutdown" && GetIsDM(oPc)) {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            object oPlayer = GetFirstPC();
            while (GetIsObjectValid(oPlayer) == TRUE) {
                if (oPlayer != oPc) {
                    BootPC(oPlayer);
                }
                oPlayer = GetNextPC();
            }
            NWNX_Administration_ShutdownServer();
        // Unstuck
        } else if (sMessage == "/unstuck") {
            vector vCurrentLocation = GetPosition(oPc);
            string sLogMessage = GetName(oPc)+" steckt in "+GetName(GetArea(oPc))+" ("+FloatToString(vCurrentLocation.x,6,2)+", "+FloatToString(vCurrentLocation.y,6,2)+", "+FloatToString(vCurrentLocation.z,6,2)+") fest.";
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), sLogMessage, "Mintarn");
            AssignCommand(oPc, JumpToLocation(GetAheadLocation(oPc)));
        // Report
        } else if (GetSubString(sMessage, 0, 7) == "/report" || GetSubString(sMessage, 0, 7) == "/melden") {
            vector vCurrentLocation = GetPosition(oPc);
            string sLogMessage = GetPCPlayerName(oPc) +
              " (" +
              GetName(oPc) +
              ") meldet in " +
              GetName(GetArea(oPc)) +
              " (" +
              FloatToString(vCurrentLocation.x,6,2) +
              ", " +
              FloatToString(vCurrentLocation.y,6,2) +
              ", " +
              FloatToString(vCurrentLocation.z,6,2) +
              "): " +
              GetSubString(sMessage, 7, 300);
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_FEHLER"), sLogMessage, "Mintarn", 0);
        // Delete Characters
        } else if (GetSubString(sMessage, 0, 8) == "/delete ") {
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            sQuery = "SELECT token FROM Users WHERE name=? AND charname=?";
            string sAccountName = GetPCPlayerName(oPc);
            string sName = GetName(oPc);
            if (NWNX_SQL_PrepareQuery(sQuery)) {
                NWNX_SQL_PreparedString(0, sAccountName);
                NWNX_SQL_PreparedString(1, sName);
                NWNX_SQL_ExecutePreparedQuery();
                NWNX_SQL_ReadNextRow();
                SendMessageToPC(oPc, GetSubString(sMessage, 9, 16));
                if (GetSubString(sMessage, 8, 16) == NWNX_SQL_ReadDataInActiveRow(0)) {
                    sQuery = "DELETE FROM Users WHERE name=? AND charname=?";
                    if (NWNX_SQL_PrepareQuery(sQuery)) {
                        NWNX_SQL_PreparedString(0, sAccountName);
                        NWNX_SQL_PreparedString(1, sName);
                        NWNX_SQL_ExecutePreparedQuery();
                        sQuery = "DELETE FROM QuestStatus WHERE name=? AND charname=?";
                        if (NWNX_SQL_PrepareQuery(sQuery)) {
                            NWNX_SQL_PreparedString(0, sAccountName);
                            NWNX_SQL_PreparedString(1, sName);
                            NWNX_SQL_ExecutePreparedQuery();
                        }
                        sQuery = "DELETE FROM Experience WHERE name=? AND charname=?";
                        if (NWNX_SQL_PrepareQuery(sQuery)) {
                            NWNX_SQL_PreparedString(0, sAccountName);
                            NWNX_SQL_PreparedString(1, sName);
                            NWNX_SQL_ExecutePreparedQuery();
                        }
                        sQuery = "DELETE FROM Crafting WHERE name=? AND charname=?";
                        if (NWNX_SQL_PrepareQuery(sQuery)) {
                            NWNX_SQL_PreparedString(0, sAccountName);
                            NWNX_SQL_PreparedString(1, sName);
                            NWNX_SQL_ExecutePreparedQuery();
                        }
                        NWNX_Administration_DeletePlayerCharacter(oPc);
                    }
                }
            }
        } else {
            // Slash commands
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            // Emotes
            if (sMessage == "/sit" || sMessage == "/sitzen") {
                AssignCommand( oPc, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 60000.0));
            } else if (sMessage == "/dance" || sMessage == "/tanzen") {
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
                AssignCommand(oPc,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPc)));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 2.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY1,1.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY3,2.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 3.0, 1.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_LOOPING_TALK_FORCEFUL,1.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
                AssignCommand(oPc,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPc)));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 2.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY1,1.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY3,2.0));
                AssignCommand(oPc,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPc)));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 3.0, 1.0));
                AssignCommand(oPc,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
            } else if (sMessage == "/worship" || sMessage == "/anbeten") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 60000.0));
            } else if (sMessage == "/bow" || sMessage == "/verbeugen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 1.0));
            } else if (sMessage == "/dodge" || sMessage == "/ausweichen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE, 1.0));
            } else if (sMessage == "/duck" || sMessage == "/ducken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 1.0));
            } else if (sMessage == "/drink" || sMessage == "/trinken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0));
            } else if (sMessage == "/greet" || sMessage == "/winken" || sMessage == "/grüÃŸen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING, 1.0));
            } else if (sMessage == "/bored" || sMessage == "/strecken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0));
            } else if (sMessage == "/scratch" || sMessage == "/kratzen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
            } else if (sMessage == "/read" || sMessage == "/lesen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_READ, 1.0, 60000.0));
            } else if (sMessage == "/salute" || sMessage == "/salutieren") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE, 1.0));
            } else if (sMessage == "/spasm" || sMessage == "/zucken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 1.0));
            } else if (sMessage == "/steal" || sMessage == "/stehlen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL, 1.0));
            } else if (sMessage == "/taunt" || sMessage == "/provozieren" || sMessage == "/herausfordern") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0));
            } else if (sMessage == "/victory" || sMessage == "/feiern") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
            } else if (sMessage == "/victory1" || sMessage == "/jubeln" || sMessage == "/freuen1") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
            } else if (sMessage == "/victory2" || sMessage == "/freuen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
            } else if (sMessage == "/cheer" || sMessage == "/anfeuern") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
            } else if (sMessage == "/conjure" || sMessage == "/zaubern" || sMessage == "/zaubern1") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 60000.0));
            } else if (sMessage == "/conjure2" || sMessage == "/zaubern2") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 60000.0));
            } else if (sMessage == "/lieback" || sMessage == "/liegen rücken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 60000.0));
            } else if (sMessage == "/feigndeath" || sMessage == "/liegen bauch") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 60000.0));
            } else if (sMessage == "/lift" || sMessage == "/aufheben") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 60000.0));
            } else if (sMessage == "/grab" || sMessage == "/interagieren") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 60000.0));
            } else if (sMessage == "/listen" || sMessage == "/nicken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, 60000.0));
            } else if (sMessage == "/look" || sMessage == "/spähen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 60000.0));
            } else if (sMessage == "/drunk" || sMessage == "/schwanken") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 60000.0));
            } else if (sMessage == "/shout" || sMessage == "/schimpfen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 60000.0));
            } else if (sMessage == "/laugh" || sMessage == "/lachen") {
                AssignCommand(oPc,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPc)));
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 60000.0));
            } else if (sMessage == "/plead" || sMessage == "/flehen") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 60000.0));
            } else if (sMessage == "/talk" || sMessage == "/reden") {
                AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL, 1.0, 60000.0));
            } else if (sMessage == "/smoke" || sMessage == "/rauchen") {
                SmokePipe(oPc);
            } else if (sMessage == "/pray" || sMessage == "/beten") {
                if (GetTag(GetArea(oPc)) == "AREA_Nether") {
                    location lTempel = GetLocation(GetObjectByTag("WP_TEMPEL"));
                    AssignCommand(oPc, JumpToLocation(lTempel));
                    string sMessage = "Nach der Reinigung eurer Wunden hat man euch im 'Saal der Klagenden' der Selbstreflektion überlassen; auf dass euer Weg kein weiteres mal hierher führen mÃ¶ge.";
                    SendMessageToPC(oPc, sMessage);
                    // Health
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPc)), oPc);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oPc) - 1), oPc);
                    // Negative Level
                    if (GetLevelByPosition(0, oPc) + GetLevelByPosition(1, oPc) + GetLevelByPosition(2, oPc) > 1) {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(1), oPc, 600.0f);
                    }
                    // Apply Speed debuff again after dying
                    // Fackel
                    if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) == "CRAFT_Fackel" || GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)) == "CRAFT_Fackel") {
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_15), oPc);
                    }
                    // Rüstung
                    if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_CHEST)) == BASE_ITEM_ARMOR){
                        // copied from: https://nwnlexicon.com/index.php?title=GetItemACValue
                        // Get the appearance of the torso slot
                        int nAppearance = GetItemAppearance(GetItemInSlot(INVENTORY_SLOT_CHEST), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
                        // Look up in parts_chest.2da the relevant line, which links to the actual AC bonus of the armor
                        // We cast it to int, even though the column is technically a float.
                        int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
                        // Return the given AC value (0 to 8)
                        //End Copy

                        if(nAC == 4 || nAC == 5) {
                            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectMovementSpeedDecrease(5)), "eff_armorslow"), oPc);
                        } else if (nAC > 5) {
                            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectMovementSpeedDecrease(10)), "eff_armorslow"), oPc);
                        }
                    }
                    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 60000.0));
                } else {
                    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 60000.0));
                }
            // Aussehen
            } else if (sMessage == "/aussehen" || sMessage == "/appearance") {
                AssignCommand(oPc, ActionStartConversation(oPc, "aussehen", TRUE));
            } else if (sMessage == "/aussehen_all" || sMessage == "/appearance_all") {
                AssignCommand(oPc, ActionStartConversation(oPc, "aussehen_orig", TRUE));
            // Attribute
            } else if (sMessage == "/charisma" || sMessage == "/cha") {
                iBonus = GetAbilityModifier(ABILITY_CHARISMA, oPc);
                sMessage = PrintRoll("Charisma", iRand, iBonus);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/constitution" || sMessage == "/konstitution" || sMessage == "/kon" || sMessage == "/con") {
                iBonus = GetAbilityModifier(ABILITY_CONSTITUTION, oPc);
                sMessage = PrintRoll("Konstitution", iRand, iBonus);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/dexterity" || sMessage == "/geschicklichkeit" || sMessage == "/ges" || sMessage == "/dex") {
                iBonus = GetAbilityModifier(ABILITY_DEXTERITY, oPc);
                sMessage = PrintRoll("Geschicklichkeit", iRand, iBonus);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/intelligence" || sMessage == "/intelligenz" || sMessage == "/int") {
                iBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPc);
                sMessage = PrintRoll("Intelligenz", iRand, iBonus);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/strength" || sMessage == "/stärke" || sMessage == "/str") {
                iBonus = GetAbilityModifier(ABILITY_STRENGTH, oPc);
                sMessage = PrintRoll("Stärke", iRand, iBonus);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wisdom" || sMessage == "/weisheit" || sMessage == "/wis") {
                iBonus = GetAbilityModifier(ABILITY_WISDOM, oPc);
                sMessage = PrintRoll("Weisheit", iRand, iBonus);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            // Skills
            // Mit Tieren umgehen
            } else if (sMessage == "/mittierenumgehen") {
                RollSkillCheck("Mit Tieren umgehen", SKILL_ANIMAL_HANDLING, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/mittierenumgehen stärke" || sMessage == "/mittierenumgehen stä" || sMessage == "/mittierenumgehen str") {
                RollSkillCheck("Mit Tieren umgehen (Stärke)", SKILL_ANIMAL_HANDLING, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/mittierenumgehen geschicklichkeit" || sMessage == "/mittierenumgehen ges" || sMessage == "/mittierenumgehen dex") {
                RollSkillCheck("Mit Tieren umgehen (Gechicklichkeit)", SKILL_ANIMAL_HANDLING, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/mittierenumgehen konstitution" || sMessage == "/mittierenumgehen kon" || sMessage == "/mittierenumgehen con") {
                RollSkillCheck("Mit Tieren umgehen (Konstitution)", SKILL_ANIMAL_HANDLING, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/mittierenumgehen intelligenz" || sMessage == "/mittierenumgehen int") {
                RollSkillCheck("Mit Tieren umgehen (Intelligenz)", SKILL_ANIMAL_HANDLING, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/mittierenumgehen weisheit" || sMessage == "/mittierenumgehen wei" || sMessage == "/mittierenumgehen wis") {
                RollSkillCheck("Mit Tieren umgehen (Weisheit)", SKILL_ANIMAL_HANDLING, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/mittierenumgehen charisma" || sMessage == "/mittierenumgehen cha") {
                RollSkillCheck("Mit Tieren umgehen (Charisma)", SKILL_ANIMAL_HANDLING, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
           // Konzentration
            } else if (sMessage == "/konzentration") {
                RollSkillCheck("Konzentration", SKILL_CONCENTRATION, ABILITY_CONSTITUTION, ABILITY_CONSTITUTION, iChatVolume, oPc);
            } else if (sMessage == "/konzentration stärke" || sMessage == "/konzentration stä" || sMessage == "/konzentration str") {
                RollSkillCheck("Konzentration (Stärke)", SKILL_CONCENTRATION, ABILITY_STRENGTH, ABILITY_CONSTITUTION, iChatVolume, oPc);
            } else if (sMessage == "/konzentration geschicklichkeit" || sMessage == "/konzentration ges" || sMessage == "/konzentration dex") {
                RollSkillCheck("Konzentration (Gechicklichkeit)", SKILL_CONCENTRATION, ABILITY_DEXTERITY, ABILITY_CONSTITUTION, iChatVolume, oPc);
            } else if (sMessage == "/konzentration konstitution" || sMessage == "/konzentration kon" || sMessage == "/konzentration con") {
                RollSkillCheck("Konzentration (Konstitution)", SKILL_CONCENTRATION, ABILITY_CONSTITUTION, ABILITY_CONSTITUTION, iChatVolume, oPc);
            } else if (sMessage == "/konzentration intelligenz" || sMessage == "/konzentration int") {
                RollSkillCheck("Konzentration (Intelligenz)", SKILL_CONCENTRATION, ABILITY_INTELLIGENCE, ABILITY_CONSTITUTION, iChatVolume, oPc);
            } else if (sMessage == "/konzentration weisheit" || sMessage == "/konzentration wei" || sMessage == "/konzentration wis") {
                RollSkillCheck("Konzentration (Weisheit)", SKILL_CONCENTRATION, ABILITY_WISDOM, ABILITY_CONSTITUTION, iChatVolume, oPc);
            } else if (sMessage == "/konzentration charisma" || sMessage == "/konzentration cha") {
                RollSkillCheck("Konzentration (Charisma)", SKILL_CONCENTRATION, ABILITY_CHARISMA, ABILITY_CONSTITUTION, iChatVolume, oPc);
           // Motiv Erkennen
            } else if (sMessage == "/motiverkennen") {
                RollSkillCheck("Motiv erkennen", SKILL_SENSE_MOTIVE, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/motiverkennen stärke" || sMessage == "/motiverkennen stä" || sMessage == "/motiverkennen str") {
                RollSkillCheck("Motiv erkennen (Stärke)", SKILL_SENSE_MOTIVE, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/motiverkennen geschicklichkeit" || sMessage == "/motiverkennen ges" || sMessage == "/motiverkennen dex") {
                RollSkillCheck("Motiv erkennen (Gechicklichkeit)", SKILL_SENSE_MOTIVE, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/motiverkennen konstitution" || sMessage == "/motiverkennen kon" || sMessage == "/motiverkennen con") {
                RollSkillCheck("Motiv erkennen (Konstitution)", SKILL_SENSE_MOTIVE, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/motiverkennen intelligenz" || sMessage == "/motiverkennen int") {
                RollSkillCheck("Motiv erkennen (Intelligenz)", SKILL_SENSE_MOTIVE, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/motiverkennen weisheit" || sMessage == "/motiverkennen wei" || sMessage == "/motiverkennen wis") {
                RollSkillCheck("Motiv erkennen (Weisheit)", SKILL_SENSE_MOTIVE, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/motiverkennen charisma" || sMessage == "/motiverkennen cha") {
                RollSkillCheck("Motiv erkennen (Charisma)", SKILL_SENSE_MOTIVE, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
           // Heilkunde
            } else if (sMessage == "/heilkunde") {
                RollSkillCheck("Heilkunde", SKILL_HEAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/heilkunde stärke" || sMessage == "/heilkunde stä" || sMessage == "/heilkunde str") {
                RollSkillCheck("Heilkunde (Stärke)", SKILL_HEAL, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/heilkunde geschicklichkeit" || sMessage == "/heilkunde ges" || sMessage == "/heilkunde dex") {
                RollSkillCheck("Heilkunde (Gechicklichkeit)", SKILL_HEAL, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/heilkunde konstitution" || sMessage == "/heilkunde kon" || sMessage == "/heilkunde con") {
                RollSkillCheck("Heilkunde (Konstitution)", SKILL_HEAL, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/heilkunde intelligenz" || sMessage == "/heilkunde int") {
                RollSkillCheck("Heilkunde (Intelligenz)", SKILL_HEAL, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/heilkunde weisheit" || sMessage == "/heilkunde wei" || sMessage == "/heilkunde wis") {
                RollSkillCheck("Heilkunde (Weisheit)", SKILL_HEAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/heilkunde charisma" || sMessage == "/heilkunde cha") {
                RollSkillCheck("Heilkunde (Charisma)", SKILL_HEAL, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
           // Verstecken
            } else if (sMessage == "/verstecken") {
                RollSkillCheck("Verstecken", SKILL_HIDE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/verstecken stärke" || sMessage == "/verstecken stä" || sMessage == "/verstecken str") {
                RollSkillCheck("Verstecken (Stärke)", SKILL_HIDE, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/verstecken geschicklichkeit" || sMessage == "/verstecken ges" || sMessage == "/verstecken dex") {
                RollSkillCheck("Verstecken (Gechicklichkeit)", SKILL_HIDE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/verstecken konstitution" || sMessage == "/verstecken kon" || sMessage == "/verstecken con") {
                RollSkillCheck("Verstecken (Konstitution)", SKILL_HIDE, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/verstecken intelligenz" || sMessage == "/verstecken int") {
                RollSkillCheck("Verstecken (Intelligenz)", SKILL_HIDE, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/verstecken weisheit" || sMessage == "/verstecken wei" || sMessage == "/verstecken wis") {
                RollSkillCheck("Verstecken (Weisheit)", SKILL_HIDE, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/verstecken charisma" || sMessage == "/verstecken cha") {
                RollSkillCheck("Verstecken (Charisma)", SKILL_HIDE, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Lauschen
            } else if (sMessage == "/lauschen") {
                RollSkillCheck("Lauschen", SKILL_LISTEN, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/lauschen stärke" || sMessage == "/lauschen stä" || sMessage == "/lauschen str") {
                RollSkillCheck("Lauschen (Stärke)", SKILL_LISTEN, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/lauschen geschicklichkeit" || sMessage == "/lauschen ges" || sMessage == "/lauschen dex") {
                RollSkillCheck("Lauschen (Gechicklichkeit)", SKILL_LISTEN, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/lauschen konstitution" || sMessage == "/lauschen kon" || sMessage == "/lauschen con") {
                RollSkillCheck("Lauschen (Konstitution)", SKILL_LISTEN, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/lauschen intelligenz" || sMessage == "/lauschen int") {
                RollSkillCheck("Lauschen (Intelligenz)", SKILL_LISTEN, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/lauschen weisheit" || sMessage == "/lauschen wei" || sMessage == "/lauschen wis") {
                RollSkillCheck("Lauschen (Weisheit)", SKILL_LISTEN, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/lauschen charisma" || sMessage == "/lauschen cha") {
                RollSkillCheck("Lauschen (Charisma)", SKILL_LISTEN, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
           // Wissen: Weltliches
            } else if (sMessage == "/weltliches") {
                RollSkillCheck("Weltliches", SKILL_KNOW_LORE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/weltliches stärke" || sMessage == "/weltliches stä" || sMessage == "/weltliches str") {
                RollSkillCheck("Weltliches (Stärke)", SKILL_KNOW_LORE, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/weltliches geschicklichkeit" || sMessage == "/weltliches ges" || sMessage == "/weltliches dex") {
                RollSkillCheck("Weltliches (Gechicklichkeit)", SKILL_KNOW_LORE, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/weltliches konstitution" || sMessage == "/weltliches kon" || sMessage == "/weltliches con") {
                RollSkillCheck("Weltliches (Konstitution)", SKILL_KNOW_LORE, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/weltliches intelligenz" || sMessage == "/weltliches int") {
                RollSkillCheck("Weltliches (Intelligenz)", SKILL_KNOW_LORE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/weltliches weisheit" || sMessage == "/weltliches wei" || sMessage == "/weltliches wis") {
                RollSkillCheck("Weltliches (Weisheit)", SKILL_KNOW_LORE, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/weltliches charisma" || sMessage == "/weltliches cha") {
                RollSkillCheck("Weltliches (Charisma)", SKILL_KNOW_LORE, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
           // Leise Bewegen
            } else if (sMessage == "/leisebewegen") {
                RollSkillCheck("Leise bewegen", SKILL_MOVE_SILENTLY, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/leisebewegen stärke" || sMessage == "/leisebewegen stä" || sMessage == "/leisebewegen str") {
                RollSkillCheck("Leise bewegen (Stärke)", SKILL_MOVE_SILENTLY, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/leisebewegen geschicklichkeit" || sMessage == "/leisebewegen ges" || sMessage == "/leisebewegen dex") {
                RollSkillCheck("Leise bewegen (Gechicklichkeit)", SKILL_MOVE_SILENTLY, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/leisebewegen konstitution" || sMessage == "/leisebewegen kon" || sMessage == "/leisebewegen con") {
                RollSkillCheck("Leise bewegen (Konstitution)", SKILL_MOVE_SILENTLY, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/leisebewegen intelligenz" || sMessage == "/leisebewegen int") {
                RollSkillCheck("Leise bewegen (Intelligenz)", SKILL_MOVE_SILENTLY, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/leisebewegen weisheit" || sMessage == "/leisebewegen wei" || sMessage == "/leisebewegen wis") {
                RollSkillCheck("Leise bewegen (Weisheit)", SKILL_MOVE_SILENTLY, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/leisebewegen charisma" || sMessage == "/leisebewegen cha") {
                RollSkillCheck("Leise bewegen (Charisma)", SKILL_MOVE_SILENTLY, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Mechanismus ausschalten
            } else if (sMessage == "/mechanismusausschalten") {
                RollSkillCheck("Mechanismus ausschalten", SKILL_DISABLE_DEVICE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/mechanismusausschalten stärke" || sMessage == "/mechanismusausschalten stä" || sMessage == "/mechanismusausschalten str") {
                RollSkillCheck("Mechanismus ausschalten (Stärke)", SKILL_DISABLE_DEVICE, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/mechanismusausschalten geschicklichkeit" || sMessage == "/mechanismusausschalten ges" || sMessage == "/mechanismusausschalten dex") {
                RollSkillCheck("Mechanismus ausschalten (Gechicklichkeit)", SKILL_DISABLE_DEVICE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/mechanismusausschalten konstitution" || sMessage == "/mechanismusausschalten kon" || sMessage == "/mechanismusausschalten con") {
                RollSkillCheck("Mechanismus ausschalten (Konstitution)", SKILL_DISABLE_DEVICE, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/mechanismusausschalten intelligenz" || sMessage == "/mechanismusausschalten int") {
                RollSkillCheck("Mechanismus ausschalten (Intelligenz)", SKILL_DISABLE_DEVICE, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/mechanismusausschalten weisheit" || sMessage == "/mechanismusausschalten wei" || sMessage == "/mechanismusausschalten wis") {
                RollSkillCheck("Mechanismus ausschalten (Weisheit)", SKILL_DISABLE_DEVICE, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/mechanismusausschalten charisma" || sMessage == "/mechanismusausschalten cha") {
                RollSkillCheck("Mechanismus ausschalten (Charisma)", SKILL_DISABLE_DEVICE, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Auftreten
            } else if (sMessage == "/auftreten") {
                RollSkillCheck("Auftreten", SKILL_PERFORM, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/auftreten stärke" || sMessage == "/auftreten stä" || sMessage == "/auftreten str") {
                RollSkillCheck("Auftreten (Stärke)", SKILL_PERFORM, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/auftreten geschicklichkeit" || sMessage == "/auftreten ges" || sMessage == "/auftreten dex") {
                RollSkillCheck("Auftreten (Gechicklichkeit)", SKILL_PERFORM, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/auftreten konstitution" || sMessage == "/auftreten kon" || sMessage == "/auftreten con") {
                RollSkillCheck("Auftreten (Konstitution)", SKILL_PERFORM, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/auftreten intelligenz" || sMessage == "/auftreten int") {
                RollSkillCheck("Auftreten (Intelligenz)", SKILL_PERFORM, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/auftreten weisheit" || sMessage == "/auftreten wei" || sMessage == "/auftreten wis") {
                RollSkillCheck("Auftreten (Weisheit)", SKILL_PERFORM, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/auftreten charisma" || sMessage == "/auftreten cha") {
                RollSkillCheck("Auftreten (Charisma)", SKILL_PERFORM, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
           // Überzeugen
            } else if (sMessage == "/überzeugen") {
                RollSkillCheck("Überzeugen", SKILL_PERSUADE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/überzeugen stärke" || sMessage == "/überzeugen stä" || sMessage == "/überzeugen str") {
                RollSkillCheck("Überzeugen (Stärke)", SKILL_PERSUADE, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/überzeugen geschicklichkeit" || sMessage == "/überzeugen ges" || sMessage == "/überzeugen dex") {
                RollSkillCheck("Überzeugen (Gechicklichkeit)", SKILL_PERSUADE, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/überzeugen konstitution" || sMessage == "/überzeugen kon" || sMessage == "/überzeugen con") {
                RollSkillCheck("Überzeugen (Konstitution)", SKILL_PERSUADE, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/überzeugen intelligenz" || sMessage == "/überzeugen int") {
                RollSkillCheck("Überzeugen (Intelligenz)", SKILL_PERSUADE, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/überzeugen weisheit" || sMessage == "/überzeugen wei" || sMessage == "/überzeugen wis") {
                RollSkillCheck("Überzeugen (Weisheit)", SKILL_PERSUADE, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/überzeugen charisma" || sMessage == "/überzeugen cha") {
                RollSkillCheck("Überzeugen (Charisma)", SKILL_PERSUADE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
           // Fingerfertigkeit
            } else if (sMessage == "/fingerfertigkeit") {
                RollSkillCheck("Fingerfertigkeit", SKILL_SLEIGHT_OF_HAND, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/fingerfertigkeit stärke" || sMessage == "/fingerfertigkeit stä" || sMessage == "/fingerfertigkeit str") {
                RollSkillCheck("Fingerfertigkeit (Stärke)", SKILL_SLEIGHT_OF_HAND, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/fingerfertigkeit geschicklichkeit" || sMessage == "/fingerfertigkeit ges" || sMessage == "/fingerfertigkeit dex") {
                RollSkillCheck("Fingerfertigkeit (Gechicklichkeit)", SKILL_SLEIGHT_OF_HAND, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/fingerfertigkeit konstitution" || sMessage == "/fingerfertigkeit kon" || sMessage == "/fingerfertigkeit con") {
                RollSkillCheck("Fingerfertigkeit (Konstitution)", SKILL_SLEIGHT_OF_HAND, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/fingerfertigkeit intelligenz" || sMessage == "/fingerfertigkeit int") {
                RollSkillCheck("Fingerfertigkeit (Intelligenz)", SKILL_SLEIGHT_OF_HAND, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/fingerfertigkeit weisheit" || sMessage == "/fingerfertigkeit wei" || sMessage == "/fingerfertigkeit wis") {
                RollSkillCheck("Fingerfertigkeit (Weisheit)", SKILL_SLEIGHT_OF_HAND, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/fingerfertigkeit charisma" || sMessage == "/fingerfertigkeit cha") {
                RollSkillCheck("Fingerfertigkeit (Charisma)", SKILL_SLEIGHT_OF_HAND, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Untersuchen
            } else if (sMessage == "/untersuchen") {
                RollSkillCheck("Untersuchen", SKILL_SEARCH, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/untersuchen stärke" || sMessage == "/untersuchen stä" || sMessage == "/untersuchen str") {
                RollSkillCheck("Untersuchen (Stärke)", SKILL_SEARCH, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/untersuchen geschicklichkeit" || sMessage == "/untersuchen ges" || sMessage == "/untersuchen dex") {
                RollSkillCheck("Untersuchen (Gechicklichkeit)", SKILL_SEARCH, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/untersuchen konstitution" || sMessage == "/untersuchen kon" || sMessage == "/untersuchen con") {
                RollSkillCheck("Untersuchen (Konstitution)", SKILL_SEARCH, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/untersuchen intelligenz" || sMessage == "/untersuchen int") {
                RollSkillCheck("Untersuchen (Intelligenz)", SKILL_SEARCH, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/untersuchen weisheit" || sMessage == "/untersuchen wei" || sMessage == "/untersuchen wis") {
                RollSkillCheck("Untersuchen (Weisheit)", SKILL_SEARCH, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/untersuchen charisma" || sMessage == "/untersuchen cha") {
                RollSkillCheck("Untersuchen (Charisma)", SKILL_SEARCH, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
           // Wissen: Natur
            } else if (sMessage == "/natur") {
                RollSkillCheck("Natur", SKILL_KNOW_NATURE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/natur stärke" || sMessage == "/natur stä" || sMessage == "/natur str") {
                RollSkillCheck("Natur (Stärke)", SKILL_KNOW_NATURE, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/natur geschicklichkeit" || sMessage == "/natur ges" || sMessage == "/natur dex") {
                RollSkillCheck("Natur (Gechicklichkeit)", SKILL_KNOW_NATURE, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/natur konstitution" || sMessage == "/natur kon" || sMessage == "/natur con") {
                RollSkillCheck("Natur (Konstitution)", SKILL_KNOW_NATURE, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/natur intelligenz" || sMessage == "/natur int") {
                RollSkillCheck("Natur (Intelligenz)", SKILL_KNOW_NATURE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/natur weisheit" || sMessage == "/natur wei" || sMessage == "/natur wis") {
                RollSkillCheck("Natur (Weisheit)", SKILL_KNOW_NATURE, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/natur charisma" || sMessage == "/natur cha") {
                RollSkillCheck("Natur (Charisma)", SKILL_KNOW_NATURE, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
           // Wissen: Arkanes
            } else if (sMessage == "/arkanes") {
                RollSkillCheck("Arkanes", SKILL_KNOW_ARCANA, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/arkanes stärke" || sMessage == "/arkanes stä" || sMessage == "/arkanes str") {
                RollSkillCheck("Arkanes (Stärke)", SKILL_KNOW_ARCANA, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/arkanes geschicklichkeit" || sMessage == "/arkanes ges" || sMessage == "/arkanes dex") {
                RollSkillCheck("Arkanes (Gechicklichkeit)", SKILL_KNOW_ARCANA, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/arkanes konstitution" || sMessage == "/arkanes kon" || sMessage == "/arkanes con") {
                RollSkillCheck("Arkanes (Konstitution)", SKILL_KNOW_ARCANA, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/arkanes intelligenz" || sMessage == "/arkanes int") {
                RollSkillCheck("Arkanes (Intelligenz)", SKILL_KNOW_ARCANA, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/arkanes weisheit" || sMessage == "/arkanes wei" || sMessage == "/arkanes wis") {
                RollSkillCheck("Arkanes (Weisheit)", SKILL_KNOW_ARCANA, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/arkanes charisma" || sMessage == "/arkanes cha") {
                RollSkillCheck("Arkanes (Charisma)", SKILL_KNOW_ARCANA, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
           // Entdecken
            } else if (sMessage == "/entdecken") {
                RollSkillCheck("Entdecken", SKILL_SPOT, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/entdecken stärke" || sMessage == "/entdecken stä" || sMessage == "/entdecken str") {
                RollSkillCheck("Entdecken (Stärke)", SKILL_SPOT, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/entdecken geschicklichkeit" || sMessage == "/entdecken ges" || sMessage == "/entdecken dex") {
                RollSkillCheck("Entdecken (Gechicklichkeit)", SKILL_SPOT, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/entdecken konstitution" || sMessage == "/entdecken kon" || sMessage == "/entdecken con") {
                RollSkillCheck("Entdecken (Konstitution)", SKILL_SPOT, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/entdecken intelligenz" || sMessage == "/entdecken int") {
                RollSkillCheck("Entdecken (Intelligenz)", SKILL_SPOT, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/entdecken weisheit" || sMessage == "/entdecken wei" || sMessage == "/entdecken wis") {
                RollSkillCheck("Entdecken (Weisheit)", SKILL_SPOT, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/entdecken charisma" || sMessage == "/entdecken cha") {
                RollSkillCheck("Entdecken (Charisma)", SKILL_SPOT, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
           // Magischen Gegenstand benutzen
            } else if (sMessage == "/magischengegenstandbenutzen") {
                RollSkillCheck("Magischen Gegenstand benutzen", SKILL_USE_MAGIC_DEVICE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/magischengegenstandbenutzen stärke" || sMessage == "/magischengegenstandbenutzen stä" || sMessage == "/magischengegenstandbenutzen str") {
                RollSkillCheck("Magischen Gegenstand benutzen (Stärke)", SKILL_USE_MAGIC_DEVICE, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/magischengegenstandbenutzen geschicklichkeit" || sMessage == "/magischengegenstandbenutzen ges" || sMessage == "/magischengegenstandbenutzen dex") {
                RollSkillCheck("Magischen Gegenstand benutzen (Gechicklichkeit)", SKILL_USE_MAGIC_DEVICE, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/magischengegenstandbenutzen konstitution" || sMessage == "/magischengegenstandbenutzen kon" || sMessage == "/magischengegenstandbenutzen con") {
                RollSkillCheck("Magischen Gegenstand benutzen (Konstitution)", SKILL_USE_MAGIC_DEVICE, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/magischengegenstandbenutzen intelligenz" || sMessage == "/magischengegenstandbenutzen int") {
                RollSkillCheck("Magischen Gegenstand benutzen (Intelligenz)", SKILL_USE_MAGIC_DEVICE, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/magischengegenstandbenutzen weisheit" || sMessage == "/magischengegenstandbenutzen wei" || sMessage == "/magischengegenstandbenutzen wis") {
                RollSkillCheck("Magischen Gegenstand benutzen (Weisheit)", SKILL_USE_MAGIC_DEVICE, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/magischengegenstandbenutzen charisma" || sMessage == "/magischengegenstandbenutzen cha") {
                RollSkillCheck("Magischen Gegenstand benutzen (Charisma)", SKILL_USE_MAGIC_DEVICE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
           // Wissen: Religion
            } else if (sMessage == "/religion") {
                RollSkillCheck("Religion", SKILL_KNOW_RELIGION, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/religion stärke" || sMessage == "/religion stä" || sMessage == "/religion str") {
                RollSkillCheck("Religion (Stärke)", SKILL_KNOW_RELIGION, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/religion geschicklichkeit" || sMessage == "/religion ges" || sMessage == "/religion dex") {
                RollSkillCheck("Religion (Gechicklichkeit)", SKILL_KNOW_RELIGION, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/religion konstitution" || sMessage == "/religion kon" || sMessage == "/religion con") {
                RollSkillCheck("Religion (Konstitution)", SKILL_KNOW_RELIGION, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/religion intelligenz" || sMessage == "/religion int") {
                RollSkillCheck("Religion (Intelligenz)", SKILL_KNOW_RELIGION, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/religion weisheit" || sMessage == "/religion wei" || sMessage == "/religion wis") {
                RollSkillCheck("Religion (Weisheit)", SKILL_KNOW_RELIGION, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/religion charisma" || sMessage == "/religion cha") {
                RollSkillCheck("Religion (Charisma)", SKILL_KNOW_RELIGION, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
           // Akrobatik
            } else if (sMessage == "/akrobatik") {
                RollSkillCheck("Akrobatik", SKILL_ACROBATICS, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/akrobatik stärke" || sMessage == "/akrobatik stä" || sMessage == "/akrobatik str") {
                RollSkillCheck("Akrobatik (Stärke)", SKILL_ACROBATICS, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/akrobatik geschicklichkeit" || sMessage == "/akrobatik ges" || sMessage == "/akrobatik dex") {
                RollSkillCheck("Akrobatik (Gechicklichkeit)", SKILL_ACROBATICS, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/akrobatik konstitution" || sMessage == "/akrobatik kon" || sMessage == "/akrobatik con") {
                RollSkillCheck("Akrobatik (Konstitution)", SKILL_ACROBATICS, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/akrobatik intelligenz" || sMessage == "/akrobatik int") {
                RollSkillCheck("Akrobatik (Intelligenz)", SKILL_ACROBATICS, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/akrobatik weisheit" || sMessage == "/akrobatik wei" || sMessage == "/akrobatik wis") {
                RollSkillCheck("Akrobatik (Weisheit)", SKILL_ACROBATICS, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/akrobatik charisma" || sMessage == "/akrobatik cha") {
                RollSkillCheck("Akrobatik (Charisma)", SKILL_ACROBATICS, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Handwerk: Lederer
            } else if (sMessage == "/lederer") {
                RollSkillCheck("Lederer", SKILL_CRAFT_LEATHERER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/lederer stärke" || sMessage == "/lederer stä" || sMessage == "/lederer str") {
                RollSkillCheck("Lederer (Stärke)", SKILL_CRAFT_LEATHERER, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/lederer geschicklichkeit" || sMessage == "/lederer ges" || sMessage == "/lederer dex") {
                RollSkillCheck("Lederer (Gechicklichkeit)", SKILL_CRAFT_LEATHERER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/lederer konstitution" || sMessage == "/lederer kon" || sMessage == "/lederer con") {
                RollSkillCheck("Lederer (Konstitution)", SKILL_CRAFT_LEATHERER, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/lederer intelligenz" || sMessage == "/lederer int") {
                RollSkillCheck("Lederer (Intelligenz)", SKILL_CRAFT_LEATHERER, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/lederer weisheit" || sMessage == "/lederer wei" || sMessage == "/lederer wis") {
                RollSkillCheck("Lederer (Weisheit)", SKILL_CRAFT_LEATHERER, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/lederer charisma" || sMessage == "/lederer cha") {
                RollSkillCheck("Lederer (Charisma)", SKILL_CRAFT_LEATHERER, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Täuschen
            } else if (sMessage == "/täuschen") {
                RollSkillCheck("Täuschen", SKILL_DECEPTION, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/täuschen stärke" || sMessage == "/täuschen stä" || sMessage == "/täuschen str") {
                RollSkillCheck("Täuschen (Stärke)", SKILL_DECEPTION, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/täuschen geschicklichkeit" || sMessage == "/täuschen ges" || sMessage == "/täuschen dex") {
                RollSkillCheck("Täuschen (Gechicklichkeit)", SKILL_DECEPTION, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/täuschen konstitution" || sMessage == "/täuschen kon" || sMessage == "/täuschen con") {
                RollSkillCheck("Täuschen (Konstitution)", SKILL_DECEPTION, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/täuschen intelligenz" || sMessage == "/täuschen int") {
                RollSkillCheck("Täuschen (Intelligenz)", SKILL_DECEPTION, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/täuschen weisheit" || sMessage == "/täuschen wei" || sMessage == "/täuschen wis") {
                RollSkillCheck("Täuschen (Weisheit)", SKILL_DECEPTION, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/täuschen charisma" || sMessage == "/täuschen cha") {
                RollSkillCheck("Täuschen (Charisma)", SKILL_DECEPTION, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
           // Einschüchtern
            } else if (sMessage == "/einschüchtern") {
                RollSkillCheck("Einschüchtern", SKILL_INTIMIDATE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/einschüchtern stärke" || sMessage == "/einschüchtern stä" || sMessage == "/einschüchtern str") {
                RollSkillCheck("Einschüchtern (Stärke)", SKILL_INTIMIDATE, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/einschüchtern geschicklichkeit" || sMessage == "/einschüchtern ges" || sMessage == "/einschüchtern dex") {
                RollSkillCheck("Einschüchtern (Gechicklichkeit)", SKILL_INTIMIDATE, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/einschüchtern konstitution" || sMessage == "/einschüchtern kon" || sMessage == "/einschüchtern con") {
                RollSkillCheck("Einschüchtern (Konstitution)", SKILL_INTIMIDATE, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/einschüchtern intelligenz" || sMessage == "/einschüchtern int") {
                RollSkillCheck("Einschüchtern (Intelligenz)", SKILL_INTIMIDATE, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/einschüchtern weisheit" || sMessage == "/einschüchtern wei" || sMessage == "/einschüchtern wis") {
                RollSkillCheck("Einschüchtern (Weisheit)", SKILL_INTIMIDATE, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
            } else if (sMessage == "/einschüchtern charisma" || sMessage == "/einschüchtern cha") {
                RollSkillCheck("Einschüchtern (Charisma)", SKILL_INTIMIDATE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
           // Handwerk: Schmied
            } else if (sMessage == "/schmied") {
                RollSkillCheck("Schmied", SKILL_CRAFT_SMITH, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/schmied stärke" || sMessage == "/schmied stä" || sMessage == "/schmied str") {
                RollSkillCheck("Schmied (Stärke)", SKILL_CRAFT_SMITH, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/schmied geschicklichkeit" || sMessage == "/schmied ges" || sMessage == "/schmied dex") {
                RollSkillCheck("Schmied (Gechicklichkeit)", SKILL_CRAFT_SMITH, ABILITY_DEXTERITY, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/schmied konstitution" || sMessage == "/schmied kon" || sMessage == "/schmied con") {
                RollSkillCheck("Schmied (Konstitution)", SKILL_CRAFT_SMITH, ABILITY_CONSTITUTION, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/schmied intelligenz" || sMessage == "/schmied int") {
                RollSkillCheck("Schmied (Intelligenz)", SKILL_CRAFT_SMITH, ABILITY_INTELLIGENCE, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/schmied weisheit" || sMessage == "/schmied wei" || sMessage == "/schmied wis") {
                RollSkillCheck("Schmied (Weisheit)", SKILL_CRAFT_SMITH, ABILITY_WISDOM, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/schmied charisma" || sMessage == "/schmied cha") {
                RollSkillCheck("Schmied (Charisma)", SKILL_CRAFT_SMITH, ABILITY_CHARISMA, ABILITY_STRENGTH, iChatVolume, oPc);
           // Handwerk: Schreiner
            } else if (sMessage == "/schreiner") {
                RollSkillCheck("Schreiner", SKILL_CRAFT_CARPENTER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/schreiner stärke" || sMessage == "/schreiner stä" || sMessage == "/schreiner str") {
                RollSkillCheck("Schreiner (Stärke)", SKILL_CRAFT_CARPENTER, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/schreiner geschicklichkeit" || sMessage == "/schreiner ges" || sMessage == "/schreiner dex") {
                RollSkillCheck("Schreiner (Gechicklichkeit)", SKILL_CRAFT_CARPENTER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/schreiner konstitution" || sMessage == "/schreiner kon" || sMessage == "/schreiner con") {
                RollSkillCheck("Schreiner (Konstitution)", SKILL_CRAFT_CARPENTER, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/schreiner intelligenz" || sMessage == "/schreiner int") {
                RollSkillCheck("Schreiner (Intelligenz)", SKILL_CRAFT_CARPENTER, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/schreiner weisheit" || sMessage == "/schreiner wei" || sMessage == "/schreiner wis") {
                RollSkillCheck("Schreiner (Weisheit)", SKILL_CRAFT_CARPENTER, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
            } else if (sMessage == "/schreiner charisma" || sMessage == "/schreiner cha") {
                RollSkillCheck("Schreiner (Charisma)", SKILL_CRAFT_CARPENTER, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
           // Handwerk: Alchemie
            } else if (sMessage == "/alchemist") {
                RollSkillCheck("Alchemie", SKILL_CRAFT_ALCHEMIST, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/alchemist stärke" || sMessage == "/alchemist stä" || sMessage == "/alchemist str") {
                RollSkillCheck("Alchemie (Stärke)", SKILL_CRAFT_ALCHEMIST, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/alchemist geschicklichkeit" || sMessage == "/alchemist ges" || sMessage == "/alchemist dex") {
                RollSkillCheck("Alchemie (Gechicklichkeit)", SKILL_CRAFT_ALCHEMIST, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/alchemist konstitution" || sMessage == "/alchemist kon" || sMessage == "/alchemist con") {
                RollSkillCheck("Alchemie (Konstitution)", SKILL_CRAFT_ALCHEMIST, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/alchemist intelligenz" || sMessage == "/alchemist int") {
                RollSkillCheck("Alchemie (Intelligenz)", SKILL_CRAFT_ALCHEMIST, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/alchemist weisheit" || sMessage == "/alchemist wei" || sMessage == "/alchemist wis") {
                RollSkillCheck("Alchemie (Weisheit)", SKILL_CRAFT_ALCHEMIST, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
            } else if (sMessage == "/alchemist charisma" || sMessage == "/alchemist cha") {
                RollSkillCheck("Alchemie (Charisma)", SKILL_CRAFT_ALCHEMIST, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
           // Athletik
            } else if (sMessage == "/athletik") {
                RollSkillCheck("Athletik", SKILL_ATHLETICS, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/athletik stärke" || sMessage == "/athletik stä" || sMessage == "/athletik str") {
                RollSkillCheck("Athletik (Stärke)", SKILL_ATHLETICS, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/athletik geschicklichkeit" || sMessage == "/athletik ges" || sMessage == "/athletik dex") {
                RollSkillCheck("Athletik (Gechicklichkeit)", SKILL_ATHLETICS, ABILITY_DEXTERITY, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/athletik konstitution" || sMessage == "/athletik kon" || sMessage == "/athletik con") {
                RollSkillCheck("Athletik (Konstitution)", SKILL_ATHLETICS, ABILITY_CONSTITUTION, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/athletik intelligenz" || sMessage == "/athletik int") {
                RollSkillCheck("Athletik (Intelligenz)", SKILL_ATHLETICS, ABILITY_INTELLIGENCE, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/athletik weisheit" || sMessage == "/athletik wei" || sMessage == "/athletik wis") {
                RollSkillCheck("Athletik (Weisheit)", SKILL_ATHLETICS, ABILITY_WISDOM, ABILITY_STRENGTH, iChatVolume, oPc);
            } else if (sMessage == "/athletik charisma" || sMessage == "/athletik cha") {
                RollSkillCheck("Athletik (Charisma)", SKILL_ATHLETICS, ABILITY_CHARISMA, ABILITY_STRENGTH, iChatVolume, oPc);
           // Überleben
            } else if (sMessage == "/überleben") {
                RollSkillCheck("Überleben", SKILL_SURVIVAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/überleben stärke" || sMessage == "/Überleben stä" || sMessage == "/Überleben str") {
                RollSkillCheck("Überleben (Stärke)", SKILL_SURVIVAL, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/überleben geschicklichkeit" || sMessage == "/Überleben ges" || sMessage == "/Überleben dex") {
                RollSkillCheck("Überleben (Gechicklichkeit)", SKILL_SURVIVAL, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/überleben konstitution" || sMessage == "/Überleben kon" || sMessage == "/Überleben con") {
                RollSkillCheck("Überleben (Konstitution)", SKILL_SURVIVAL, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/überleben intelligenz" || sMessage == "/Überleben int") {
                RollSkillCheck("Überleben (Intelligenz)", SKILL_SURVIVAL, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/überleben weisheit" || sMessage == "/Überleben wei" || sMessage == "/Überleben wis") {
                RollSkillCheck("Überleben (Weisheit)", SKILL_SURVIVAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/überleben charisma" || sMessage == "/Überleben cha") {
                RollSkillCheck("Überleben (Charisma)", SKILL_SURVIVAL, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
            } else if (sMessage == "/wissenbarde") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPc);
                sMessage = PrintRollSkill("Wissen: Barde", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wissenbarde stärke" || sMessage == "/wissenbarde stä" || sMessage == "/wissenbarde str") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_STRENGTH, oPc);
                sMessage = PrintRollSkill("Wissen: Barde (STR)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wissenbarde geschicklichkeit" || sMessage == "/wissenbarde ges" || sMessage == "/wissenbarde dex") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_DEXTERITY, oPc);
                sMessage = PrintRollSkill("Wissen: Barde (DEX)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wissenbarde konstitution" || sMessage == "/wissenbarde kon" || sMessage == "/wissenbarde con") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_CONSTITUTION, oPc);
                sMessage = PrintRollSkill("Wissen: Barde (CON)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wissenbarde intelligenz" || sMessage == "/wissenbarde int") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPc);
                sMessage = PrintRollSkill("Wissen: Barde (Intelligenz)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wissenbarde weisheit" || sMessage == "/wissenbarde wei" || sMessage == "/wissenbarde wis") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_WISDOM, oPc);
                sMessage = PrintRollSkill("Wissen: Barde (WIS)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/wissenbarde charisma" || sMessage == "/wissenbarde cha") {
                iBonus = GetSkillRank(27, oPc);
                iAbilityBonus = GetAbilityModifier(ABILITY_CHARISMA, oPc);
                sMessage = PrintRollSkill("Wissen: Barde (Charisma)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);




            } else if (sMessage == "/d4") {
                sMessage = PrintRoll("d4", Random(4) + 1, 0);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/d6") {
                sMessage = PrintRoll("d6", Random(6) + 1, 0);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/d8") {
                sMessage = PrintRoll("d8", Random(8) + 1, 0);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/d10") {
                sMessage = PrintRoll("d10", Random(10) + 1, 0);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            } else if (sMessage == "/d20") {
                sMessage = PrintRoll("d20", Random(20) + 1, 0);
                //AssignCommand(oPc, ActionSpeakString(sMessage));
                SetLocalString(oPc, "sMessage", sMessage);
                SetLocalInt(oPc, "iChatVolume", iChatVolume);
                ExecuteScript("global_speak", oPc);
            // Familiar
            } else if (sMessage == "/familiar" || sMessage == "/vertrauter") {
                SummonFamiliar(oPc);
            // Animal Companion
            } else if (sMessage == "/companion" || sMessage == "/begleiter") {
                SummonAnimalCompanion(oPc);
            // Token
            } else if (sMessage == "/token") {
                sQuery = "SELECT token FROM Users WHERE name=? AND charname=?";
                string sAccountName = GetPCPlayerName(oPc);
                string sName = GetName(oPc);
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, sAccountName);
                    NWNX_SQL_PreparedString(1, sName);
                    NWNX_SQL_ExecutePreparedQuery();
                    NWNX_SQL_ReadNextRow();
                    SendMessageToPC(oPc, NWNX_SQL_ReadDataInActiveRow(0));
                }
                //SetDeity(oPc, "foo");
                //SendMessageToPC(oPc, GetDeity(oPc));
            } else if (sMessage == "/delete") {
                sQuery = "SELECT token FROM Users WHERE name=? AND charname=?";
                string sAccountName = GetPCPlayerName(oPc);
                string sName = GetName(oPc);
                if (NWNX_SQL_PrepareQuery(sQuery)) {
                    NWNX_SQL_PreparedString(0, sAccountName);
                    NWNX_SQL_PreparedString(1, sName);
                    NWNX_SQL_ExecutePreparedQuery();
                    NWNX_SQL_ReadNextRow();
                    SendMessageToPC(oPc, "Um den Charakter unwiderruflich und endgültig zu lÃ¶schen /delete " + NWNX_SQL_ReadDataInActiveRow(0) + " eingeben.");
                }
            // Unterschlupf /hindurchzwängen
            } else if (sMessage == "/hindurchzwängen") {
                if (GetTag(GetArea(oPc)) == "AREA_Unterschlupf") {
                    location lUnterschlupf = GetLocation(GetObjectByTag("WP_UNTERSCHLUPF"));
                    DelayCommand(0.0, AssignCommand(oPc, JumpToLocation(lUnterschlupf)));
                }
            // Phenotype 0
            } else if (sMessage == "/phenotype 0") {
                SetPhenoType(0, oPc);
            // Phenotype 1
            } else if (sMessage == "/phenotype 1") {
                SetPhenoType(1, oPc);
            } else if (sMessage == "/afk") {
                if (GetLocalInt(oPc, "afk") == 1) {
                    SetLocalInt(oPc, "afk", 0);
                    effect eEffect = GetFirstEffect(oPc);
                    while(GetIsEffectValid(eEffect)) {
                        if(GetEffectTag(eEffect) == "eff_afk") {
                            RemoveEffect(oPc, eEffect);
                        }
                        eEffect = GetNextEffect(oPc);
                    }
                } else {
                    SetLocalInt(oPc, "afk", 1);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectVisualEffect(8192), "eff_afk"), oPc);
                }
            // Remove Collision
            } else if (sMessage == "/geist" || sMessage == "/ghost") {
                effect eGhost = EffectCutsceneGhost();
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oPc);
            // Climb
            } else if (sMessage == "/klettern" || sMessage == "/climb") {
                if (GetTag(GetArea(oPc)) == "AREA_Freihafen" && GetDistanceBetween(oPc, GetObjectByTag("KLETTERN_Tempel")) < 2.0) {
                    location lLocation = GetLocation(GetObjectByTag("KLETTERN_Tempel2"));
                    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lLocation)));
                }
                if (GetTag(GetArea(oPc)) == "AREA_Freihafen" && GetDistanceBetween(oPc, GetObjectByTag("KLETTERN_Tempel2")) < 2.0) {
                    location lLocation = GetLocation(GetObjectByTag("KLETTERN_Tempel"));
                    DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lLocation)));
                }
            // Backpack
            } else if (sMessage == "/rucksack" || sMessage == "/backpack") {
                if (GetLocalInt(oPc, "backpack") == 1) {
                    SetLocalInt(oPc, "backpack", 0);
                    effect eEffect = GetFirstEffect(oPc);
                    while(GetIsEffectValid(eEffect)) {
                        if(GetEffectTag(eEffect) == "eff_backpack") {
                            RemoveEffect(oPc, eEffect);
                        }
                        eEffect = GetNextEffect(oPc);
                    }
                } else {
                    SetLocalInt(oPc, "backpack", 1);
                    int iRace = GetRacialType(oPc);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectVisualEffect(9515), "eff_backpack"), oPc);
                }
            // PvP
            } else if (sMessage == "/pvp") {
                SetLocalInt(oPc, "pvp", 1);
                SendMessageToPC(oPc, "Ihr hab PvP (Spieler gegen Spieler) aktiviert und könnt nun angegriffen werden!");
            // Masks
            } else if (GetSubString(sMessage, 0, 6) == "/maske") {
                int iMask = StringToInt(GetSubString(sMessage, 7, 2));
                if (iMask == 0) applyMask(oPc, 8193);
                if (iMask == 1) applyMask(oPc, 8193);
                if (iMask == 2) applyMask(oPc, 8215);
                if (iMask == 3) applyMask(oPc, 8240);
                if (iMask == 4) applyMask(oPc, 8265);
                if (iMask == 5) applyMask(oPc, 8290);
                if (iMask == 6) applyMask(oPc, 8315);
                if (iMask == 7) applyMask(oPc, 8340);
                if (iMask == 8) applyMask(oPc, 8365);
                if (iMask == 9) applyMask(oPc, 8390);
                if (iMask == 10) applyMask(oPc, 8415);
                if (iMask == 11) applyMask(oPc, 8440);
                if (iMask == 12) applyMask(oPc, 8465);
                if (iMask == 13) applyMask(oPc, 8490);
                if (iMask == 14) applyMask(oPc, 8515);
                if (iMask == 15) applyMask(oPc, 8540);
                if (iMask == 16) applyMask(oPc, 8565);
                if (iMask == 17) applyMask(oPc, 8590);
                if (iMask == 18) applyMask(oPc, 8615);
                if (iMask == 19) applyMask(oPc, 8640);
                if (iMask == 20) applyMask(oPc, 8665);
                if (iMask == 21) applyMask(oPc, 8690);
                if (iMask == 22) applyMask(oPc, 8715);
                if (iMask == 23) applyMask(oPc, 8740);
                if (iMask == 24) applyMask(oPc, 8765);
                if (iMask == 25) applyMask(oPc, 8790);
                if (iMask == 26) applyMask(oPc, 8815);
                if (iMask == 27) applyMask(oPc, 8840);
                if (iMask == 28) applyMask(oPc, 8865);
                if (iMask == 29) applyMask(oPc, 8890);
                if (iMask == 30) applyMask(oPc, 8915);
                if (iMask == 31) applyMask(oPc, 8940);
                if (iMask == 32) applyMask(oPc, 8965);
                if (iMask == 33) applyMask(oPc, 8990);
                if (iMask == 34) applyMask(oPc, 9015);
                if (iMask == 35) applyMask(oPc, 9040);
                if (iMask == 36) applyMask(oPc, 9065);
                if (iMask == 37) applyMask(oPc, 9090);
                if (iMask == 38) applyMask(oPc, 9115);
                if (iMask == 39) applyMask(oPc, 9140);
                if (iMask == 40) applyMask(oPc, 9165);
                if (iMask == 41) applyMask(oPc, 9190);
                if (iMask == 42) applyMask(oPc, 9215);
                if (iMask == 43) applyMask(oPc, 9240);
                if (iMask == 44) applyMask(oPc, 9265);
                if (iMask == 45) applyMask(oPc, 9290);
                if (iMask == 46) applyMask(oPc, 9315);
                if (iMask == 47) applyMask(oPc, 9340);
                if (iMask == 48) applyMask(oPc, 9365);
                if (iMask == 49) applyMask(oPc, 9390);
                if (iMask == 50) applyMask(oPc, 9415);
                if (iMask == 51) applyMask(oPc, 9440);
                if (iMask == 52) applyMask(oPc, 9465);
                if (iMask == 53) applyMask(oPc, 9490);
            // Sterben
            else if (sMessage == "/sterben") {
                SetLocalInt(oPc, "DYING_FOR_REAL", 0);
                location lStart = GetLocation(GetObjectByTag("WP_DEATH"));
                AssignCommand(oPc, JumpToLocation(lStart));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPc);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPc)), oPc);
                RemoveEffects(oPc);
            // Info
            } else if (sMessage == "/hilfe") {
                SendMessageToPC(oPc, "/afk\n" +
                                    "/geist\n" +
                                    "/unstuck\n" +
                                    "/report\n" +
                                    "/token\n" +
                                    "/familiar\n" +
                                    "/companion\n" +
                                    "/sterben\n" +
                                    "\nCharakter löschen:\n" +
                                    "/delete\n" +
                                    "\nAussehen editieren:\n" +
                                    "/aussehen\n" +
                                    "/rucksack\n" +
                                    "/maske 0-53\n" +
                                    "/pferd 1-4\n" +
                                    "\nWürfel:\n" +
                                    "/d4\n" +
                                    "/d6\n" +
                                    "/d8\n" +
                                    "/d10\n" +
                                    "/d20\n" +
                                    "\nWeitere Übersichten:\n" +
                                    "/hilfe fertigkeit\n" +
                                    "/hilfe animation\n");
            } else if (sMessage == "/hilfe animation") {
                SendMessageToPC(oPc, "Einmalig:\n" +
                                    "/verbeugen\n" +
                                    "/ausweichen\n" +
                                    "/ducken\n" +
                                    "/trinken\n" +
                                    "/winken\n" +
                                    "/strecken\n" +
                                    "/kratzen\n" +
                                    "/lesen\n" +
                                    "/salutieren\n" +
                                    "/jubeln\n" +
                                    "/freuen\n" +
                                    "/anfeuern\n" +
                                    "/zucken\n" +
                                    "/stehlen\n" +
                                    "/nicken\n" +
                                    "/herausfordern\n" +
                                    "\n" +
                                    "Dauerhaft:\n" +
                                    "/sitzen\n" +
                                    "/beten\n" +
                                    "/zaubern\n" +
                                    "/zaubern2\n" +
                                    "/liegen rücken\n" +
                                    "/liegen bauch\n" +
                                    "/aufheben\n" +
                                    "/interagieren\n" +
                                    "/spähen\n" +
                                    "/schwanken\n" +
                                    "/schimpfen\n" +
                                    "/lachen\n" +
                                    "/flehen\n" +
                                    "/reden\n" +
                                    "/anbeten\n" +
                                    "\n" +
                                    "Abfolge:\n" +
                                    "/tanzen\n" +
                                    "/feiern\n" +
                                    "\n" +
                                    "VFX:\n" +
                                    "/rauchen");
            } else if (sMessage == "/hilfe fertigkeit") {
                SendMessageToPC(oPc, "Fertigkeiten können mit beliebigen Attributen gewürfelt werden indem man das entsprechede Kürzel anhängt, zum Beispiel '/akrobatik str'\n\n"+
                                    "Fertigkeiten:\n" +
                                    "/akrobatik\n" +
                                    "/alchemist\n" +
                                    "/arkanes\n" +
                                    "/athletik\n" +
                                    "/auftreten\n" +
                                    "/einschüchtern\n" +
                                    "/entdecken\n" +
                                    "/fingerfertigkeit\n" +
                                    "/heilkunde\n" +
                                    "/konzentration\n" +
                                    "/lauschen\n" +
                                    "/lederer\n" +
                                    "/leisebewegen\n" +
                                    "/magischengegenstandbenutzen\n" +
                                    "/mechanismusausschalten\n" +
                                    "/mittierenumgehen\n" +
                                    "/motiverkennen\n" +
                                    "/natur\n" +
                                    "/religion\n" +
                                    "/schmied\n" +
                                    "/schreiner\n" +
                                    "/täuschen\n" +
                                    "/untersuchen\n" +
                                    "/verstecken\n" +
                                    "/weltliches\n" +
                                    "/überleben\n" +
                                    "/überzeugen\n");
            } else {
                SendMessageToPC(oPc, "Ungültiger Befehl: \"" +
                                     sMessage +
                                     "\" \n\n" +
                                     "/hilfe \n" +
                                     "/hilfe animation \n" +
                                     "/hilfe fertigkeit \n");
            }
        }
    } else {
        if (iChatVolume == 0) {
            // Normal talk
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            //AssignCommand(oPc, ActionSpeakString(sMessage, iChatVolume));

            SetLocalString(oPc, "sMessage", sMessage);
            SetLocalInt(oPc, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oPc);
        } else if (iChatVolume == 1) {
            // Whisper
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            sMessage = "<cvvv>" + sMessage + "</c>";
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            //AssignCommand(oPc, ActionSpeakString(sMessage, iChatVolume));

            SetLocalString(oPc, "sMessage", sMessage);
            SetLocalInt(oPc, "iChatVolume", iChatVolume);
            ExecuteScript("global_speak", oPc);
        } else if (iChatVolume == 2) {
            // Rufen
            sMessage = "<cÃ™Ã™#>" + sMessage + "</c>";
            sMessage = ColorStrings(sMessage, "*", "*", "Ã™Â§`");
            sMessage = ColorStrings(sMessage, "((", "))", "uuu");
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            if (GetIsDM(oPc)) {
                object oPlayer = GetFirstPC();
                while(GetIsObjectValid(oPlayer)) {
                    SendMessageToPC(oPlayer, sMessage);
                    oPlayer = GetNextPC();
                }
            }
        } else if (iChatVolume == 5) {
            // Gruppe
            SetPCChatVolume(TALKVOLUME_SILENT_TALK);
            sMessage = "<cTÃT>" + sMessage + "</c>";
            // Does not work as inteded. Fix incoming
            NWNX_Chat_SendMessage(6, sMessage, oPc, OBJECT_INVALID);

            // Send tells to everyone in the party then
            //NWNX_Chat_SendMessage(4, sMessage, oPc, oPc);
            //object oPartyMember = GetFirstFactionMember(oPc, TRUE);
            //while(GetIsObjectValid(oPartyMember) == TRUE) {
            //    NWNX_Chat_SendMessage(4, sMessage, oPc, oPartyMember);
            //    oPartyMember = GetNextFactionMember(oPc, TRUE);
            //}

            // Send message to DMs
            //object oPlayer = GetFirstPC();
            //while(GetIsObjectValid(oPlayer)) {
            //    if (GetIsDM(oPlayer)) {
            //        NWNX_Chat_SendMessage(4, "(Gruppe): " + sMessage, oPc, oPlayer);
            //    }
            //    oPlayer = GetNextPC();
            //}
        }
    }

    sQuery = "INSERT INTO Chat (name, charname, text, datetime) VALUES (?, ?, ?, ?)";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, sAccountName);
        NWNX_SQL_PreparedString(1, sName);
        if (sFirstChar == ":" && sSecondChar == "1") {
            NWNX_SQL_PreparedString(2, "(" + GetName(GetLocalObject(oPc, "dmspeak1")) + ")" + sMessage);
        } else if (sFirstChar == ":" && sSecondChar == "2") {
            NWNX_SQL_PreparedString(2, "(" + GetName(GetLocalObject(oPc, "dmspeak2")) + ")" + sMessage);
        } else if (sFirstChar == ":" && sSecondChar == "3") {
            NWNX_SQL_PreparedString(2, "(" + GetName(GetLocalObject(oPc, "dmspeak3")) + ")" + sMessage);
        } else if (sFirstChar == ":" && sSecondChar == "4") {
            NWNX_SQL_PreparedString(2, "(" + GetName(GetLocalObject(oPc, "dmspeak4")) + ")" + sMessage);
        } else if (sFirstChar == ":" && sSecondChar == "5") {
            NWNX_SQL_PreparedString(2, "(" + GetName(GetLocalObject(oPc, "dmspeak5")) + ")" + sMessage);
        } else {
            // Mark group chat, and DM chat
            if (iChatVolume == 5) {
                sMessage = "//(Gruppe): " + sMessage;
            }
            NWNX_SQL_PreparedString(2, sMessage);

        }
        NWNX_SQL_PreparedString(3, IntToString(NWNX_Time_GetTimeStamp()));
        NWNX_SQL_ExecutePreparedQuery();
    }

    // DMFI
    //ExecuteScript("dmfi_onplychat",OBJECT_SELF);
}
