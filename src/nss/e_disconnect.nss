#include "nwnx_webhook"
#include "nwnx_util"

void DestroyAllObjectsInInventory(object Chest) {
    object oItem = GetFirstItemInInventory(Chest);
    while (oItem != OBJECT_INVALID) {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(Chest);
    }
}

// Cleans up if a player crashed or disconnected with alt+f4
void main() {
    object oPc = OBJECT_SELF;
    string PlayerID = GetPCPublicCDKey(oPc);
    string sAccountName = GetPCPlayerName(oPc);
    string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_MODULE");
    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " ist gecrasht.", "Mintarn");
    object oArea = GetFirstArea();
    while (GetIsObjectValid(oArea)) {
        object oObject = GetFirstObjectInArea(oArea);
        while(GetIsObjectValid(oObject)) {
             if(GetTag(oObject) == "PERSITENT_CHEST") {
                if (GetLocalString(oObject, "OPENEDBY") == PlayerID) {
                    DestroyAllObjectsInInventory(oObject);
                    SetLocalInt(oObject, "OPEN", 0);
                }
             }
             oObject = GetNextObjectInArea(oArea);
        }
        oArea = GetNextArea();
    }
}
