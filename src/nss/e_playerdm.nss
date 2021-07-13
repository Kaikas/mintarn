#include "nwnx_webhook"
#include "nwnx_util"

void main() {
    object oPc = OBJECT_SELF;
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("WEBHOOK_LOGS"), GetPCPlayerName(oPc) + " hat sich als Spieler DM eingeloggt." , "Mintarn");
}
