#include "global_helper"
#include "nwnx_sql"
#include "nwnx_time"
#include "nwnx_admin"
#include "global_smoke"
#include "x3_inc_horse"
#include "nwnx_chat"
#include "x0_i0_position"
#include "nwnx_webhook"
#include "weather_helper"

// CUSTOM SKILL CONSTANTS
// Some constants are predefined in nwscripts.nss
const int SKILL_ANIMAL_HANDLING = 0;
// const int SKILL_CONCENTRATION = 1;
const int SKILL_DISABLE_DEVICE = 2;
// const int SKILL_HEAL = 4;
// const int SKILL_HIDE = 5;
// const int SKILL_LISTEN = 6;
const int SKILL_KNOW_LORE = 7;
// const int SKILL_MOVE_SILENTLY = 8;
const int SKILL_CRAFT_SMITH = 9;
// const int SKILL_PERFORM = 11;
// const int SKILL_PERSUADE = 12;
const int SKILL_SLEIGHT_OF_HAND = 13;
// int SKILL_SEARCH = 14;
const int SKILL_CRAFT_CARPENTER = 15;
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
const int SKILL_CRAFT_ALCHEMIST = 33;
const int SKILL_ATHLETICS = 34;
const int SKILL_SURVIVAL = 35;

object oPc = GetPCChatSpeaker();
int iChatVolume = GetPCChatVolume();
string sQuery;
int iBonus;
int iRand = Random(20) + 1;

int skills(string sMessage, object oPc);

// Setzt einen Würfel wurf zusammen
string printRoll(string sValue, int iRand, int iBonus) {
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
string printRollSkill(string sValue, int iRand, int iBonus, int iAbilityBonus) {
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

void rollSkillsCheck(string sOutput, int iSkill, int iCheckAbility, int iKeyAbility, int iChatVolume, object oPc) {
  int iRand = Random(20) + 1;
  int iBonus = GetSkillRank(iSkill, oPc);
  int iAbilityBonus = GetAbilityModifier(iCheckAbility, oPc);
  string sMessage;
  if (StringToInt(Get2DAString("skills", "Untrained", iSkill)) == 0 && iBonus == 0) {
    sMessage = StringToRGBString("Fertigkeit nicht untrainiert benutzbar.", "333");
  } else {
    sMessage = printRollSkill(sOutput, iRand, iBonus - GetAbilityModifier(iKeyAbility, oPc), iAbilityBonus);
  }
  SetLocalString(oPc, "sMessage", sMessage);
  SetLocalInt(oPc, "iChatVolume", iChatVolume);
  ExecuteScript("global_speak", oPc);
}

void PrintSavingThrow(int iBonus, int iRoll, string sThrow, object oPc, int iChatVolume) {
  string sMessage = "Rettungswurf (" + sThrow + "): " + IntToString(iRoll) + " + " + IntToString(iBonus) + " = " + IntToString(iRoll + iBonus);
  sMessage = StringToRGBString(sMessage, "333");
  SetLocalString(oPc, "sMessage", sMessage);
  SetLocalInt(oPc, "iChatVolume", iChatVolume);
  ExecuteScript("global_speak", oPc);
}

void removeMask(object oPc) {
  effect eEffect = GetFirstEffect(oPc);
  while(GetIsEffectValid(eEffect)) {
    if(GetEffectTag(eEffect) == "eff_maske") {
      RemoveEffect(oPc, eEffect);
    }
    eEffect = GetNextEffect(oPc);
  }

}

// Applies or removes a mask
void applyMask(object oPc, int iVFX) {
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

int setWindFromChat(string sMessage) {
  if (GetIsDM(oPc) && GetSubString(sMessage, 0, 8) == "/setwind") {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    SendMessageToPC(oPc, "Format: /setwind 5 NO");
    string sWindStrength = GetSubString(sMessage, 9, 1);
    string sWindDirection = GetSubString(sMessage, 11, 2);
    if (sWindDirection == "N") sWindDirection = "Nordwind";
    if (sWindDirection == "O") sWindDirection = "Ostwind";
    if (sWindDirection == "S") sWindDirection = "Südwind";
    if (sWindDirection == "W") sWindDirection = "Westwind";
    if (sWindDirection == "SW") sWindDirection = "Südwestwind";
    if (sWindDirection == "NW") sWindDirection = "Nordwestwind";
    if (sWindDirection == "SO") sWindDirection = "Südostwind";
    if (sWindDirection == "NO") sWindDirection = "Nordostwind";
    SendMessageToPC(oPc, "Setze Wind auf " + sWindDirection + " mit Stärke " + sWindStrength);
    SetLocalString(oModule, "sWindDirection", sWindDirection);
    SetLocalInt(oModule, "windstrength", StringToInt(sWindStrength));
    setWindForAreas(StringToInt(sWindStrength));
    return 1;
  }
  return 0;
}

string colorText(string sMessage) {
  sMessage = ColorStrings(sMessage, "*", "*", GetToken(101));
  sMessage = ColorStrings(sMessage, "((", "))", GetToken(102));
  return sMessage;
}

void speak(object oSpeaker, string sMessage) {
  SetPCChatVolume(TALKVOLUME_SILENT_TALK);
  SetLocalString(oSpeaker, "sMessage", sMessage);
  SetLocalInt(oSpeaker, "iChatVolume", iChatVolume);
  ExecuteScript("global_speak", oSpeaker);
}

int speakAsChar(string sMessage) {
  string sFirstChar = GetSubString(sMessage, 0, 1);
  string sSecondChar = GetSubString(sMessage, 1, 1);
  string sSpokenText = GetSubString(sMessage, 3, 10000);
  if (sFirstChar == ":") {
    if (sSecondChar == "1"
        || sSecondChar == "2"
        || sSecondChar == "3"
        || sSecondChar == "4"
        || sSecondChar == "5") {
      object oTarget = GetLocalObject(oPc, "dmspeak" + sSecondChar);
      if (!skills(sSpokenText, oTarget)) {
        speak(oTarget, colorText(sSpokenText));
      }
      return 1;
    }
  }
  return 0;
}

int speakOOC(string sMessage) {
  string sFirstChar = GetSubString(sMessage, 0, 1);
  string sSecondChar = GetSubString(sMessage, 1, 1);
  string sSpokenText = GetSubString(sMessage, 2, 10000);
  if (sFirstChar == "/" && sSecondChar == "/") {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    sMessage = StringToRGBString(sMessage, "333");
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  }
  return 0;
}

int banPlayer(string sMessage) {
  if (GetSubString(sMessage, 0, 5) == "/ban " && GetIsDM(oPc)) {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    string sBanPlayer = GetSubString(sMessage, 5, 1000);
    NWNX_Administration_AddBannedCDKey(sBanPlayer);
    SendMessageToPC(oPc, sBanPlayer + " banned!");
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com",
        NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"),
        GetPCPlayerName(oPc) +
        " hat " +
        sBanPlayer +
        " gebannt!" ,
        "Mintarn");
    return 1;
  }
  return 0;
}

int unbanPlayer(string sMessage) {
  string sUnban = GetSubString(sMessage, 0, 6);
  string sBanPlayer = GetSubString(sMessage, 5, 1000);
  if (sUnban == "/unban" && GetIsDM(oPc)) {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    string sBanPlayer = GetSubString(sMessage, 7, 1000);
    NWNX_Administration_RemoveBannedCDKey(sBanPlayer);
    SendMessageToPC(oPc, sBanPlayer + " unbanned!");
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com",
        NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"),
        GetPCPlayerName(oPc) +
        " hat " +
        sBanPlayer +
        "entbannt!",
        "Mintarn");
    return 1;
  }
  return 0;
}

int listCDKeys(string sMessage) {
  if (sMessage == "/cdkeys" && GetIsDM(oPc)) {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    object oPlayer = GetFirstPC();
    while (GetIsObjectValid(oPlayer) == TRUE) {
      SendMessageToPC(oPc,
          GetPCPlayerName(oPlayer) +
          " (" +
          GetName(oPlayer) +
          "): " +
          GetPCPublicCDKey(oPlayer));
      oPlayer = GetNextPC();
      return 1;
    }
  }
  return 0;
}

int listBannedPlayers(string sMessage) {
  if (sMessage == "/banlist") {
    SendMessageToPC(oPc, NWNX_Administration_GetBannedList());
    return 1;
  }
  return 0;
}

int changeName(string sMessage) {
  if (GetSubString(sMessage, 0, 11) == "/changename") {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    object oTarget = GetLocalObject(oPc, "changename");
    if (oTarget != OBJECT_INVALID) {
      SetName(oTarget, GetSubString(sMessage, 11, 1000));
    }
    return 1;
  }
  return 0;
}

int changeDescription(string sMessage) {
  if (GetSubString(sMessage, 0, 11) == "/changedesc") {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    object oTarget = GetLocalObject(oPc, "changedesc");
    if (oTarget != OBJECT_INVALID) {
      SetName(oTarget, GetSubString(sMessage, 11, 1000));
    }
    return 1;
  }
  return 0;
}

int ride(string sMessage) {
  string sRide= GetSubString(sMessage, 0, 6);
  if (sRide == "/pferd") {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    if (HorseGetIsMounted(oPc)) {
      HorseInstantDismount(oPc);
    } else {
      string sHorse = GetSubString(sMessage, 7, 7);
      if (sHorse == "1" || sHorse == "2" || sHorse == "3" || sHorse == "4") {
        object oHorse = GetObjectByTag("HORSE_" + sHorse);
        HorseInstantMount(oPc, HorseGetMountTail(oHorse));
      }
    }
    return 1;
  }
  return 0;
}

int unstuck(string sMessage) {
  if (sMessage == "/unstuck") {
    vector vCurrentLocation = GetPosition(oPc);
    string sLogMessage = GetName(oPc) +
      " steckt in " +
      GetName(GetArea(oPc)) +
      " ("  +
      FloatToString(vCurrentLocation.x, 6,2) +
      ", " +
      FloatToString(vCurrentLocation.y,6,2) +
      ", " +
      FloatToString(vCurrentLocation.z,6,2) +
      ") fest.";
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com",
        NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"),
        sLogMessage,
        "Mintarn");
    AssignCommand(oPc, JumpToLocation(GetAheadLocation(oPc)));
    return 1;
  }
  return 0;
}

