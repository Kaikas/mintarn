// Sets a creature to a faction
void main() {
    if (GetScriptParam("faction") == "Hostile") {
        ChangeFaction(GetLocalObject(GetPCSpeaker(), "fraktion"), GetObjectByTag("FACTION_HOSTILE"));
        AssignCommand(GetLocalObject(GetPCSpeaker(), "fraktion"), ClearAllActions(TRUE));
    }
    if (GetScriptParam("faction") == "Commoner") {
        ChangeFaction(GetLocalObject(GetPCSpeaker(), "fraktion"), GetObjectByTag("FACTION_COMMONER"));
        AssignCommand(GetLocalObject(GetPCSpeaker(), "fraktion"), ClearAllActions(TRUE));
    }
    if (GetScriptParam("faction") == "Merchant") {
        ChangeFaction(GetLocalObject(GetPCSpeaker(), "fraktion"), GetObjectByTag("FACTION_MERCHANT"));
        AssignCommand(GetLocalObject(GetPCSpeaker(), "fraktion"), ClearAllActions(TRUE));
    }
    if (GetScriptParam("faction") == "Defender") {
        ChangeFaction(GetLocalObject(GetPCSpeaker(), "fraktion"), GetObjectByTag("FACTION_DEFENDER"));
        AssignCommand(GetLocalObject(GetPCSpeaker(), "fraktion"), ClearAllActions(TRUE));
    }
    if (GetScriptParam("faction") == "Tiere") {
        ChangeFaction(GetLocalObject(GetPCSpeaker(), "fraktion"), GetObjectByTag("FACTION_TIERE"));
        AssignCommand(GetLocalObject(GetPCSpeaker(), "fraktion"), ClearAllActions(TRUE));
    }
    if (GetScriptParam("faction") == "Ents") {
        ChangeFaction(GetLocalObject(GetPCSpeaker(), "fraktion"), GetObjectByTag("FACTION_ENTS"));
        AssignCommand(GetLocalObject(GetPCSpeaker(), "fraktion"), ClearAllActions(TRUE));
    }
}
