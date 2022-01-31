#include "nwnx_webhook"
#include "nwnx_util"

// Cleans up if a playe crasht or disconnected with alt+f4
void main() {
    object oPc = OBJECT_SELF;
    string sAccountName = GetPCPlayerName(oPc);
    string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_MODULE");
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " ist gecrasht.", "Mintarn");
}
