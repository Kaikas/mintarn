#include "global_helper"

void main() {
    if (GetTimeMinute() == 0) {
        object oModule = GetModule();
        if (!(GetLocalInt(oModule, "alarm") == GetTimeHour())) {
          SetLocalInt(oModule, "alarm", GetTimeHour());
          object oPlayer = GetFirstPC();
          string sDay = IntToString(GetCalendarYear()) + "." + 
            IntToString(GetCalendarMonth()) + "." + IntToString(GetCalendarDay());
          int iTemperatur = GetLocalInt(oModule, sDay) - 100;
          if (iTemperatur == -100) return;
          int iWindStrength = GetLocalInt(oModule, "windstrength");
          string sWindDirection = GetLocalString(oModule, "sWindDirection");
          int iRain = GetLocalInt(oModule, "rain");
          while(GetIsObjectValid(oPlayer)) {
              SendMessageToPC(oPlayer, GetToken(103) + "Es ist der " +
                  LeadingZeros(IntToString(GetCalendarDay()), 2) +
                  "." + LeadingZeros(IntToString(GetCalendarMonth()), 2) +
                  "." + LeadingZeros(IntToString(GetCalendarYear()), 2) +
                  " DR " +
                  " " + LeadingZeros(IntToString(GetTimeHour()), 2) +
                  ":" +
                  LeadingZeros(IntToString(GetTimeMinute()), 2) +
                  "Uhr.</c>");
              SendMessageToPC(oPlayer, 
                  GetToken(103) + 
                  "Die Auﬂentemperatur betr‰gt " + 
                  IntToString(iTemperatur) + "∞C</c>");
              string sWindStrength;
              // Possible: N, NO, O, SO, S, SW, W, NW
              // Sehr stark (5), Strong (4), medium (3), weak (2), windstill (1)
              if (iWindStrength == 1) {
                  SendMessageToPC(oPlayer, GetToken(103) + "Es ist windstill.</c>");
              } else if (iWindStrength == 2) {
                  SendMessageToPC(oPlayer, GetToken(103) + "Es weht ein schwacher " + 
                  sWindDirection + " .</c>");
              } else if (iWindStrength == 3) {
                  SendMessageToPC(oPlayer, GetToken(103) + "Es weht ein mittelstarker " + 
                  sWindDirection + ".</c>");
              } else if (iWindStrength == 4) {
                  SendMessageToPC(oPlayer, GetToken(103) + "Es weht ein starker " + 
                  sWindDirection + "</c>");
              } else if (iWindStrength == 5) {
                  SendMessageToPC(oPlayer, GetToken(103) + "Es weht ein sehr starker " + 
                  sWindDirection + ".</c>");
              }
              if (GetTimeHour() > GetLocalInt(oModule, sDay + "fog_start") && 
                GetTimeHour() < GetLocalInt(oModule, sDay + "fog_end") && 
                iWindStrength < 3 && (iRain == 1 || iRain == 3)) {
                  SendMessageToPC(oPlayer, GetToken(103) + "Nebel schr‰nkt die Sicht ein.</c>");
              }
              oPlayer = GetNextPC();
          }
      }
    }
    DelayCommand(30.0, ExecuteScript("alarm", OBJECT_SELF));
}