int report(string sMessage) {
  if (GetSubString(sMessage, 0, 7) == "/report" || GetSubString(sMessage, 0, 7) == "/melden") {
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
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
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com",
        NWNX_Util_GetEnvironmentVariable("WEBHOOK_FEHLER"), sLogMessage, "Mintarn", 0);
    SendMessageToPC(oPc, "Vielen Dank für die Fehlermeldung. " +
        "Sie ist im Discord angekommen und wird von uns so bald wie möglich bearbeitet.");
    return 1;
  }
  return 0;
}

int deleteHint(string sMessage) {
  if (sMessage == "/delete") {
    sQuery = "SELECT token FROM Users WHERE name=? AND charname=?";
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    if (NWNX_SQL_PrepareQuery(sQuery)) {
      NWNX_SQL_PreparedString(0, sAccountName);
      NWNX_SQL_PreparedString(1, sName);
      NWNX_SQL_ExecutePreparedQuery();
      NWNX_SQL_ReadNextRow();
      SendMessageToPC(oPc, "Um den Charakter unwiderruflich und endgültig zu löschen /delete " +
          NWNX_SQL_ReadDataInActiveRow(0) + " eingeben.");
    }
    return 1;
  }
  return 0;
}

int delete(string sMessage) {
  if (GetSubString(sMessage, 0, 8) == "/delete ") {
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
    return 1;
  }
  return 0;
}

int emotes(string sMessage) {
  SetPCChatVolume(TALKVOLUME_SILENT_TALK);
  // Emotes
  if (sMessage == "/sit" || sMessage == "/sitzen") {
    AssignCommand( oPc, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 60000.0));
    return 1;
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
    return 1;
  } else if (sMessage == "/worship" || sMessage == "/anbeten") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/bow" || sMessage == "/verbeugen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 1.0));
    return 1;
  } else if (sMessage == "/dodge" || sMessage == "/ausweichen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE, 1.0));
    return 1;
  } else if (sMessage == "/duck" || sMessage == "/ducken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 1.0));
    return 1;
  } else if (sMessage == "/drink" || sMessage == "/trinken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0));
    return 1;
  } else if (sMessage == "/greet" || sMessage == "/winken" || sMessage == "/grüÃŸen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING, 1.0));
    return 1;
  } else if (sMessage == "/bored" || sMessage == "/strecken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0));
    return 1;
  } else if (sMessage == "/scratch" || sMessage == "/kratzen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
    return 1;
  } else if (sMessage == "/read" || sMessage == "/lesen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_READ, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/salute" || sMessage == "/salutieren") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE, 1.0));
    return 1;
  } else if (sMessage == "/spasm" || sMessage == "/zucken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 1.0));
    return 1;
  } else if (sMessage == "/steal" || sMessage == "/stehlen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL, 1.0));
    return 1;
  } else if (sMessage == "/taunt" || sMessage == "/provozieren" || sMessage == "/herausfordern") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0));
    return 1;
  } else if (sMessage == "/victory" || sMessage == "/feiern") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
    return 1;
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
    return 1;
  } else if (sMessage == "/victory1" || sMessage == "/jubeln" || sMessage == "/freuen1") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
    return 1;
  } else if (sMessage == "/victory2" || sMessage == "/freuen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
    return 1;
  } else if (sMessage == "/cheer" || sMessage == "/anfeuern") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
    return 1;
  } else if (sMessage == "/conjure" || sMessage == "/zaubern" || sMessage == "/zaubern1") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/conjure2" || sMessage == "/zaubern2") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/lieback" || sMessage == "/liegen rücken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/feigndeath" || sMessage == "/liegen bauch") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/lift" || sMessage == "/aufheben") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/grab" || sMessage == "/interagieren") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/listen" || sMessage == "/nicken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/look" || sMessage == "/spähen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/drunk" || sMessage == "/schwanken") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/shout" || sMessage == "/schimpfen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/laugh" || sMessage == "/lachen") {
    AssignCommand(oPc,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPc)));
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/plead" || sMessage == "/flehen") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/talk" || sMessage == "/reden") {
    AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL, 1.0, 60000.0));
    return 1;
  } else if (sMessage == "/smoke" || sMessage == "/rauchen") {
    SmokePipe(oPc);
    return 1;
  } else if (sMessage == "/pray" || sMessage == "/beten") {
    if (GetTag(GetArea(oPc)) == "AREA_Nether") {
      location lTempel = GetLocation(GetObjectByTag("WP_TEMPEL"));
      AssignCommand(oPc, JumpToLocation(lTempel));
      string sMessage = "Nach der Reinigung eurer Wunden hat man euch im 'Saal der Klagenden' der Selbstreflektion überlassen; auf dass euer Weg kein weiteres mal hierher führen möge.";
      SendMessageToPC(oPc, sMessage);
      // Health
      //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPc)), oPc);
      //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oPc) - 1), oPc);
      // Negative Level
      if (GetLevelByPosition(0, oPc) + GetLevelByPosition(1, oPc) + GetLevelByPosition(2, oPc) > 1) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectNegativeLevel(1)), oPc, 600.0f);
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
    return 1;
  }
  return 0;
}

int aussehen(string sMessage) {
  if (sMessage == "/aussehen" || sMessage == "/appearance") {
    AssignCommand(oPc, ActionStartConversation(oPc, "aussehen", TRUE));
    return 1;
  }
  return 0;
}

int attributes(string sMessage) {
  if (sMessage == "/charisma" || sMessage == "/cha") {
    iBonus = GetAbilityModifier(ABILITY_CHARISMA, oPc);
    sMessage = printRoll("Charisma", iRand, iBonus);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/constitution" || sMessage == "/konstitution" || sMessage == "/kon" || sMessage == "/con") {
    iBonus = GetAbilityModifier(ABILITY_CONSTITUTION, oPc);
    sMessage = printRoll("Konstitution", iRand, iBonus);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/dexterity" || sMessage == "/geschicklichkeit" || sMessage == "/ges" || sMessage == "/dex") {
    iBonus = GetAbilityModifier(ABILITY_DEXTERITY, oPc);
    sMessage = printRoll("Geschicklichkeit", iRand, iBonus);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/intelligence" || sMessage == "/intelligenz" || sMessage == "/int") {
    iBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPc);
    sMessage = printRoll("Intelligenz", iRand, iBonus);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/strength" || sMessage == "/stärke" || sMessage == "/str") {
    iBonus = GetAbilityModifier(ABILITY_STRENGTH, oPc);
    sMessage = printRoll("Stärke", iRand, iBonus);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/wisdom" || sMessage == "/weisheit" || sMessage == "/wis") {
    iBonus = GetAbilityModifier(ABILITY_WISDOM, oPc);
    sMessage = printRoll("Weisheit", iRand, iBonus);
    speak(oPc, sMessage);
    return 1;
  }
  return 0;
}

int savingThrows(string sMessage) {
  if (sMessage == "/reflex") {
    iBonus = GetReflexSavingThrow(oPc);
    int iRoll = d20();
    PrintSavingThrow(iBonus, iRoll, "Reflex", oPc, iChatVolume);
    return 1;
  } else if (sMessage == "/wille") {
    iBonus = GetWillSavingThrow(oPc);
    int iRoll = d20();
    PrintSavingThrow(iBonus, iRoll, "Wille", oPc, iChatVolume);
    return 1;
  } else if (sMessage == "/zähigkeit") {
    iBonus = GetFortitudeSavingThrow(oPc);
    int iRoll = d20();
    PrintSavingThrow(iBonus, iRoll, "Zähigkeit", oPc, iChatVolume);
    return 1;
  }
  return 0;
}

