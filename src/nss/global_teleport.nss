// Teleport script for all area transitions that have no transition wizard.
// Determines where to teleport according to the tag of the calling object.
//
//
// Rules for Waypoints and Tags of portals:
//
// Tag of portal: TELEPORT_<current_area>_TO_<target_area>[_(1-9)*]
//  e.g.: TELEPORT_FREIHAFEN_TO_WESTMARK,
//        TELEPORT_FREIHAFEN_TO_WESTMARK_2,
//        TELEPORT_FREIHAFEN_TO_WESTMARK_99
//
// Tag of target waypoints: WP_TP_<current_area>_AT_<closes_area>[_(1-9)*]
// e.g.: WP_TP_FREIHAFEN_AT_ALCHEMIST
//       WP_TP_FREIHAFEN_AT_ALCHEMIST_42

void main() {
  object oPc = GetLastUsedBy();

  string sTargetTag = "OBJECT_INVALID";

  switch (GetTag(OBJECT_SELF)) {
    case "TELEPORT_FREIHAFEN_TO_WESTMARK":
      sTargetTag = "WP_TP_WESTMARK_AT_FREIHAFEN"
      break;  
    case "TELEPORT_ALCHEMIST_TO_FREIHAFEN":
      sTargetTag = "WP_TP_FREIHAFEN_AT_ALCHEMIST"
      break;
  }
  location lTarget = GetLocation(GetObjectByTag(sTargetTag));

  DelayCommand(1.0, AssignCommand(oPc, JumpToLocation(lStart)));
}
