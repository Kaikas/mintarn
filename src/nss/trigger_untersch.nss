#include "x3_inc_string"
#include "nwnx_chat"

void main() {
    object oPc = GetEnteringObject();
    if (Random(20) + GetSkillRank(SKILL_SPOT, oPc) > 12) {
        NWNX_Chat_SendMessage(1, StringToRGBString("Ihr habt etwas seltsames bemerkt als ihr den Schrank begutachtet. Er scheint eine falsche R�ckwand zu haben. Gebt /hindurchzw�ngen ein um auf die andere Seite zu kommen.", "333"), GetObjectByTag("TRIGGER_Schrank"), oPc);
    }
}
