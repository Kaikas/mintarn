void main()
{
    object oPc = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sWindowId  = NuiGetWindowId(oPc, nToken);
    string sType = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();
    json jPayload = NuiGetEventPayload();

    SendMessageToPC(oPc, "(" + IntToString(nToken) + ":" + sWindowId + ") T: " + sType + ", E: " + sElement + ", AI: " + IntToString(nArrayIndex) + ", P: " + JsonDump(jPayload));

    if (sWindowId == "downtime") {
        SendMessageToPC(oPc, "SELECTED: \n\n" + JsonGetString(NuiGetBind(oPc, nToken, "select_downtime")) + "\n");
        if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "select_work") {
                SendMessageToPC(oPc, "WORK");
            }
        }
    }

}
