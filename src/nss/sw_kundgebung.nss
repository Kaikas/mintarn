#include "global_helper"
#include "nwnx_webhook"
#include "nwnx_util"

void main() {
    object oPc = GetLastUsedBy();
    // Prevent spam
    if (GetLocalInt(oPc, "KUNDGEBUNG") == 0) {
        SetLocalInt(oPc, "KUNDGEBUNG", 1);
        DelayCommand(600.0f, SetLocalInt(oPc, "KUNDGEBUNG", 0));

        string sMessage = "";
        if (GetTag(OBJECT_SELF) == "RP_ZumRettendenUfer") {
            sMessage = GetToken(102) + GetName(oPc) + " sucht bei der Taverne \"Zum Rettenden Ufer\" nach Rollenspiel.</c>";

            string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_OOC");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, GetName(oPc) + " sucht bei der Taverne Zum Rettenden Ufer nach Rollenspiel.");
        }
        if (GetTag(OBJECT_SELF) == "RP_Hain") {
            sMessage = GetToken(102) + GetName(oPc) + " sucht im versteckten Hain nach Rollenspiel.</c>";

            string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_OOC");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, GetName(oPc) + " sucht im versteckten Hain nach Rollenspiel.");
        }
        if (GetTag(OBJECT_SELF) == "RP_Aussenposten") {
            sMessage = GetToken(102) + GetName(oPc) + " sucht am Auﬂenposten nach Rollenspiel.</c>";

            string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_OOC");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, GetName(oPc) + " sucht am Auﬂenposten nach Rollenspiel.");
        }
        if (GetTag(OBJECT_SELF) == "RP_Holzfaeller") {
            sMessage = GetToken(102) + GetName(oPc) + " sucht am Holzf‰llerlager nach Rollenspiel.</c>";

            string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_OOC");
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, GetName(oPc) + " sucht am Holzf‰llerlager nach Rollenspiel.");
        }

        object oTarget = GetFirstPC();
        while (oTarget != OBJECT_INVALID) {
            SendMessageToPC(oTarget, sMessage);
            oTarget = GetNextPC();
        }
    }
}

