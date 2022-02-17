void main()
{
    object oPlayer = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sWindowId  = NuiGetWindowId(oPlayer, nToken);
    string sType = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();
    json jPayload = NuiGetEventPayload();

    SendMessageToPC(oPlayer, "events_t (" + IntToString(nToken) + ":" + sWindowId + ") T: " + sType + ", E: " + sElement + ", AI: " + IntToString(nArrayIndex) + ", P: " + JsonDump(jPayload));
}
