#include "inc_perchest"

void main()
{
    object oPlayer = GetLastUsedBy();

    PC_CreateNUIWindow(oPlayer);
}
