#include "global_helper"

void main() {
    object oModule = GetModule();
    object oPlayer = GetFirstPC();
    string sDay = IntToString(GetCalendarYear()) + "." + IntToString(GetCalendarMonth()) + "." + IntToString(GetCalendarDay());
    int iTemperatur = GetLocalInt(oModule, sDay) - 100;
    if (iTemperatur == -100) return;
    int iWindStrength = GetLocalInt(oModule, "windstrength");
    string sWindDirection = GetLocalString(oModule, "sWindDirection");
    int iRain = GetLocalInt(oModule, "rain");
    while(GetIsObjectValid(oPlayer)) {
        SendMessageToPC(oPlayer, "<cvvv>Es ist der " +
            LeadingZeros(IntToString(GetCalendarDay()), 2) +
            "." + LeadingZeros(IntToString(GetCalendarMonth()), 2) +
            "." + LeadingZeros(IntToString(GetCalendarYear()), 2) +
            " DR " +
            " " + LeadingZeros(IntToString(GetTimeHour()), 2) +
            ":" +
            LeadingZeros(IntToString(GetTimeMinute()), 2) +
            "Uhr.</c>");
            //+ LeadingZeros(IntToString(GetTimeMinute()), 2) + " Uhr.</c>");
        //SendMessageToPC(oPlayer, IntToString(GetCalendarDay()) + "." + IntToString(GetCalendarMonth()) + "." + IntToString(GetCalendarYear()) + " - " + IntToString(GetTimeHour()) + ":00 Uhr");
        SendMessageToPC(oPlayer, "<cvvv>Die Auﬂentemperatur betr‰gt " + IntToString(iTemperatur) + "∞C</c>");
        string sWindStrength;
        // Possible: N, NO, O, SO, S, SW, W, NW
        // Sehr stark (5), Strong (4), medium (3), weak (2), windstill (1)
        if (iWindStrength == 1) {
            SendMessageToPC(oPlayer, "<cvvv>Es ist windstill.</c>");
        } else if (iWindStrength == 2) {
            SendMessageToPC(oPlayer, "<cvvv>Es weht ein schwacher " + sWindDirection + " .</c>");
        } else if (iWindStrength == 3) {
            SendMessageToPC(oPlayer, "<cvvv>Es weht ein mittelstarker " + sWindDirection + ".</c>");
        } else if (iWindStrength == 4) {
            SendMessageToPC(oPlayer, "<cvvv>Es weht ein starker " + sWindDirection + "</c>");
        } else if (iWindStrength == 5) {
            SendMessageToPC(oPlayer, "<cvvv>Es weht ein sehr starker " + sWindDirection + ".</c>");
        }
        if (GetTimeHour() > GetLocalInt(oModule, sDay + "fog_start") && GetTimeHour() < GetLocalInt(oModule, sDay + "fog_end") && iWindStrength < 3 && (iRain == 1 || iRain == 3)) {
            SendMessageToPC(oPlayer, "<cvvv>Nebel schr‰nkt die Sicht ein.</c>");
        }
        oPlayer = GetNextPC();
    }

    DelayCommand(1200.0, ExecuteScript("alarm", OBJECT_SELF));
}
