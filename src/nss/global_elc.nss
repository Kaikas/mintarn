#include "nwnx_elc"
#include "nwnx_player"
#include "nwnx_admin"

void main() {
    object oPc = OBJECT_SELF;
    //NWNX_Administration_DeleteTURD(GetPCPlayerName(oPc), GetName(oPc));
    NWNX_Player_SetSpawnLocation(oPc, GetLocation(GetObjectByTag("WP_START_OOC")));
}