int skills(string sMessage, object oPc) {
  int iAbilityBonus;
  // Mit Tieren umgehen
  if (sMessage == "/mittierenumgehen") {
    rollSkillsCheck("Mit Tieren umgehen", SKILL_ANIMAL_HANDLING, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mittierenumgehen stärke" || sMessage == "/mittierenumgehen stä" || sMessage == "/mittierenumgehen str") {
    rollSkillsCheck("Mit Tieren umgehen (Stärke)", SKILL_ANIMAL_HANDLING, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mittierenumgehen geschicklichkeit" || sMessage == "/mittierenumgehen ges" || sMessage == "/mittierenumgehen dex") {
    rollSkillsCheck("Mit Tieren umgehen (Gechicklichkeit)", SKILL_ANIMAL_HANDLING, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mittierenumgehen konstitution" || sMessage == "/mittierenumgehen kon" || sMessage == "/mittierenumgehen con") {
    rollSkillsCheck("Mit Tieren umgehen (Konstitution)", SKILL_ANIMAL_HANDLING, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mittierenumgehen intelligenz" || sMessage == "/mittierenumgehen int") {
    rollSkillsCheck("Mit Tieren umgehen (Intelligenz)", SKILL_ANIMAL_HANDLING, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mittierenumgehen weisheit" || sMessage == "/mittierenumgehen wei" || sMessage == "/mittierenumgehen wis") {
    rollSkillsCheck("Mit Tieren umgehen (Weisheit)", SKILL_ANIMAL_HANDLING, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mittierenumgehen charisma" || sMessage == "/mittierenumgehen cha") {
    rollSkillsCheck("Mit Tieren umgehen (Charisma)", SKILL_ANIMAL_HANDLING, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
    // Konzentration
  } else if (sMessage == "/konzentration") {
    rollSkillsCheck("Konzentration", SKILL_CONCENTRATION, ABILITY_CONSTITUTION, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/konzentration stärke" || sMessage == "/konzentration stä" || sMessage == "/konzentration str") {
    rollSkillsCheck("Konzentration (Stärke)", SKILL_CONCENTRATION, ABILITY_STRENGTH, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/konzentration geschicklichkeit" || sMessage == "/konzentration ges" || sMessage == "/konzentration dex") {
    rollSkillsCheck("Konzentration (Gechicklichkeit)", SKILL_CONCENTRATION, ABILITY_DEXTERITY, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/konzentration konstitution" || sMessage == "/konzentration kon" || sMessage == "/konzentration con") {
    rollSkillsCheck("Konzentration (Konstitution)", SKILL_CONCENTRATION, ABILITY_CONSTITUTION, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/konzentration intelligenz" || sMessage == "/konzentration int") {
    rollSkillsCheck("Konzentration (Intelligenz)", SKILL_CONCENTRATION, ABILITY_INTELLIGENCE, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/konzentration weisheit" || sMessage == "/konzentration wei" || sMessage == "/konzentration wis") {
    rollSkillsCheck("Konzentration (Weisheit)", SKILL_CONCENTRATION, ABILITY_WISDOM, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/konzentration charisma" || sMessage == "/konzentration cha") {
    rollSkillsCheck("Konzentration (Charisma)", SKILL_CONCENTRATION, ABILITY_CHARISMA, ABILITY_CONSTITUTION, iChatVolume, oPc);
    return 1;
    // Motiv Erkennen
  } else if (sMessage == "/motiverkennen") {
    rollSkillsCheck("Motiv erkennen", SKILL_SENSE_MOTIVE, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/motiverkennen stärke" || sMessage == "/motiverkennen stä" || sMessage == "/motiverkennen str") {
    rollSkillsCheck("Motiv erkennen (Stärke)", SKILL_SENSE_MOTIVE, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/motiverkennen geschicklichkeit" || sMessage == "/motiverkennen ges" || sMessage == "/motiverkennen dex") {
    rollSkillsCheck("Motiv erkennen (Gechicklichkeit)", SKILL_SENSE_MOTIVE, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/motiverkennen konstitution" || sMessage == "/motiverkennen kon" || sMessage == "/motiverkennen con") {
    rollSkillsCheck("Motiv erkennen (Konstitution)", SKILL_SENSE_MOTIVE, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/motiverkennen intelligenz" || sMessage == "/motiverkennen int") {
    rollSkillsCheck("Motiv erkennen (Intelligenz)", SKILL_SENSE_MOTIVE, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/motiverkennen weisheit" || sMessage == "/motiverkennen wei" || sMessage == "/motiverkennen wis") {
    rollSkillsCheck("Motiv erkennen (Weisheit)", SKILL_SENSE_MOTIVE, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/motiverkennen charisma" || sMessage == "/motiverkennen cha") {
    rollSkillsCheck("Motiv erkennen (Charisma)", SKILL_SENSE_MOTIVE, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
    // Heilkunde
  } else if (sMessage == "/heilkunde") {
    rollSkillsCheck("Heilkunde", SKILL_HEAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/heilkunde stärke" || sMessage == "/heilkunde stä" || sMessage == "/heilkunde str") {
    rollSkillsCheck("Heilkunde (Stärke)", SKILL_HEAL, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/heilkunde geschicklichkeit" || sMessage == "/heilkunde ges" || sMessage == "/heilkunde dex") {
    rollSkillsCheck("Heilkunde (Gechicklichkeit)", SKILL_HEAL, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/heilkunde konstitution" || sMessage == "/heilkunde kon" || sMessage == "/heilkunde con") {
    rollSkillsCheck("Heilkunde (Konstitution)", SKILL_HEAL, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/heilkunde intelligenz" || sMessage == "/heilkunde int") {
    rollSkillsCheck("Heilkunde (Intelligenz)", SKILL_HEAL, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/heilkunde weisheit" || sMessage == "/heilkunde wei" || sMessage == "/heilkunde wis") {
    rollSkillsCheck("Heilkunde (Weisheit)", SKILL_HEAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/heilkunde charisma" || sMessage == "/heilkunde cha") {
    rollSkillsCheck("Heilkunde (Charisma)", SKILL_HEAL, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
    // Verstecken
  } else if (sMessage == "/verstecken") {
    rollSkillsCheck("Verstecken", SKILL_HIDE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/verstecken stärke" || sMessage == "/verstecken stä" || sMessage == "/verstecken str") {
    rollSkillsCheck("Verstecken (Stärke)", SKILL_HIDE, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/verstecken geschicklichkeit" || sMessage == "/verstecken ges" || sMessage == "/verstecken dex") {
    rollSkillsCheck("Verstecken (Gechicklichkeit)", SKILL_HIDE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/verstecken konstitution" || sMessage == "/verstecken kon" || sMessage == "/verstecken con") {
    rollSkillsCheck("Verstecken (Konstitution)", SKILL_HIDE, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/verstecken intelligenz" || sMessage == "/verstecken int") {
    rollSkillsCheck("Verstecken (Intelligenz)", SKILL_HIDE, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/verstecken weisheit" || sMessage == "/verstecken wei" || sMessage == "/verstecken wis") {
    rollSkillsCheck("Verstecken (Weisheit)", SKILL_HIDE, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/verstecken charisma" || sMessage == "/verstecken cha") {
    rollSkillsCheck("Verstecken (Charisma)", SKILL_HIDE, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Lauschen
  } else if (sMessage == "/lauschen") {
    rollSkillsCheck("Lauschen", SKILL_LISTEN, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lauschen stärke" || sMessage == "/lauschen stä" || sMessage == "/lauschen str") {
    rollSkillsCheck("Lauschen (Stärke)", SKILL_LISTEN, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lauschen geschicklichkeit" || sMessage == "/lauschen ges" || sMessage == "/lauschen dex") {
    rollSkillsCheck("Lauschen (Gechicklichkeit)", SKILL_LISTEN, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lauschen konstitution" || sMessage == "/lauschen kon" || sMessage == "/lauschen con") {
    rollSkillsCheck("Lauschen (Konstitution)", SKILL_LISTEN, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lauschen intelligenz" || sMessage == "/lauschen int") {
    rollSkillsCheck("Lauschen (Intelligenz)", SKILL_LISTEN, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lauschen weisheit" || sMessage == "/lauschen wei" || sMessage == "/lauschen wis") {
    rollSkillsCheck("Lauschen (Weisheit)", SKILL_LISTEN, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lauschen charisma" || sMessage == "/lauschen cha") {
    rollSkillsCheck("Lauschen (Charisma)", SKILL_LISTEN, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
    // Wissen: Weltliches
  } else if (sMessage == "/weltliches") {
    rollSkillsCheck("Weltliches", SKILL_KNOW_LORE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/weltliches stärke" || sMessage == "/weltliches stä" || sMessage == "/weltliches str") {
    rollSkillsCheck("Weltliches (Stärke)", SKILL_KNOW_LORE, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/weltliches geschicklichkeit" || sMessage == "/weltliches ges" || sMessage == "/weltliches dex") {
    rollSkillsCheck("Weltliches (Gechicklichkeit)", SKILL_KNOW_LORE, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/weltliches konstitution" || sMessage == "/weltliches kon" || sMessage == "/weltliches con") {
    rollSkillsCheck("Weltliches (Konstitution)", SKILL_KNOW_LORE, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/weltliches intelligenz" || sMessage == "/weltliches int") {
    rollSkillsCheck("Weltliches (Intelligenz)", SKILL_KNOW_LORE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/weltliches weisheit" || sMessage == "/weltliches wei" || sMessage == "/weltliches wis") {
    rollSkillsCheck("Weltliches (Weisheit)", SKILL_KNOW_LORE, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/weltliches charisma" || sMessage == "/weltliches cha") {
    rollSkillsCheck("Weltliches (Charisma)", SKILL_KNOW_LORE, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
    // Leise Bewegen
  } else if (sMessage == "/leisebewegen") {
    rollSkillsCheck("Leise bewegen", SKILL_MOVE_SILENTLY, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/leisebewegen stärke" || sMessage == "/leisebewegen stä" || sMessage == "/leisebewegen str") {
    rollSkillsCheck("Leise bewegen (Stärke)", SKILL_MOVE_SILENTLY, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/leisebewegen geschicklichkeit" || sMessage == "/leisebewegen ges" || sMessage == "/leisebewegen dex") {
    rollSkillsCheck("Leise bewegen (Gechicklichkeit)", SKILL_MOVE_SILENTLY, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/leisebewegen konstitution" || sMessage == "/leisebewegen kon" || sMessage == "/leisebewegen con") {
    rollSkillsCheck("Leise bewegen (Konstitution)", SKILL_MOVE_SILENTLY, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/leisebewegen intelligenz" || sMessage == "/leisebewegen int") {
    rollSkillsCheck("Leise bewegen (Intelligenz)", SKILL_MOVE_SILENTLY, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/leisebewegen weisheit" || sMessage == "/leisebewegen wei" || sMessage == "/leisebewegen wis") {
    rollSkillsCheck("Leise bewegen (Weisheit)", SKILL_MOVE_SILENTLY, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/leisebewegen charisma" || sMessage == "/leisebewegen cha") {
    rollSkillsCheck("Leise bewegen (Charisma)", SKILL_MOVE_SILENTLY, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Mechanismus ausschalten
  } else if (sMessage == "/mechanismusausschalten") {
    rollSkillsCheck("Mechanismus ausschalten", SKILL_DISABLE_DEVICE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mechanismusausschalten stärke" || sMessage == "/mechanismusausschalten stä" || sMessage == "/mechanismusausschalten str") {
    rollSkillsCheck("Mechanismus ausschalten (Stärke)", SKILL_DISABLE_DEVICE, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mechanismusausschalten geschicklichkeit" || sMessage == "/mechanismusausschalten ges" || sMessage == "/mechanismusausschalten dex") {
    rollSkillsCheck("Mechanismus ausschalten (Gechicklichkeit)", SKILL_DISABLE_DEVICE, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mechanismusausschalten konstitution" || sMessage == "/mechanismusausschalten kon" || sMessage == "/mechanismusausschalten con") {
    rollSkillsCheck("Mechanismus ausschalten (Konstitution)", SKILL_DISABLE_DEVICE, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mechanismusausschalten intelligenz" || sMessage == "/mechanismusausschalten int") {
    rollSkillsCheck("Mechanismus ausschalten (Intelligenz)", SKILL_DISABLE_DEVICE, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mechanismusausschalten weisheit" || sMessage == "/mechanismusausschalten wei" || sMessage == "/mechanismusausschalten wis") {
    rollSkillsCheck("Mechanismus ausschalten (Weisheit)", SKILL_DISABLE_DEVICE, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/mechanismusausschalten charisma" || sMessage == "/mechanismusausschalten cha") {
    rollSkillsCheck("Mechanismus ausschalten (Charisma)", SKILL_DISABLE_DEVICE, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Auftreten
  } else if (sMessage == "/auftreten") {
    rollSkillsCheck("Auftreten", SKILL_PERFORM, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/auftreten stärke" || sMessage == "/auftreten stä" || sMessage == "/auftreten str") {
    rollSkillsCheck("Auftreten (Stärke)", SKILL_PERFORM, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/auftreten geschicklichkeit" || sMessage == "/auftreten ges" || sMessage == "/auftreten dex") {
    rollSkillsCheck("Auftreten (Gechicklichkeit)", SKILL_PERFORM, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/auftreten konstitution" || sMessage == "/auftreten kon" || sMessage == "/auftreten con") {
    rollSkillsCheck("Auftreten (Konstitution)", SKILL_PERFORM, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/auftreten intelligenz" || sMessage == "/auftreten int") {
    rollSkillsCheck("Auftreten (Intelligenz)", SKILL_PERFORM, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/auftreten weisheit" || sMessage == "/auftreten wei" || sMessage == "/auftreten wis") {
    rollSkillsCheck("Auftreten (Weisheit)", SKILL_PERFORM, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/auftreten charisma" || sMessage == "/auftreten cha") {
    rollSkillsCheck("Auftreten (Charisma)", SKILL_PERFORM, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
    // Überzeugen
  } else if (sMessage == "/überzeugen") {
    rollSkillsCheck("Überzeugen", SKILL_PERSUADE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überzeugen stärke" || sMessage == "/überzeugen stä" || sMessage == "/überzeugen str") {
    rollSkillsCheck("Überzeugen (Stärke)", SKILL_PERSUADE, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überzeugen geschicklichkeit" || sMessage == "/überzeugen ges" || sMessage == "/überzeugen dex") {
    rollSkillsCheck("Überzeugen (Gechicklichkeit)", SKILL_PERSUADE, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überzeugen konstitution" || sMessage == "/überzeugen kon" || sMessage == "/überzeugen con") {
    rollSkillsCheck("Überzeugen (Konstitution)", SKILL_PERSUADE, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überzeugen intelligenz" || sMessage == "/überzeugen int") {
    rollSkillsCheck("Überzeugen (Intelligenz)", SKILL_PERSUADE, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überzeugen weisheit" || sMessage == "/überzeugen wei" || sMessage == "/überzeugen wis") {
    rollSkillsCheck("Überzeugen (Weisheit)", SKILL_PERSUADE, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überzeugen charisma" || sMessage == "/überzeugen cha") {
    rollSkillsCheck("Überzeugen (Charisma)", SKILL_PERSUADE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
    // Fingerfertigkeit
  } else if (sMessage == "/fingerfertigkeit") {
    rollSkillsCheck("Fingerfertigkeit", SKILL_SLEIGHT_OF_HAND, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/fingerfertigkeit stärke" || sMessage == "/fingerfertigkeit stä" || sMessage == "/fingerfertigkeit str") {
    rollSkillsCheck("Fingerfertigkeit (Stärke)", SKILL_SLEIGHT_OF_HAND, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/fingerfertigkeit geschicklichkeit" || sMessage == "/fingerfertigkeit ges" || sMessage == "/fingerfertigkeit dex") {
    rollSkillsCheck("Fingerfertigkeit (Gechicklichkeit)", SKILL_SLEIGHT_OF_HAND, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/fingerfertigkeit konstitution" || sMessage == "/fingerfertigkeit kon" || sMessage == "/fingerfertigkeit con") {
    rollSkillsCheck("Fingerfertigkeit (Konstitution)", SKILL_SLEIGHT_OF_HAND, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/fingerfertigkeit intelligenz" || sMessage == "/fingerfertigkeit int") {
    rollSkillsCheck("Fingerfertigkeit (Intelligenz)", SKILL_SLEIGHT_OF_HAND, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/fingerfertigkeit weisheit" || sMessage == "/fingerfertigkeit wei" || sMessage == "/fingerfertigkeit wis") {
    rollSkillsCheck("Fingerfertigkeit (Weisheit)", SKILL_SLEIGHT_OF_HAND, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/fingerfertigkeit charisma" || sMessage == "/fingerfertigkeit cha") {
    rollSkillsCheck("Fingerfertigkeit (Charisma)", SKILL_SLEIGHT_OF_HAND, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Untersuchen
  } else if (sMessage == "/untersuchen") {
    rollSkillsCheck("Untersuchen", SKILL_SEARCH, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/untersuchen stärke" || sMessage == "/untersuchen stä" || sMessage == "/untersuchen str") {
    rollSkillsCheck("Untersuchen (Stärke)", SKILL_SEARCH, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/untersuchen geschicklichkeit" || sMessage == "/untersuchen ges" || sMessage == "/untersuchen dex") {
    rollSkillsCheck("Untersuchen (Gechicklichkeit)", SKILL_SEARCH, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/untersuchen konstitution" || sMessage == "/untersuchen kon" || sMessage == "/untersuchen con") {
    rollSkillsCheck("Untersuchen (Konstitution)", SKILL_SEARCH, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/untersuchen intelligenz" || sMessage == "/untersuchen int") {
    rollSkillsCheck("Untersuchen (Intelligenz)", SKILL_SEARCH, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/untersuchen weisheit" || sMessage == "/untersuchen wei" || sMessage == "/untersuchen wis") {
    rollSkillsCheck("Untersuchen (Weisheit)", SKILL_SEARCH, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/untersuchen charisma" || sMessage == "/untersuchen cha") {
    rollSkillsCheck("Untersuchen (Charisma)", SKILL_SEARCH, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
    // Wissen: Natur
  } else if (sMessage == "/natur") {
    rollSkillsCheck("Natur", SKILL_KNOW_NATURE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/natur stärke" || sMessage == "/natur stä" || sMessage == "/natur str") {
    rollSkillsCheck("Natur (Stärke)", SKILL_KNOW_NATURE, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/natur geschicklichkeit" || sMessage == "/natur ges" || sMessage == "/natur dex") {
    rollSkillsCheck("Natur (Gechicklichkeit)", SKILL_KNOW_NATURE, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/natur konstitution" || sMessage == "/natur kon" || sMessage == "/natur con") {
    rollSkillsCheck("Natur (Konstitution)", SKILL_KNOW_NATURE, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/natur intelligenz" || sMessage == "/natur int") {
    rollSkillsCheck("Natur (Intelligenz)", SKILL_KNOW_NATURE, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/natur weisheit" || sMessage == "/natur wei" || sMessage == "/natur wis") {
    rollSkillsCheck("Natur (Weisheit)", SKILL_KNOW_NATURE, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/natur charisma" || sMessage == "/natur cha") {
    rollSkillsCheck("Natur (Charisma)", SKILL_KNOW_NATURE, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
    // Wissen: Arkanes
  } else if (sMessage == "/arkanes") {
    rollSkillsCheck("Arkanes", SKILL_KNOW_ARCANA, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/arkanes stärke" || sMessage == "/arkanes stä" || sMessage == "/arkanes str") {
    rollSkillsCheck("Arkanes (Stärke)", SKILL_KNOW_ARCANA, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/arkanes geschicklichkeit" || sMessage == "/arkanes ges" || sMessage == "/arkanes dex") {
    rollSkillsCheck("Arkanes (Gechicklichkeit)", SKILL_KNOW_ARCANA, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/arkanes konstitution" || sMessage == "/arkanes kon" || sMessage == "/arkanes con") {
    rollSkillsCheck("Arkanes (Konstitution)", SKILL_KNOW_ARCANA, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/arkanes intelligenz" || sMessage == "/arkanes int") {
    rollSkillsCheck("Arkanes (Intelligenz)", SKILL_KNOW_ARCANA, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/arkanes weisheit" || sMessage == "/arkanes wei" || sMessage == "/arkanes wis") {
    rollSkillsCheck("Arkanes (Weisheit)", SKILL_KNOW_ARCANA, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/arkanes charisma" || sMessage == "/arkanes cha") {
    rollSkillsCheck("Arkanes (Charisma)", SKILL_KNOW_ARCANA, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
    // Entdecken
  } else if (sMessage == "/entdecken") {
    rollSkillsCheck("Entdecken", SKILL_SPOT, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/entdecken stärke" || sMessage == "/entdecken stä" || sMessage == "/entdecken str") {
    rollSkillsCheck("Entdecken (Stärke)", SKILL_SPOT, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/entdecken geschicklichkeit" || sMessage == "/entdecken ges" || sMessage == "/entdecken dex") {
    rollSkillsCheck("Entdecken (Gechicklichkeit)", SKILL_SPOT, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/entdecken konstitution" || sMessage == "/entdecken kon" || sMessage == "/entdecken con") {
    rollSkillsCheck("Entdecken (Konstitution)", SKILL_SPOT, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/entdecken intelligenz" || sMessage == "/entdecken int") {
    rollSkillsCheck("Entdecken (Intelligenz)", SKILL_SPOT, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/entdecken weisheit" || sMessage == "/entdecken wei" || sMessage == "/entdecken wis") {
    rollSkillsCheck("Entdecken (Weisheit)", SKILL_SPOT, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/entdecken charisma" || sMessage == "/entdecken cha") {
    rollSkillsCheck("Entdecken (Charisma)", SKILL_SPOT, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
    // Magischen Gegenstand benutzen
  } else if (sMessage == "/magischengegenstandbenutzen") {
    rollSkillsCheck("Magischen Gegenstand benutzen", SKILL_USE_MAGIC_DEVICE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/magischengegenstandbenutzen stärke" || sMessage == "/magischengegenstandbenutzen stä" || sMessage == "/magischengegenstandbenutzen str") {
    rollSkillsCheck("Magischen Gegenstand benutzen (Stärke)", SKILL_USE_MAGIC_DEVICE, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/magischengegenstandbenutzen geschicklichkeit" || sMessage == "/magischengegenstandbenutzen ges" || sMessage == "/magischengegenstandbenutzen dex") {
    rollSkillsCheck("Magischen Gegenstand benutzen (Gechicklichkeit)", SKILL_USE_MAGIC_DEVICE, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/magischengegenstandbenutzen konstitution" || sMessage == "/magischengegenstandbenutzen kon" || sMessage == "/magischengegenstandbenutzen con") {
    rollSkillsCheck("Magischen Gegenstand benutzen (Konstitution)", SKILL_USE_MAGIC_DEVICE, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/magischengegenstandbenutzen intelligenz" || sMessage == "/magischengegenstandbenutzen int") {
    rollSkillsCheck("Magischen Gegenstand benutzen (Intelligenz)", SKILL_USE_MAGIC_DEVICE, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/magischengegenstandbenutzen weisheit" || sMessage == "/magischengegenstandbenutzen wei" || sMessage == "/magischengegenstandbenutzen wis") {
    rollSkillsCheck("Magischen Gegenstand benutzen (Weisheit)", SKILL_USE_MAGIC_DEVICE, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/magischengegenstandbenutzen charisma" || sMessage == "/magischengegenstandbenutzen cha") {
    rollSkillsCheck("Magischen Gegenstand benutzen (Charisma)", SKILL_USE_MAGIC_DEVICE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
    // Wissen: Religion
  } else if (sMessage == "/religion") {
    rollSkillsCheck("Religion", SKILL_KNOW_RELIGION, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/religion stärke" || sMessage == "/religion stä" || sMessage == "/religion str") {
    rollSkillsCheck("Religion (Stärke)", SKILL_KNOW_RELIGION, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/religion geschicklichkeit" || sMessage == "/religion ges" || sMessage == "/religion dex") {
    rollSkillsCheck("Religion (Gechicklichkeit)", SKILL_KNOW_RELIGION, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/religion konstitution" || sMessage == "/religion kon" || sMessage == "/religion con") {
    rollSkillsCheck("Religion (Konstitution)", SKILL_KNOW_RELIGION, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/religion intelligenz" || sMessage == "/religion int") {
    rollSkillsCheck("Religion (Intelligenz)", SKILL_KNOW_RELIGION, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/religion weisheit" || sMessage == "/religion wei" || sMessage == "/religion wis") {
    rollSkillsCheck("Religion (Weisheit)", SKILL_KNOW_RELIGION, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/religion charisma" || sMessage == "/religion cha") {
    rollSkillsCheck("Religion (Charisma)", SKILL_KNOW_RELIGION, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
    // Akrobatik
  } else if (sMessage == "/akrobatik") {
    rollSkillsCheck("Akrobatik", SKILL_ACROBATICS, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/akrobatik stärke" || sMessage == "/akrobatik stä" || sMessage == "/akrobatik str") {
    rollSkillsCheck("Akrobatik (Stärke)", SKILL_ACROBATICS, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/akrobatik geschicklichkeit" || sMessage == "/akrobatik ges" || sMessage == "/akrobatik dex") {
    rollSkillsCheck("Akrobatik (Gechicklichkeit)", SKILL_ACROBATICS, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/akrobatik konstitution" || sMessage == "/akrobatik kon" || sMessage == "/akrobatik con") {
    rollSkillsCheck("Akrobatik (Konstitution)", SKILL_ACROBATICS, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/akrobatik intelligenz" || sMessage == "/akrobatik int") {
    rollSkillsCheck("Akrobatik (Intelligenz)", SKILL_ACROBATICS, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/akrobatik weisheit" || sMessage == "/akrobatik wei" || sMessage == "/akrobatik wis") {
    rollSkillsCheck("Akrobatik (Weisheit)", SKILL_ACROBATICS, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/akrobatik charisma" || sMessage == "/akrobatik cha") {
    rollSkillsCheck("Akrobatik (Charisma)", SKILL_ACROBATICS, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Handwerk: Lederer
  } else if (sMessage == "/lederer") {
    rollSkillsCheck("Lederer", SKILL_CRAFT_LEATHERER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lederer stärke" || sMessage == "/lederer stä" || sMessage == "/lederer str") {
    rollSkillsCheck("Lederer (Stärke)", SKILL_CRAFT_LEATHERER, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lederer geschicklichkeit" || sMessage == "/lederer ges" || sMessage == "/lederer dex") {
    rollSkillsCheck("Lederer (Gechicklichkeit)", SKILL_CRAFT_LEATHERER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lederer konstitution" || sMessage == "/lederer kon" || sMessage == "/lederer con") {
    rollSkillsCheck("Lederer (Konstitution)", SKILL_CRAFT_LEATHERER, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lederer intelligenz" || sMessage == "/lederer int") {
    rollSkillsCheck("Lederer (Intelligenz)", SKILL_CRAFT_LEATHERER, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lederer weisheit" || sMessage == "/lederer wei" || sMessage == "/lederer wis") {
    rollSkillsCheck("Lederer (Weisheit)", SKILL_CRAFT_LEATHERER, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/lederer charisma" || sMessage == "/lederer cha") {
    rollSkillsCheck("Lederer (Charisma)", SKILL_CRAFT_LEATHERER, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Täuschen
  } else if (sMessage == "/täuschen") {
    rollSkillsCheck("Täuschen", SKILL_DECEPTION, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/täuschen stärke" || sMessage == "/täuschen stä" || sMessage == "/täuschen str") {
    rollSkillsCheck("Täuschen (Stärke)", SKILL_DECEPTION, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/täuschen geschicklichkeit" || sMessage == "/täuschen ges" || sMessage == "/täuschen dex") {
    rollSkillsCheck("Täuschen (Gechicklichkeit)", SKILL_DECEPTION, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/täuschen konstitution" || sMessage == "/täuschen kon" || sMessage == "/täuschen con") {
    rollSkillsCheck("Täuschen (Konstitution)", SKILL_DECEPTION, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/täuschen intelligenz" || sMessage == "/täuschen int") {
    rollSkillsCheck("Täuschen (Intelligenz)", SKILL_DECEPTION, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/täuschen weisheit" || sMessage == "/täuschen wei" || sMessage == "/täuschen wis") {
    rollSkillsCheck("Täuschen (Weisheit)", SKILL_DECEPTION, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/täuschen charisma" || sMessage == "/täuschen cha") {
    rollSkillsCheck("Täuschen (Charisma)", SKILL_DECEPTION, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
    // Einschüchtern
  } else if (sMessage == "/einschüchtern") {
    rollSkillsCheck("Einschüchtern", SKILL_INTIMIDATE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/einschüchtern stärke" || sMessage == "/einschüchtern stä" || sMessage == "/einschüchtern str") {
    rollSkillsCheck("Einschüchtern (Stärke)", SKILL_INTIMIDATE, ABILITY_STRENGTH, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/einschüchtern geschicklichkeit" || sMessage == "/einschüchtern ges" || sMessage == "/einschüchtern dex") {
    rollSkillsCheck("Einschüchtern (Gechicklichkeit)", SKILL_INTIMIDATE, ABILITY_DEXTERITY, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/einschüchtern konstitution" || sMessage == "/einschüchtern kon" || sMessage == "/einschüchtern con") {
    rollSkillsCheck("Einschüchtern (Konstitution)", SKILL_INTIMIDATE, ABILITY_CONSTITUTION, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/einschüchtern intelligenz" || sMessage == "/einschüchtern int") {
    rollSkillsCheck("Einschüchtern (Intelligenz)", SKILL_INTIMIDATE, ABILITY_INTELLIGENCE, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/einschüchtern weisheit" || sMessage == "/einschüchtern wei" || sMessage == "/einschüchtern wis") {
    rollSkillsCheck("Einschüchtern (Weisheit)", SKILL_INTIMIDATE, ABILITY_WISDOM, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/einschüchtern charisma" || sMessage == "/einschüchtern cha") {
    rollSkillsCheck("Einschüchtern (Charisma)", SKILL_INTIMIDATE, ABILITY_CHARISMA, ABILITY_CHARISMA, iChatVolume, oPc);
    return 1;
    // Handwerk: Schmied
  } else if (sMessage == "/schmied") {
    rollSkillsCheck("Schmied", SKILL_CRAFT_SMITH, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schmied stärke" || sMessage == "/schmied stä" || sMessage == "/schmied str") {
    rollSkillsCheck("Schmied (Stärke)", SKILL_CRAFT_SMITH, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schmied geschicklichkeit" || sMessage == "/schmied ges" || sMessage == "/schmied dex") {
    rollSkillsCheck("Schmied (Gechicklichkeit)", SKILL_CRAFT_SMITH, ABILITY_DEXTERITY, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schmied konstitution" || sMessage == "/schmied kon" || sMessage == "/schmied con") {
    rollSkillsCheck("Schmied (Konstitution)", SKILL_CRAFT_SMITH, ABILITY_CONSTITUTION, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schmied intelligenz" || sMessage == "/schmied int") {
    rollSkillsCheck("Schmied (Intelligenz)", SKILL_CRAFT_SMITH, ABILITY_INTELLIGENCE, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schmied weisheit" || sMessage == "/schmied wei" || sMessage == "/schmied wis") {
    rollSkillsCheck("Schmied (Weisheit)", SKILL_CRAFT_SMITH, ABILITY_WISDOM, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schmied charisma" || sMessage == "/schmied cha") {
    rollSkillsCheck("Schmied (Charisma)", SKILL_CRAFT_SMITH, ABILITY_CHARISMA, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
    // Handwerk: Schreiner
  } else if (sMessage == "/schreiner") {
    rollSkillsCheck("Schreiner", SKILL_CRAFT_CARPENTER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schreiner stärke" || sMessage == "/schreiner stä" || sMessage == "/schreiner str") {
    rollSkillsCheck("Schreiner (Stärke)", SKILL_CRAFT_CARPENTER, ABILITY_STRENGTH, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schreiner geschicklichkeit" || sMessage == "/schreiner ges" || sMessage == "/schreiner dex") {
    rollSkillsCheck("Schreiner (Gechicklichkeit)", SKILL_CRAFT_CARPENTER, ABILITY_DEXTERITY, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schreiner konstitution" || sMessage == "/schreiner kon" || sMessage == "/schreiner con") {
    rollSkillsCheck("Schreiner (Konstitution)", SKILL_CRAFT_CARPENTER, ABILITY_CONSTITUTION, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schreiner intelligenz" || sMessage == "/schreiner int") {
    rollSkillsCheck("Schreiner (Intelligenz)", SKILL_CRAFT_CARPENTER, ABILITY_INTELLIGENCE, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schreiner weisheit" || sMessage == "/schreiner wei" || sMessage == "/schreiner wis") {
    rollSkillsCheck("Schreiner (Weisheit)", SKILL_CRAFT_CARPENTER, ABILITY_WISDOM, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/schreiner charisma" || sMessage == "/schreiner cha") {
    rollSkillsCheck("Schreiner (Charisma)", SKILL_CRAFT_CARPENTER, ABILITY_CHARISMA, ABILITY_DEXTERITY, iChatVolume, oPc);
    return 1;
    // Handwerk: Alchemie
  } else if (sMessage == "/alchemist") {
    rollSkillsCheck("Alchemie", SKILL_CRAFT_ALCHEMIST, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/alchemist stärke" || sMessage == "/alchemist stä" || sMessage == "/alchemist str") {
    rollSkillsCheck("Alchemie (Stärke)", SKILL_CRAFT_ALCHEMIST, ABILITY_STRENGTH, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/alchemist geschicklichkeit" || sMessage == "/alchemist ges" || sMessage == "/alchemist dex") {
    rollSkillsCheck("Alchemie (Gechicklichkeit)", SKILL_CRAFT_ALCHEMIST, ABILITY_DEXTERITY, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/alchemist konstitution" || sMessage == "/alchemist kon" || sMessage == "/alchemist con") {
    rollSkillsCheck("Alchemie (Konstitution)", SKILL_CRAFT_ALCHEMIST, ABILITY_CONSTITUTION, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/alchemist intelligenz" || sMessage == "/alchemist int") {
    rollSkillsCheck("Alchemie (Intelligenz)", SKILL_CRAFT_ALCHEMIST, ABILITY_INTELLIGENCE, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/alchemist weisheit" || sMessage == "/alchemist wei" || sMessage == "/alchemist wis") {
    rollSkillsCheck("Alchemie (Weisheit)", SKILL_CRAFT_ALCHEMIST, ABILITY_WISDOM, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/alchemist charisma" || sMessage == "/alchemist cha") {
    rollSkillsCheck("Alchemie (Charisma)", SKILL_CRAFT_ALCHEMIST, ABILITY_CHARISMA, ABILITY_INTELLIGENCE, iChatVolume, oPc);
    return 1;
    // Athletik
  } else if (sMessage == "/athletik") {
    rollSkillsCheck("Athletik", SKILL_ATHLETICS, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/athletik stärke" || sMessage == "/athletik stä" || sMessage == "/athletik str") {
    rollSkillsCheck("Athletik (Stärke)", SKILL_ATHLETICS, ABILITY_STRENGTH, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/athletik geschicklichkeit" || sMessage == "/athletik ges" || sMessage == "/athletik dex") {
    rollSkillsCheck("Athletik (Gechicklichkeit)", SKILL_ATHLETICS, ABILITY_DEXTERITY, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/athletik konstitution" || sMessage == "/athletik kon" || sMessage == "/athletik con") {
    rollSkillsCheck("Athletik (Konstitution)", SKILL_ATHLETICS, ABILITY_CONSTITUTION, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/athletik intelligenz" || sMessage == "/athletik int") {
    rollSkillsCheck("Athletik (Intelligenz)", SKILL_ATHLETICS, ABILITY_INTELLIGENCE, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/athletik weisheit" || sMessage == "/athletik wei" || sMessage == "/athletik wis") {
    rollSkillsCheck("Athletik (Weisheit)", SKILL_ATHLETICS, ABILITY_WISDOM, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/athletik charisma" || sMessage == "/athletik cha") {
    rollSkillsCheck("Athletik (Charisma)", SKILL_ATHLETICS, ABILITY_CHARISMA, ABILITY_STRENGTH, iChatVolume, oPc);
    return 1;
    // Überleben
  } else if (sMessage == "/überleben") {
    rollSkillsCheck("Überleben", SKILL_SURVIVAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überleben stärke" || sMessage == "/Überleben stä" || sMessage == "/Überleben str") {
    rollSkillsCheck("Überleben (Stärke)", SKILL_SURVIVAL, ABILITY_STRENGTH, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überleben geschicklichkeit" || sMessage == "/Überleben ges" || sMessage == "/Überleben dex") {
    rollSkillsCheck("Überleben (Gechicklichkeit)", SKILL_SURVIVAL, ABILITY_DEXTERITY, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überleben konstitution" || sMessage == "/Überleben kon" || sMessage == "/Überleben con") {
    rollSkillsCheck("Überleben (Konstitution)", SKILL_SURVIVAL, ABILITY_CONSTITUTION, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überleben intelligenz" || sMessage == "/Überleben int") {
    rollSkillsCheck("Überleben (Intelligenz)", SKILL_SURVIVAL, ABILITY_INTELLIGENCE, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überleben weisheit" || sMessage == "/Überleben wei" || sMessage == "/Überleben wis") {
    rollSkillsCheck("Überleben (Weisheit)", SKILL_SURVIVAL, ABILITY_WISDOM, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/überleben charisma" || sMessage == "/Überleben cha") {
    rollSkillsCheck("Überleben (Charisma)", SKILL_SURVIVAL, ABILITY_CHARISMA, ABILITY_WISDOM, iChatVolume, oPc);
    return 1;
  } else if (sMessage == "/wissenbarde") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPc);
    sMessage = printRollSkill("Wissen: Barde", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  } else if (sMessage == "/wissenbarde stärke" || sMessage == "/wissenbarde stä" || sMessage == "/wissenbarde str") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_STRENGTH, oPc);
    sMessage = printRollSkill("Wissen: Barde (STR)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  } else if (sMessage == "/wissenbarde geschicklichkeit" || sMessage == "/wissenbarde ges" || sMessage == "/wissenbarde dex") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_DEXTERITY, oPc);
    sMessage = printRollSkill("Wissen: Barde (DEX)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  } else if (sMessage == "/wissenbarde konstitution" || sMessage == "/wissenbarde kon" || sMessage == "/wissenbarde con") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_CONSTITUTION, oPc);
    sMessage = printRollSkill("Wissen: Barde (CON)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  } else if (sMessage == "/wissenbarde intelligenz" || sMessage == "/wissenbarde int") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPc);
    sMessage = printRollSkill("Wissen: Barde (Intelligenz)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  } else if (sMessage == "/wissenbarde weisheit" || sMessage == "/wissenbarde wei" || sMessage == "/wissenbarde wis") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_WISDOM, oPc);
    sMessage = printRollSkill("Wissen: Barde (WIS)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  } else if (sMessage == "/wissenbarde charisma" || sMessage == "/wissenbarde cha") {
    iBonus = GetSkillRank(27, oPc);
    iAbilityBonus = GetAbilityModifier(ABILITY_CHARISMA, oPc);
    sMessage = printRollSkill("Wissen: Barde (Charisma)", iRand, iBonus - GetAbilityModifier(ABILITY_INTELLIGENCE, oPc), iAbilityBonus);
    SetLocalString(oPc, "sMessage", sMessage);
    SetLocalInt(oPc, "iChatVolume", iChatVolume);
    ExecuteScript("global_speak", oPc);
    return 1;
  }
  return 0;
}

int rolls(string sMessage) {
  if (sMessage == "/d4") {
    sMessage = printRoll("d4", Random(4) + 1, 0);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/d6") {
    sMessage = printRoll("d6", Random(6) + 1, 0);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/d8") {
    sMessage = printRoll("d8", Random(8) + 1, 0);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/d10") {
    sMessage = printRoll("d10", Random(10) + 1, 0);
    speak(oPc, sMessage);
    return 1;
  } else if (sMessage == "/d20") {
    sMessage = printRoll("d20", Random(20) + 1, 0);
    speak(oPc, sMessage);
    return 1;
  }
  return 0;
}

int familiar(string sMessage) {
  if (sMessage == "/familiar" || sMessage == "/vertrauter") {
    SummonFamiliar(oPc);
    return 1;
  }
  return 0;
}

int companion(string sMessage) {
  if (sMessage == "/companion" || sMessage == "/begleiter") {
    SummonAnimalCompanion(oPc);
    return 1;
  }
  return 0;
}

int token(string sMessage) {
  if (sMessage == "/token") {
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
    return 1;
  }
  return 0;
}

int hindurchzwaengen(string sMessage) {
  if (sMessage == "/hindurchzwängen") {
    if (GetTag(GetArea(oPc)) == "AREA_Unterschlupf") {
      location lUnterschlupf = GetLocation(GetObjectByTag("WP_UNTERSCHLUPF"));
      DelayCommand(0.0, AssignCommand(oPc, JumpToLocation(lUnterschlupf)));
      return 1;
    }
  }
  return 0;
}

int phenotype(string sMessage) {
  if (sMessage == "/phenotype 0") {
    SetPhenoType(0, oPc);
    return 1;
  } else if (sMessage == "/phenotype 1") {
    SetPhenoType(1, oPc);
    return 1;
  }
  return 0;
}

int afk(string sMessage) {
  if (sMessage == "/afk") {
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
    return 1;
  }
  return 0;
}

int ghost(string sMessage) {
  if (sMessage == "/geist" || sMessage == "/ghost") {
    effect eGhost = EffectCutsceneGhost();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(eGhost), "GHOST"), oPc);
    SendMessageToPC(oPc, "Geist Modus für eine Minute angeschaltet.");
    DelayCommand(60.0f, RemoveEffectByName(oPc, "GHOST"));
    return 1;
  }
  return 0;
}

int climb(string sMessage) {
  if (sMessage == "/klettern" || sMessage == "/climb") {
    if (GetTag(GetArea(oPc)) == "AREA_Freihafen" && GetDistanceBetween(oPc, GetObjectByTag("KLETTERN_Tempel")) < 2.0) {
      location lLocation = GetLocation(GetObjectByTag("KLETTERN_Tempel2"));
      DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lLocation)));
    }
    if (GetTag(GetArea(oPc)) == "AREA_Freihafen" && GetDistanceBetween(oPc, GetObjectByTag("KLETTERN_Tempel2")) < 2.0) {
      location lLocation = GetLocation(GetObjectByTag("KLETTERN_Tempel"));
      DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lLocation)));
    }
    return 1;
  }
  return 0;
}

int backpack(string sMessage) {
  if (sMessage == "/rucksack" || sMessage == "/backpack") {
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
    return 1;
  }
  return 0;
}

int masks(string sMessage) {
  if (GetSubString(sMessage, 0, 6) == "/maske") {
    int iMask = StringToInt(GetSubString(sMessage, 7, 2));
    removeMask(oPc);
    if (GetSubString(sMessage, 7, 2) != "") {
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
    }
    return 1;
  }
  return 0;
}

int die(string sMessage) {
  if (sMessage == "/sterben") {
    SetLocalInt(oPc, "DYING_FOR_REAL", 0);
    location lStart = GetLocation(GetObjectByTag("WP_DEATH"));
    AssignCommand(oPc, JumpToLocation(lStart));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPc);
    RemoveEffects(oPc);
    return 1;
  }
  return 0;
}

int time(string sMessage) {
  if (sMessage == "/zeit") {
    SendMessageToPC(oPc, GetToken(102) + "Es ist " + LeadingZeros(IntToString(GetTimeHour()), 2) + ":" + LeadingZeros(IntToString(GetTimeMinute()), 2)  + " Uhr.</c>");
    return 1;
  }
  return 0;
}

int settime(string sMessage) {
  if (GetSubString(sMessage, 0, 9) == "/settime " && GetIsDM(oPc)) {
    if (IsANumber(GetSubString(sMessage, 9, 1)) && IsANumber(GetSubString(sMessage, 10, 1)) && IsANumber(GetSubString(sMessage, 12, 1)) && IsANumber(GetSubString(sMessage, 13, 1))) {
      SetTime(StringToInt(GetSubString(sMessage, 9, 2)), StringToInt(GetSubString(sMessage, 12, 2)), 0, 0);
      SendMessageToPC(oPc, GetToken(102) + "Es ist " + LeadingZeros(IntToString(GetTimeHour()), 2) + ":" + LeadingZeros(IntToString(GetTimeMinute()), 2)  + " Uhr.</c>");
    } else {
      SendMessageToPC(oPc, "Muss das Format \"/settime 20:00\" haben.");
    }
    return 1;
  }
  return 0;
}

int initiative(string sMessage) {
  if (sMessage == "/initiative") {
    int iInitiativeRoll = d20();
    sMessage = GetToken(102) + "Initiative (d20 + Dex): [" +
      IntToString(iInitiativeRoll) +
      " + " + IntToString(GetAbilityModifier(ABILITY_DEXTERITY, oPc)) +
      "] = " +
      IntToString(iInitiativeRoll + GetAbilityModifier(ABILITY_DEXTERITY, oPc)) +
      "</c>";
    speak(oPc, sMessage);
    return 1;
  }
  return 0;
}

int speakDMArea(string sMessage) {
  if (GetSubString(sMessage, 0, 3) == "/g ") {
    sMessage = GetSubString(sMessage, 2, 10000);
    sMessage = GetToken(104) + sMessage + "</c>";
    sMessage = ColorStrings(sMessage, "*", "*", GetToken(101));
    sMessage = ColorStrings(sMessage, "((", "))", GetToken(102));
    if (GetIsDM(oPc) || GetIsDM(GetMaster(oPc)) || GetIsDMPossessed(oPc)) {
      SendMessageToPC(oPc, "Folgende Spieler haben euch im Gebiet vernommen:");
      SendMessageToAllDMs("Erzähler (/g)[" + GetTag(GetArea(oPc)) + "]: " + sMessage);
      object oTalkTo = GetFirstPC();
      while (oTalkTo != OBJECT_INVALID) {
        if (GetArea(oTalkTo) == GetArea(oPc)) {
          if (!GetIsDM(oTalkTo)) {
            NWNX_Chat_SendMessage(4, sMessage, GetObjectByTag("ERZAEHLER"), oTalkTo);
          }
          SendMessageToPC(oPc, GetName(oTalkTo));
        }
        oTalkTo = GetNextPC();
      }
    }
    return 1;
  }
  return 0;
}

int speakDMServer(string sMessage) {
  if (GetSubString(sMessage, 0, 3) == "/a ") {
    sMessage = GetSubString(sMessage, 2, 10000);
    sMessage = GetToken(104) + sMessage + "</c>";
    sMessage = ColorStrings(sMessage, "*", "*", GetToken(101));
    sMessage = ColorStrings(sMessage, "((", "))", GetToken(102));
    if (GetIsDM(oPc) || GetIsDM(GetMaster(oPc)) || GetIsDMPossessed(oPc)) {
      SendMessageToPC(oPc, "Folgende Spieler haben euch auf dem Server vernommen:");
      SendMessageToAllDMs("Erzähler (/a): " + sMessage);
      object oTalkTo = GetFirstPC();
      while (oTalkTo != OBJECT_INVALID) {
        if (!GetIsDM(oTalkTo)) {
          NWNX_Chat_SendMessage(4, sMessage, GetObjectByTag("ERZAEHLER"), oTalkTo);
        }
        SendMessageToPC(oPc, GetName(oTalkTo));
        oTalkTo = GetNextPC();
      }
    }
    return 1;
  }
  return 0;
}

int help(string sMessage) {
  if (sMessage == "/hilfe") {
    SendMessageToPC(oPc, "/afk\n" +
        "/geist\n" +
        "/unstuck\n" +
        "/report\n" +
        "/token\n" +
        "/familiar\n" +
        "/companion\n" +
        "/sterben\n" +
        "/zeit\n" +
        "/initiative" +
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
        "/hilfe maske\n" +
        "/hilfe rettungswurf\n" +
        "/hilfe animation\n");
    return 1;
  }
  return 0;
}

int helpSavingThrows(string sMessage) {
  if (sMessage == "/hilfe rettungswurf") {
    SendMessageToPC(oPc, "/reflex\n/wille\n/zähigkeit\n");
    return 1;
  }
  return 0;
}

int helpAnimation(string sMessage) {
  if (sMessage == "/hilfe animation") {
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
    return 1;
  }
  return 0;
}

int helpSkills(string sMessage) {
  if (sMessage == "/hilfe fertigkeit") {
    SendMessageToPC(oPc, "Fertigkeiten können mit beliebigen Attributen gewürfelt werden indem man das entsprechede Kürzel anhängt, zum Beispiel '/akrobatik str'\n\n"+
        "Fertigkeiten:\n" +
        "/akrobatik\n" +
        "/alchemist\n" +
        "/arkanes\n" +
        "/athletik\n" +
        "/auftreten\n" +
        "/bardenwissen\n" +
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
        "/überleben\n" +
        "/überzeugen\n" +
        "/untersuchen\n" +
        "/verstecken\n" +
        "/weltliches\n");
    return 1;
  }
  return 0;
}

int helpMasks(string sMessage) {
  if (sMessage == "/hilfe maske") {
    SendMessageToPC(oPc, "/maske 0: brauner Dreispitz\n" +
        "/maske 1: brauner Dreispitz\n" +
        "/maske 2: brauner Piratenhut\n" +
        "/maske 3: schwarzer Dreispitz\n" +
        "/maske 4: schwarzer Piratenhut\n" +
        "/maske 5: hellbrauner Dreispitz\n" +
        "/maske 6: hellbrauner Piratenhut\n" +
        "/maske 7: dunkelrotes Bandana\n" +
        "/maske 8: schwarzes Bandana\n" +
        "/maske 9: blaues Bandana\n" +
        "/maske 10: braunes Bandana\n" +
        "/maske 11: Helm\n" +
        "/maske 12: Helm\n" +
        "/maske 13: Helm\n" +
        "/maske 14: Helm\n" +
        "/maske 15: Helm\n" +
        "/maske 16: Helm\n" +
        "/maske 17: Helm\n" +
        "/maske 18: Helm\n" +
        "/maske 19: Helm\n" +
        "/maske 20: Helm\n" +
        "/maske 21: Helm\n" +
        "/maske 22: Helm\n" +
        "/maske 23: Kapuze\n" +
        "/maske 24: Kapuze\n" +
        "/maske 25: Kapuze\n" +
        "/maske 26: Kapuze\n" +
        "/maske 27: Kapuze\n" +
        "/maske 28: Kapuze\n" +
        "/maske 29: Kapuze\n" +
        "/maske 30: Kapuze\n" +
        "/maske 31: Kapuze\n" +
        "/maske 32: Kapuze\n" +
        "/maske 33: Kapuze\n" +
        "/maske 34: Kapuze\n" +
        "/maske 35: Kapuze\n" +
        "/maske 36: Kapuze\n" +
        "/maske 37: Kapuze\n" +
        "/maske 38: Kapuze\n" +
        "/maske 39: Kapuze\n" +
        "/maske 40: Kapuze\n" +
        "/maske 41: Kapuze\n" +
        "/maske 42: Kapuze\n" +
        "/maske 43: Kapuze\n" +
        "/maske 44: Kapuze\n" +
        "/maske 45: Kapuze\n" +
        "/maske 46: Kapuze\n" +
        "/maske 47: Stirnreif\n" +
        "/maske 48: Stirnreif\n" +
        "/maske 49: Stirnreif\n" +
        "/maske 50: Ballmaske\n" +
        "/maske 51: Ballmaske\n" +
        "/maske 52: Ballmaske\n" +
        "/maske 53: Ballmaske\n");
    return 1;
  }
  return 0;
}

// Chat befehle
void main() {
  string sMessage = GetPCChatMessage();
  string sAccountName = GetPCPlayerName(oPc);
  string sName = GetName(oPc);
  string sFirstChar = GetSubString(sMessage, 0, 1);
  string sSecondChar = GetSubString(sMessage, 1, 1);
  string sBan = GetSubString(sMessage, 0, 4);
  string sUnban = GetSubString(sMessage, 0, 6);
  string sPferd= GetSubString(sMessage, 0, 4);

  if (GetSubString(sMessage, 0, 1) == ":" || GetSubString(sMessage, 0, 1) == "/") {
    if (speakAsChar(sMessage) ||
        speakOOC(sMessage) || 
        banPlayer(sMessage) ||
        unbanPlayer(sMessage) ||
        listCDKeys(sMessage) ||
        listBannedPlayers(sMessage) ||
        changeName(sMessage) ||
        changeDescription(sMessage) ||
        ride(sMessage) ||
        unstuck(sMessage) ||
        report(sMessage) ||
        setWindFromChat(sMessage) ||
        deleteHint(sMessage) ||
        delete(sMessage) ||
        emotes(sMessage) ||
        aussehen(sMessage) ||
        attributes(sMessage) ||
        savingThrows(sMessage) ||
        skills(sMessage, oPc) ||
        rolls(sMessage) ||
        familiar(sMessage) ||
        companion(sMessage) ||
        token(sMessage) ||
        hindurchzwaengen(sMessage) ||
        phenotype(sMessage) ||
        afk(sMessage) ||
        ghost(sMessage) ||
        climb(sMessage) ||
        backpack(sMessage) ||
        masks(sMessage) ||
        die(sMessage) ||
        time(sMessage) ||
        settime(sMessage) ||
        initiative(sMessage) ||
        speakDMArea(sMessage) ||
        speakDMServer(sMessage) ||
        help(sMessage) ||
        helpSavingThrows(sMessage) ||
        helpAnimation(sMessage) ||
        helpSkills(sMessage) ||
        helpMasks(sMessage)) {
  } else {
    SendMessageToPC(oPc, "Ungültiger Befehl: \"" +
        sMessage +
        "\" \n\n" +
        "/hilfe \n" +
        "/hilfe animation \n" +
        "/hilfe fertigkeit \n");
  }
} else {
  if (iChatVolume == 0) {
    // Normal talk
    sMessage = ColorStrings(sMessage, "*", "*", GetToken(101));
    sMessage = ColorStrings(sMessage, "((", "))", GetToken(102));
    SetPCChatMessage(sMessage);
  } else if (iChatVolume == 1) {
    // Whisper
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    sMessage = GetToken(103) + sMessage + "</c>";
    sMessage = ColorStrings(sMessage, "*", "*", GetToken(101));
    sMessage = ColorStrings(sMessage, "((", "))", GetToken(102));
    SetPCChatMessage(sMessage);
  } else if (iChatVolume == 2) { //
    // Shout
    sMessage = GetToken(104) + sMessage + "</c>";
    sMessage = ColorStrings(sMessage, "*", "*", GetToken(101));
    sMessage = ColorStrings(sMessage, "((", "))", GetToken(102));
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    //SetPCChatMessage(sMessage);
    if (GetIsDM(oPc) || GetIsDM(GetMaster(oPc)) || GetIsDMPossessed(oPc)) {
      SendMessageToPC(oPc, "Folgende Spieler im 50 Meter Radius haben euch vernommen:");
      SendMessageToAllDMs("Erzähler (/s)[" + GetTag(GetArea(oPc)) + "]: " + sMessage);
      object oTalkTo = GetFirstPC();
      while (oTalkTo != OBJECT_INVALID) {
        if (GetArea(oTalkTo) == GetArea(oPc) && GetDistanceBetween(oTalkTo, oPc) < 50.0) {
          if (!GetIsDM(oTalkTo)) {
            NWNX_Chat_SendMessage(4, sMessage, GetObjectByTag("ERZAEHLER"), oTalkTo);
          }
          SendMessageToPC(oPc, GetName(oTalkTo));
        }
        oTalkTo = GetNextPC();
      }
    }
  } else if (iChatVolume == 4) {
    SendMessageToPC(oPc, GetToken(102) + "DM: " + sMessage + "</c>");
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_DM"), GetPCPlayerName(oPc) + " - " + GetName(oPc) + ": " + sMessage);
  } else if (iChatVolume == 5) {
    // Gruppe
    SetPCChatVolume(TALKVOLUME_SILENT_TALK);
    sMessage = GetToken(104) + sMessage + "</c>";
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
}
