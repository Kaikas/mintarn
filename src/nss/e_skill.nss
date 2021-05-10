#include "nwnx_events"

void main() {
    // Handles the Taunt skill which is deactivated.
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_TAUNT) {
        SendMessageToPC(OBJECT_SELF, "Euer Versuch zu provozieren zeigt keine Wirkung.");
        NWNX_Events_SkipEvent();
    }
    // Handles animal empathy. This is the engine skill to charme an animal.
    // This can only be used by Druids and Rangers.
    // 
    // The skill Animal Handling is the general skill that all classes can use for
    // working with animals.
    if (StringToInt(NWNX_Events_GetEventData("SKILL_ID")) == SKILL_ANIMAL_EMPATHY) {
      if (!(GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF) > 0 || 
          GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF))) {
          SendMessageToPC(OBJECT_SELF, "Euer Versuch ein Tier zu zähmen zeigt keine Wirkung.");
          NWNX_Events_SkipEvent();
      }
    }
}
