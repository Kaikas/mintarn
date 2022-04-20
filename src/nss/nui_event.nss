void main()
{
    object oPc = NuiGetEventPlayer();
    json jPayload = NuiGetEventPayload();
    string sAccountName = GetPCPlayerName(oPc);
    string sName = GetName(oPc);
    string sWindowId  = NuiGetWindowId(oPc, nToken);
    string sType = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nToken = NuiGetEventWindow();
    int nArrayIndex = NuiGetEventArrayIndex();
}
