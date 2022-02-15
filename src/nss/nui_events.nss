#include "nw_inc_nui"

void main()
{
    object oPc = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sWindowId  = NuiGetWindowId(oPc, nToken);
    string sType = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();
    json jPayload = NuiGetEventPayload();

    /*
    SendMessageToPC(oPc, "" +
        "\nEVENTTYPE: " + sType +
        "\nELEMENT: " + sElement +
        "\nARRAYINDEX: " + IntToString(nArrayIndex) +
        "\nPAYLOAD: " + JsonDump(jPayload));
    */
    //"Token: " + IntToString(nToken) +
    //"\nWindowID:" + sWindowId +

    if (sWindowId == "downtime") {

        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "select_work") {
                SendMessageToPC(oPc, "WORK");
            }
        }
        if (sType == "watch" && sElement == "dropdownbox_selected") {
            if (JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected")) == 1) {
                SendMessageToPC(oPc, "Tagewerk");
                json jText = JsonArray();
                jText = JsonArrayInsert(jText, JsonString("Tagewerk"));
                NuiSetBind(oPc, nToken, "text", JsonString("Tagewerk"));
            }
            SendMessageToPC(oPc, "\nSELECTED: " + IntToString(JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected"))) + "\n");
        }
    }

}
