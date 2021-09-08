#include "x3_inc_string"
#include "nwnx_time"

// Checks if a player has an item with tag sItem
int iHasItem(string sItem, object oPc) {
    object oItem;
    int nSlot;
    // Check if user has item equipped
    for (nSlot=0; nSlot < NUM_INVENTORY_SLOTS; nSlot++) {
        oItem = GetItemInSlot(nSlot, oPc);
        if (GetTag(oItem) == sItem) {
            return 1;
        }
    }
    // Check if user has item in Inventory
    oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID) {
        if (GetTag(oItem) == sItem) {
            return 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return 0;
}

// Pads an input with digits amounts of zeros in front
string LeadingZeros(string sInput, int digits) {
    int nLen = GetStringLength(sInput);
    int i;
    for (i = 0; i < (digits - nLen); i++) {
        sInput = "0" + sInput;
    }
    return sInput;
}


// Writes a message to all player
void MessageAll(string sMessage) {
    object oPlayer = GetFirstPC();
    while(GetIsObjectValid(oPlayer)) {
        SendMessageToPC(oPlayer, sMessage);
        oPlayer = GetNextPC();
    }
}

// Gets a Waypoint and an NPC and gets the first waypoint
object GetNextWaypoint(object oWp, string sNPC) {
    string sNPCId = GetSubString(sNPC, 4, 100);
    if (GetTag(oWp) == "") {
        return GetObjectByTag("WP_" + sNPCId + "_0001");
    } else {
        string sNumber = GetStringRight(GetTag(oWp), 4);
        sNumber = LeadingZeros(IntToString(StringToInt(sNumber) + 1), 4);
        return GetObjectByTag("WP_" + sNPCId + "_" + sNumber);
    }
}

// Colors said text with ** and (())
string ColorStrings(string sMessage, string sStart, string sEnd, string sColor) {
    // If there are no delimiters, exit
    if (FindSubString(sMessage, sStart) == -1) {
        return sMessage;
    }
    string sNewMessage = "";
    // Beginning delimiter
    string sPart = StringParse(sMessage, sStart);
    sNewMessage = sPart;
    sMessage = StringRemoveParsed(sMessage, sPart, sStart);
    // If there is no closing tag, exit
    if (FindSubString(sMessage, sEnd) == -1) {
        return sNewMessage + sStart + sMessage;
    }
    // Ending delimiter
    sPart = StringParse(sMessage, sEnd);
    sMessage = StringRemoveParsed(sMessage, sPart, sEnd);
    // If there are still delimiters in the string do it again
    sNewMessage = sNewMessage +
        sColor + sStart + sPart + sEnd + "</c>" +
        ColorStrings(sMessage, sStart, sEnd, sColor);
    return sNewMessage;
}

// Colors said text with ** and (())
string ColorStringsOld(string sMessage, string sStart, string sEnd, string sColor) {
    // If there are no delimiters, exit
    if (FindSubString(sMessage, sStart) == -1) {
        return sMessage;
    }
    string sNewMessage = "";
    // Beginning delimiter
    string sPart = StringParse(sMessage, sStart);
    sNewMessage = sPart;
    sMessage = StringRemoveParsed(sMessage, sPart, sStart);
    // If there is no closing tag, exit
    if (FindSubString(sMessage, sEnd) == -1) {
        return sNewMessage + sStart + sMessage;
    }
    // Ending delimiter
    sPart = StringParse(sMessage, sEnd);
    sMessage = StringRemoveParsed(sMessage, sPart, sEnd);
    // If there are still delimiters in the string do it again
    sNewMessage = sNewMessage +
        StringToRGBString(sStart + sPart + sEnd, sColor) +
        ColorStrings(sMessage, sStart, sEnd, sColor);
    return sNewMessage;
}

void RemoveEffectByName(object oPc, string sEffect) {
    effect eEffect = GetFirstEffect(oPc);
    while(GetIsEffectValid(eEffect)) {
        if(GetEffectTag(eEffect) == sEffect) {
            RemoveEffect(oPc, eEffect);
        }
        eEffect = GetNextEffect(oPc);
    }
}

// Rounds a float to digits
float round(float fNumber, int iDecimalPlaces) {
    float mult = IntToFloat(10^iDecimalPlaces);
    return IntToFloat(FloatToInt(fNumber * mult + 0.5)) / mult;
}

int IsANumber(string sInput) {
    if (sInput == "0" ||
        sInput == "1" ||
        sInput == "2" ||
        sInput == "3" ||
        sInput == "4" ||
        sInput == "5" ||
        sInput == "6" ||
        sInput == "7" ||
        sInput == "8" ||
        sInput == "9") {
        return 1;
    }
    return 0;
}

// Gets the content of a token
string GetToken(int iToken) {
    if (iToken <= 0) return "";
    return GetLocalString(GetModule(), "CUSTOM" + IntToString(iToken));
}

void SetCustomTokenEx(int iToken, string sValue)
{
    if (iToken <= 0)
        return;

    // Change the custom token variable and duplicate it.
    SetCustomToken(iToken, sValue);
    SetLocalString(GetModule(), "CUSTOM" + IntToString(iToken), sValue);
}

// Respawn the Ressource at his last location
void respawn(location lLocation, string sResRef, string sTag, object oArea) {
    // Check if we have already been respawned
    if (GetLocalInt(oArea, "area_enter") > NWNX_Time_GetTimeStamp() - 2700) {
        CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLocation, FALSE, sTag);
    }
}
