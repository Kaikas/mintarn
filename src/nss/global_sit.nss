// Sitzen auf stühlen
void main() {
    object oChair  = OBJECT_SELF;
    object oPlayer = GetLastUsedBy();
    if (GetIsPC(oPlayer))
    {
        if (GetIsObjectValid(oChair) && !GetIsObjectValid(GetSittingCreature(oChair)))
        {
            AssignCommand(oPlayer, ActionSit(oChair));
        }
    }
}

