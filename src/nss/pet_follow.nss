void Follow() {
    //ClearActions(0, TRUE);
    //object oPc = GetObjectByTag(GetLocalString(OBJECT_SELF, "PET_OWNER"));
    object oPc = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF);
    ActionMoveToObject(oPc, FALSE, 1.0f);
    DelayCommand(4.0f, Follow());
}

void main() {
    Follow();
}
