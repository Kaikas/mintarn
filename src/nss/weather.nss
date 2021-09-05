#include "nwnx_time"
#include "nwnx_chat"
#include "weather_helper"


// Sets the weather for the whole module
void main() {
    // Save initial fog for all outside areas
    saveFog(GetObjectByTag("AREA_Freihafen"));
    saveFog(GetObjectByTag("AREA_Insel"));
    saveFog(GetObjectByTag("AREA_Banditenfestung"));
    saveFog(GetObjectByTag("AREA_Hgelland"));
    saveFog(GetObjectByTag("AREA_Banditenfestung"));
    saveFog(GetObjectByTag("AREA_versteckterHain"));
    saveFog(GetObjectByTag("AREA_Westmark"));
    weather();
}
