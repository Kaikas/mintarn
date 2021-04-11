#include "x0_i0_talent"

void main() {
    ClearActions(0, TRUE);
    //Look at this to remove the delay
    ActionMoveAwayFromObject(GetLastDisturbed(), TRUE, 10.0f);
    DelayCommand(4.0, ClearActions(0, TRUE));
}
