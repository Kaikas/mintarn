// Startet den Aussehen dialog on use

void main() {
    object oPc = GetLastUsedBy();
    AssignCommand(oPc, ActionStartConversation(oPc, "aussehen", TRUE));
}
