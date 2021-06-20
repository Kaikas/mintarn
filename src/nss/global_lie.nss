void main() {
   object oPc = GetLastUsedBy();
   object oBed = GetNearestObjectByTag("WP_BED");

   AssignCommand(oPc, JumpToLocation(GetLocation(oBed)));
   AssignCommand(oPc, ActionDoCommand(SetFacing(GetFacing(oBed))));
   AssignCommand(oPc, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 10.0f));
}
