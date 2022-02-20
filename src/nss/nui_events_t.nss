#include "inc_perchest"

void main() {
    object oPlayer = GetLastPlayerToSelectTarget();
    object oTarget = GetTargetingModeSelectedObject();
    vector vPosition = GetTargetingModeSelectedPosition();

    PC_HandleDepositEvent(oPlayer, oTarget, vPosition);
}
