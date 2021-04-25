#include "nwnx_webhook"
#include "nwnx_util"

void main() {
    object oPc = GetLastUsedBy();
    int iXp = GetXP(oPc);
    SetXP(oPc, 0);
    SetXP(oPc, iXp);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), "Level reset: " + GetPCPlayerName(oPc) + " - " + GetName(oPc), "Mintarn");
    SendMessageToPC(oPc, "Level zurückgesetzt.");
}
