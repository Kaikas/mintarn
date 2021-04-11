#include "x0_i0_talent"

void flee(object oPc, object oSelf) {
    ClearActions(0, TRUE);
    //Look at this to remove the delay
    ActionMoveAwayFromObject(oPc, TRUE, 10.0f);
    if (GetDistanceBetween(oPc, oSelf) < 40.0f) {
        DelayCommand(2.0f, flee(oPc, oSelf));
    }
}

void main() {
    flee(GetLastPerceived(), OBJECT_SELF);
}
