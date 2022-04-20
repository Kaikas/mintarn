#include "nui_helper"

const float BTN_WIDTH = 120.0;
const float BTN_HEIGHT = 35.0;

void menu_portrait(object oPC);
void menu_description(object oPC);
void menu_changegod(object oPC);
void menu_staffmessage(object oPC);
void menu_itemdesc(object oPC);
void menu_downtime(object oPC);

void main()
{
    //declaring variables
    object oPC = OBJECT_SELF;
    json jRow = JsonArray();
    json jCol = JsonArray();

    float fWidth = BTN_WIDTH*3+26;
    float fHeight = BTN_HEIGHT*3+30+12*3;


    //Script that handles the NUI events
    //SetEventScript (GetModule (), EVENT_SCRIPT_MODULE_ON_NUI_EVENT, "nui_event");


    //Single Column layout
    jRow = CreateButton (jRow, "Portrait", "btn_portrait", BTN_WIDTH, BTN_HEIGHT);
    jRow = CreateButton (jRow, "Beschreibung", "btn_description", BTN_WIDTH, BTN_HEIGHT);
    jRow = CreateButton (jRow, "Gottheit", "btn_changegod", BTN_WIDTH, BTN_HEIGHT);

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));
    jRow = JsonArray();

    jRow = CreateButton (jRow, "Staffnachricht", "btn_staffmessage", BTN_WIDTH, BTN_HEIGHT);
    jRow = CreateButton (jRow, "Gegenstände", "btn_itemdesc", BTN_WIDTH, BTN_HEIGHT);
    jRow = CreateButton (jRow, "Aktivitäten", "btn_downtime", BTN_WIDTH, BTN_HEIGHT);

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));
    jRow = JsonArray();

    jRow = CreateButton (jRow, "Aussehen", "btn_appearance", BTN_WIDTH, BTN_HEIGHT);
    jRow = CreateButton (jRow, "Schneidern", "btn_clothing", BTN_WIDTH, BTN_HEIGHT);
    jRow = CreateButton (jRow, "Microtransactions", "btn_helpme", BTN_WIDTH, BTN_HEIGHT);

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    json jLayout = NuiCol(jCol);



    int nToken = SetWindow(oPC, jLayout, "gui_nui_menu", "Menü", -1.0, -1.0, fWidth, fHeight, 0, 0, 1, 0, 1);
    //save token on player for reference
    SetLocalInt (oPC, "nui_token", nToken);


    //binding events - the _event suffix is auto-generated. FALSE disables the button
    NuiSetBind (oPC, nToken, "btn_portrait_event", JsonBool (FALSE));
    NuiSetBind (oPC, nToken, "btn_description_event", JsonBool (TRUE));
    NuiSetBind (oPC, nToken, "btn_changegod_event", JsonBool (FALSE));

    NuiSetBind (oPC, nToken, "btn_staffmessage_event", JsonBool (TRUE));
    NuiSetBind (oPC, nToken, "btn_itemdesc_event", JsonBool (FALSE));
    NuiSetBind (oPC, nToken, "btn_downtime_event", JsonBool (TRUE));

    NuiSetBind (oPC, nToken, "btn_appearance_event", JsonBool (FALSE));
    NuiSetBind (oPC, nToken, "btn_clothing_event", JsonBool (TRUE));
    NuiSetBind (oPC, nToken, "btn_helpme_event", JsonBool (TRUE));
}

void menu_portrait(object oPC){}

void menu_description(object oPC){

}

void menu_changegod(object oPC){

}

void menu_staffmessage(object oPC){

}

void menu_itemdesc(object oPC){

}

void menu_downtime(object oPC){

}
