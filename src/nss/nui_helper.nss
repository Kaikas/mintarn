#include "nw_inc_nui_insp"

// Return the middle of the screen for the x position.
// oPC using the menu.
// fMenuWidth - the width of the menu to display.
float GetGUIWidthMiddle (object oPC, float fMenuWidth);

// Return the middle of the screen for the y position.
// oPC using the menu.
// fMenuHeight - the height of the menu to display.
float GetGUIHeightMiddle (object oPC, float fMenuHeight);

// Creates a basic Button.
// jRow is the row the button goes into.
// sLabel is the text that will go into the button.
// If sLabel is "" then it will be binded using sId + "_label".
// sId is the Id to bind the button with as well as setup the event.
// fWidth is the width of the button.
// fHeight is the Height of the button.
json CreateButton (json jRow, string sLabel, string sId, float fWidth, float fHeight);

// oPC is the PC using the menu.
// jLayout is the Layout of the menu.
// sWinID is the string ID for this window.
// slabel is the label of the menu.
// fX is the X position of the menu. if (-1.0) then it will center the x postion
// fY is the Y position of the menu. if (-1.0) then it will center the y postion
// fWidth is the width of the menu.
// fHeight is the height of the menu.
// bResize - TRUE will all it to be resized.
// bCollapse - TRUE will allow the window to be collapsable.
// bClose - TRUE will allow the window to be closed.
// bTransparent - TRUE makes the menu transparent.
// bBorder - TRUE makes the menu have a border.
int SetWindow (object oPC, json jLayout, string sWinID, string slabel, float fX, float fY, float fWidth, float fHeight, int bResize, int bCollapse, int bClose, int bTransparent, int bBorder);


// return the middle of the screen for the x position.
// oPC using the menu.
// fMenuWidth - the width of the menu to display.
float GetGUIWidthMiddle (object oPC, float fMenuWidth)
{
    // Get players window information.
    float fGUI_Width = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_WIDTH));
    float fGUI_Scale = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE)) / 100.0;
    fMenuWidth = fMenuWidth * fGUI_Scale;
    return (fGUI_Width / 2.0) - (fMenuWidth / 2.0);
}

// return the middle of the screen for the y position.
// oPC using the menu.
// fMenuHeight - the height of the menu to display.
float GetGUIHeightMiddle (object oPC, float fMenuHeight)
{
    // Get players window information.
    float fGUI_Height = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT));
    float fGUI_Scale = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE)) / 100.0;
    fMenuHeight = fMenuHeight * fGUI_Scale;
    return (fGUI_Height / 2.0) - (fMenuHeight / 2.0);
}

// Creates a basic Button.
// jRow is the row the button goes into.
// sLabel is the text that will go into the button.
// If sLabel is "" then it will be binded using sId + "_label".
// sId is the Id to bind the button with as well as setup the event.
// fWidth is the width of the button.
// fHeight is the Height of the button.
json CreateButton (json jRow, string sLabel, string sId, float fWidth, float fHeight)
{
    json jButton;
    if (sLabel == "") jButton = NuiEnabled (NuiId (NuiButton (NuiBind (sId + "_label")), sId), NuiBind (sId + "_event"));
    else jButton = NuiEnabled (NuiId (NuiButton (JsonString (sLabel)), sId), NuiBind (sId + "_event"));
    jButton = NuiWidth (jButton, fWidth);
    jButton = NuiHeight (jButton, fHeight);
    return JsonArrayInsert (jRow, jButton);
}

// oPC is the PC using the menu.
// jLayout is the Layout of the menu.
// sWinID is the string ID for this window.
// slabel is the label of the menu.
// fX is the X position of the menu. if (-1.0) then it will center the x postion
// fY is the Y position of the menu. if (-1.0) then it will center the y postion
// fWidth is the width of the menu.
// fHeight is the height of the menu.
// bResize - TRUE will all it to be resized.
// bCollapse - TRUE will allow the window to be collapsable.
// bClose - TRUE will allow the window to be closed.
// bTransparent - TRUE makes the menu transparent.
// bBorder - TRUE makes the menu have a border.
// To remove the Title bar set sLabel to "FALSE" and bCollapse, bClose to FALSE.
int SetWindow (object oPC, json jLayout, string sWinID, string sLabel, float fX, float fY, float fWidth, float fHeight, int bResize, int bCollapse, int bClose, int bTransparent, int bBorder)
{
    // Create the window binding everything.
    json jWindow;
    if (sLabel == "FALSE")
    {
        jWindow = NuiWindow (jLayout, JsonBool (FALSE), NuiBind ("window_geometry"),
        NuiBind ("window_resizable"), JsonBool (FALSE), JsonBool (FALSE),
        NuiBind ("window_transparent"), NuiBind ("window_border"));
    }
    else
    {
        jWindow = NuiWindow (jLayout, NuiBind ("window_label"), NuiBind ("window_geometry"),
        NuiBind ("window_resizable"), JsonBool (bCollapse), NuiBind ("window_closable"),
        NuiBind ("window_transparent"), NuiBind ("window_border"));
    }
    // Create the window.
    int nToken = NuiCreate (oPC, jWindow, sWinID);
    if (fX == -1.0) fX = GetGUIWidthMiddle (oPC, fWidth);
    if (fY == -1.0) fY = GetGUIHeightMiddle (oPC, fHeight);
    NuiSetBind (oPC, nToken, "window_geometry", NuiRect (fX,
                fY, fWidth, fHeight));
    // Set the binds for the new window.
    // Set the window options.
    if (sLabel != "FALSE")
    {
        NuiSetBind (oPC, nToken, "window_label", JsonString (sLabel));
        NuiSetBind (oPC, nToken, "window_closable", JsonBool (bClose));
    }
    NuiSetBind (oPC, nToken, "window_resizable", JsonBool (bResize));
    NuiSetBind (oPC, nToken, "window_transparent", JsonBool (bTransparent));
    NuiSetBind (oPC, nToken, "window_border", JsonBool (bBorder));
    return nToken;
}

//void main(){
//    object oPC;
//}

