/*
    NUI Persistent Chest System
    Created By: Daz
*/

#include "nw_inc_nui"
#include "nw_inc_gff"
#include "nwnx_sql"

const string PC_NUI_WINDOW_ID       = "PC_WINDOW";
const string PC_UUID_ARRAY          = "PC_UUID_ARRAY";
const string PC_WINDOW_JSON         = "PC_WINDOW_JSON";
const string PC_TARGETING_MODE      = "PC_TARGETING_MODE";
const string PC_GEOMETRY_JSON       = "PC_GEOMETRY_JSON";
const string PC_SEARCH_STRING       = "PC_SEARCH_STRING";

const int PC_MAX_ITEMS              = 25;       // The max number of items a player can store in their chest
const int PC_ITEM_WITHDRAW_BATCH    = 5;        // How many items to deserialize at the same time
const float PC_ITEM_WITHDRAW_DELAY  = 0.25f;    // The delay between deserialization batches
const int PC_USE_SEARCH_BUTTON      = FALSE;    // Set to true to use a Search button instead of searching on text change
const int PC_SAVE_ITEM_OBJECT_STATE = TRUE;     // Save local variables / temporary itemproperties when serializing items
const int PC_OPEN_INVENTORY_WINDOW  = TRUE;     // Open the inventory when opening a persistent chest

string PC_GetDatabaseName(object oPlayer);
string PC_GetTableName(object oPlayer);
void PC_InitializeDatabase(object oPlayer);
void PC_CreateNUIWindow(object oPlayer, int bOpenInventory = PC_OPEN_INVENTORY_WINDOW);
void PC_EnterDepositMode(object oPlayer);
void PC_HandleNUIEvents(object oPlayer, int nToken, string sType, string sElement, int nArrayIndex);
int PC_GetStoredItemAmount(object oPlayer);
string PC_GetIconResref(object oItem, json jItem, int nBaseItem);
void PC_HandleDepositEvent(object oPlayer, object oItem, vector vPosition);
void PC_UpdateItemList(object oPlayer, int nToken);
void PC_WithdrawItems(object oPlayer, int nToken);

string PC_GetDatabaseName(object oPlayer)
{
    return "PC_" + GetPCPublicCDKey(oPlayer, TRUE);
}

string PC_GetTableName(object oPlayer)
{
    return "PC_ITEMS";
}

void PC_InitializeDatabase(object oPlayer)
{// Boring database stuff
    /*
    string sDatabase = PC_GetDatabaseName(oPlayer);
    string sTable = PC_GetTableName(oPlayer);
    string sQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name=@table;";
    sqlquery sql = SqlPrepareQueryCampaign(sDatabase, sQuery);
    SqlBindString(sql, "@table", sTable);

    if (!SqlStep(sql))
    {
        string sQuery = "CREATE TABLE IF NOT EXISTS " + sTable + " (" +
                        "item_uuid TEXT NOT NULL, " +
                        "item_name TEXT NOT NULL, " +
                        "item_baseitem INTEGER NOT NULL, " +
                        "item_stacksize INTEGER NOT NULL, " +
                        "item_iconresref TEXT NOT NULL, " +
                        "item_data TEXT_NOT NULL, " +
                        "PRIMARY KEY(item_uuid));";
        sqlquery sql = SqlPrepareQueryCampaign(sDatabase, sQuery);
        SqlStep(sql);
    }
    */
}

void PC_CreateNUIWindow(object oPlayer, int bOpenInventory = PC_OPEN_INVENTORY_WINDOW)
{
    PC_InitializeDatabase(oPlayer);

    json jWindow = GetLocalJson(GetModule(), PC_WINDOW_JSON);
    if (jWindow == JsonNull())
    {// For efficiency, we only build the window json once and store it in a local json on the module
        json jCol;// Our main column to hold all the rows
        json jRow;// A reusable row

        jCol = JsonArray();// Create an array to hold our rows

        jRow = JsonArray();// Create an array to hold our row elements
        {// Our first row only has a progress bar to indicate the amount of items stored
            json jProgress = NuiProgress(NuiBind("progress"));// The actual progress of the progress bar is bound to 'progress'
                 jProgress = NuiTooltip(jProgress, NuiBind("progress_tooltip"));// Here we add a tooltip and its bind to update it
            jRow = JsonArrayInsert(jRow, jProgress);// Add the progress bar to the row
        }
        jCol = JsonArrayInsert(jCol, NuiRow(jRow));// Add the row to the column

        jRow = JsonArray();
        {// The second row has the search bar, a clear button, and if enabled, a search button
            json jSearch = NuiTextEdit(JsonString("Suchen..."), NuiBind("search"), 64, FALSE);// A simple search bar, we bind whatever the user types to 'search'
            jRow = JsonArrayInsert(jRow, jSearch);

            json jClearButton = NuiButton(JsonString("X"));
                 jClearButton = NuiId(jClearButton, "btn_clear");// We give the button an id so we can get its click event
                 jClearButton = NuiEnabled(jClearButton, NuiBind("btn_clear"));// Here we enable the enabling or disabling of the button.. :D bound to 'btn_clear'
                 jClearButton = NuiWidth(jClearButton, 35.0f);// Width...
                 jClearButton = NuiHeight(jClearButton, 35.0f);// Height...
            jRow = JsonArrayInsert(jRow, jClearButton);

            if (PC_USE_SEARCH_BUTTON)
            {
                json jSearchButton = NuiButton(JsonString("Search"));
                     jSearchButton = NuiId(jSearchButton, "btn_search");
                     jSearchButton = NuiWidth(jSearchButton, 100.0f);
                     jSearchButton = NuiHeight(jSearchButton, 35.0f);
                jRow = JsonArrayInsert(jRow, jSearchButton);
            }
        }
        jCol = JsonArrayInsert(jCol, NuiRow(jRow));

        jRow = JsonArray();
        {// The third row has the item list, here we also create the template for every list item to use
            json jListTemplate = JsonArray();
            {
                json jImage = NuiImage(NuiBind("icons"), JsonInt(NUI_ASPECT_FIT100), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_TOP));
                     jImage = NuiTooltip(jImage, NuiBind("tooltips"));
                     jImage = NuiGroup(jImage, TRUE, NUI_SCROLLBARS_NONE);
                jListTemplate = JsonArrayInsert(jListTemplate, NuiListTemplateCell(jImage, 32.0f, FALSE));

                json jCheck = NuiCheck(NuiBind("names"), NuiBind("selected"));
                jListTemplate = JsonArrayInsert(jListTemplate, NuiListTemplateCell(jCheck, 0.0f, TRUE));
            }
            jRow = JsonArrayInsert(jRow, NuiList(jListTemplate, NuiBind("icons"), 32.0f));
        }
        jCol = JsonArrayInsert(jCol, NuiRow(jRow));

        jRow = JsonArray();
        {// The final row has a bunch of buttons, exciting
            json jButtonWithdraw = NuiButton(JsonString("Entnehmen"));
                 jButtonWithdraw = NuiId(jButtonWithdraw, "btn_withdraw");
                 jButtonWithdraw = NuiEnabled(jButtonWithdraw, NuiBind("btn_withdraw"));
                 jButtonWithdraw = NuiWidth(jButtonWithdraw, 100.0f);
                 jButtonWithdraw = NuiHeight(jButtonWithdraw, 35.0f);
            jRow = JsonArrayInsert(jRow, jButtonWithdraw);

            json jButtonDeposit = NuiButton(JsonString("Verstauen"));
                 jButtonDeposit = NuiId(jButtonDeposit, "btn_deposit");
                 jButtonDeposit = NuiEnabled(jButtonDeposit, NuiBind("btn_deposit"));
                 jButtonDeposit = NuiWidth(jButtonDeposit, 100.0f);
                 jButtonDeposit = NuiHeight(jButtonDeposit, 35.0f);
            jRow = JsonArrayInsert(jRow, jButtonDeposit);

            jRow = JsonArrayInsert(jRow, NuiSpacer());

            json jButtonClose = NuiButton(JsonString("Schlieﬂen"));
                 jButtonClose = NuiId(jButtonClose, "btn_close");
                 jButtonClose = NuiWidth(jButtonClose, 100.0f);
                 jButtonClose = NuiHeight(jButtonClose, 35.0f);
            jRow = JsonArrayInsert(jRow, jButtonClose);
        }
        jCol = JsonArrayInsert(jCol, NuiRow(jRow));

        json jRoot = NuiCol(jCol);// Turn our column variable into a column
        // Bind the window title and geometry, disable resizing and set collapsed to false
        jWindow = NuiWindow(jRoot,
            NuiBind("window_name"),
            NuiBind("geometry"),
            JsonBool(FALSE),
            JsonBool(FALSE),
            JsonBool(TRUE),
            JsonBool(FALSE),
            JsonBool(TRUE));
            SetLocalJson(GetModule(), PC_WINDOW_JSON, jWindow
        );
    }

    // We let the user move the window and it'll save the position in a local
    // In the case of the local not existing we position the window in its default position
    json jGeometry = GetLocalJson(oPlayer, PC_GEOMETRY_JSON);
    if (jGeometry == JsonNull())
        jGeometry = NuiRect(400.0f, 0.0f, 400.0f, 500.0f);

    // Actually create the window for the player!
    int nToken = NuiCreate(oPlayer, jWindow, PC_NUI_WINDOW_ID);

    // If the search button is not enabled we watch the search bind for changes in the search box
    NuiSetBindWatch(oPlayer, nToken, "search", !PC_USE_SEARCH_BUTTON);
    // Watch for players moving the window
    NuiSetBindWatch(oPlayer, nToken, "geometry", TRUE);
    // Here we set the initial window position, either to the default position or wherever the player last left it
    NuiSetBind(oPlayer, nToken, "geometry", jGeometry);
    // Setting the window title
    NuiSetBind(oPlayer, nToken, "window_name", JsonString("Truhe von " + GetName(oPlayer)));
    // We clear the search bar, this'll invoke the watch event, if enabled, where we do some other stuff
    NuiSetBind(oPlayer, nToken, "search", JsonString(""));
    // Enable or disable the clear button depending on if we have the search button enabled
    // If the search button is disabled we only enable it if the search bar actually has text
    NuiSetBind(oPlayer, nToken, "btn_clear", JsonBool(PC_USE_SEARCH_BUTTON));

    if (PC_USE_SEARCH_BUTTON)
    {
        DeleteLocalString(oPlayer, PC_SEARCH_STRING);
        PC_UpdateItemList(oPlayer, nToken);
    }

    if (bOpenInventory)
        PopUpGUIPanel(oPlayer, GUI_PANEL_INVENTORY);
}

void PC_EnterDepositMode(object oPlayer)
{
    SetLocalInt(oPlayer, PC_TARGETING_MODE, TRUE);
    EnterTargetingMode(oPlayer, OBJECT_TYPE_ITEM);
}

void PC_HandleNUIEvents(object oPlayer, int nToken, string sType, string sElement, int nArrayIndex)
{
    if (sType == "click")
    {
        if (sElement == "btn_withdraw")
        {// The withdraw button is clicked, withdraw some items
            PC_WithdrawItems(oPlayer, nToken);
        }
        else if (sElement == "btn_deposit")
        {// The deposit button is clicked, enter deposit mode
            PC_EnterDepositMode(oPlayer);
        }
        else if (sElement == "btn_close")
        {// Murder the poor window
            NuiDestroy(oPlayer, nToken);
        }
        else if (sElement == "btn_search")
        {// Handle the search button if enabled
            SetLocalString(oPlayer, PC_SEARCH_STRING, JsonGetString(NuiGetBind(oPlayer, nToken, "search")));
            PC_UpdateItemList(oPlayer, nToken);
        }
        else if (sElement == "btn_clear")
        {// Handle the clear button
            NuiSetBind(oPlayer, nToken, "search", JsonString(""));

            if (PC_USE_SEARCH_BUTTON)
            {
                DeleteLocalString(oPlayer, PC_SEARCH_STRING);
                PC_UpdateItemList(oPlayer, nToken);
            }
        }
    }
    else if (sType == "watch")
    {
        if (sElement == "geometry")
        {// Whenever the geometry of the window changes this watch event will fire, we just get the bind's value and store it in a local
            SetLocalJson(oPlayer, PC_GEOMETRY_JSON, NuiGetBind(oPlayer, nToken, "geometry"));
        }
        else if (sElement == "search")
        {// Whenever the player types in the search bar this watch event fires, we enable or disable the clear button depending on string length and set the search string in a local
            string sSearch = JsonGetString(NuiGetBind(oPlayer, nToken, "search"));

            NuiSetBind(oPlayer, nToken, "btn_clear", JsonBool(GetStringLength(sSearch)));
            SetLocalString(oPlayer, PC_SEARCH_STRING, sSearch);
            PC_UpdateItemList(oPlayer, nToken);
        }
    }
}

int PC_GetStoredItemAmount(object oPc)
{// Wrapper to get the number of stored items
    string sQuery = "SELECT * FROM Playerchests where name = ? AND charname = ? AND cdkey = ?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, GetPCPublicCDKey(oPc));
        NWNX_SQL_ExecutePreparedQuery();
        return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    }
    return 0;

    /*
    sqlquery sql = SqlPrepareQueryCampaign(PC_GetDatabaseName(oPlayer), sQuery);
    return SqlStep(sql) ? SqlGetInt(sql, 0) : 0;
    */
}

string PC_GetIconResref(object oItem, json jItem, int nBaseItem)
{
    if (nBaseItem == BASE_ITEM_CLOAK) // Cloaks use PLTs so their default icon doesn't really work
        return "iit_cloak";
    else if (nBaseItem == BASE_ITEM_SPELLSCROLL || nBaseItem == BASE_ITEM_ENCHANTED_SCROLL)
    {// Scrolls get their icon from the cast spell property
        if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL))
        {
            itemproperty ip = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(ip))
            {
                if (GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL)
                    return Get2DAString("iprp_spells", "Icon", GetItemPropertySubType(ip));

                ip = GetNextItemProperty(oItem);
            }
        }
    }
    else if (Get2DAString("baseitems", "ModelType", nBaseItem) == "0")
    {// Create the icon resref for simple modeltype items
        json jSimpleModel = GffGetByte(jItem, "ModelPart1");
        if (JsonGetType(jSimpleModel) == JSON_TYPE_INTEGER)
        {
            string sSimpleModelId = IntToString(JsonGetInt(jSimpleModel));
            while (GetStringLength(sSimpleModelId) < 3)// Padding...
            {
                sSimpleModelId = "0" + sSimpleModelId;
            }

            string sDefaultIcon = Get2DAString("baseitems", "DefaultIcon", nBaseItem);
            switch (nBaseItem)
            {
                case BASE_ITEM_MISCSMALL:
                case BASE_ITEM_CRAFTMATERIALSML:
                    sDefaultIcon = "iit_smlmisc_" + sSimpleModelId;
                    break;
                case BASE_ITEM_MISCMEDIUM:
                case BASE_ITEM_CRAFTMATERIALMED:
                case 112:/* Crafting Base Material */
                    sDefaultIcon = "iit_midmisc_" + sSimpleModelId;
                    break;
                case BASE_ITEM_MISCLARGE:
                    sDefaultIcon = "iit_talmisc_" + sSimpleModelId;
                    break;
                case BASE_ITEM_MISCTHIN:
                    sDefaultIcon = "iit_thnmisc_" + sSimpleModelId;
                    break;
            }

            int nLength = GetStringLength(sDefaultIcon);
            if (GetSubString(sDefaultIcon, nLength - 4, 1) == "_")// Some items have a default icon of xx_yyy_001, we strip the last 4 symbols if that is the case
                sDefaultIcon = GetStringLeft(sDefaultIcon, nLength - 4);
            string sIcon = sDefaultIcon + "_" + sSimpleModelId;
            if (ResManGetAliasFor(sIcon, RESTYPE_TGA) != "")// Check if the icon actually exists, if not, we'll fall through and return the default icon
                return sIcon;
        }
    }

    // For everything else use the item's default icon
    return Get2DAString("baseitems", "DefaultIcon", nBaseItem);
}

void PC_HandleDepositEvent(object oPlayer, object oItem, vector vPosition)
{// This function is fired in the module on player target event
    if (!GetLocalInt(oPlayer, PC_TARGETING_MODE))// Make sure it only fires if we're actually depositing an item
        return;

    DeleteLocalInt(oPlayer, PC_TARGETING_MODE);

    if (!GetIsObjectValid(oItem) || GetLocalInt(oItem, "PC_ITEM_DESTROYED") || GetObjectType(oItem) != OBJECT_TYPE_ITEM)
        return;// Check the validness of the item

    if (GetItemPossessor(oItem) != oPlayer)
    {// Check if we actually own the item
        SendMessageToPC(oPlayer, "You do not own '" + GetName(oItem) + "'");
        return;
    }

    int nStoredItems = PC_GetStoredItemAmount(oPlayer);
    if (nStoredItems >= PC_MAX_ITEMS)
    {// Check if we have space...
        SendMessageToPC(oPlayer, "Die Kiste ist voll.");
        return;
    }

    // Here we grab a bunch of data and actually store stuff in the database
    // We store the item as json because we need that to get some additional icon data anyway
    string sItemUUID = GetObjectUUID(oItem);
    string sItemName = GetName(oItem);
    int nItemBaseItem = GetBaseItemType(oItem);
    int nItemStackSize = GetItemStackSize(oItem);
    json jItemData = ObjectToJson(oItem, PC_SAVE_ITEM_OBJECT_STATE);
    string sItemIconResRef = PC_GetIconResref(oItem, jItemData, nItemBaseItem);
    string sQuery = "INSERT INTO Playerchests" +
                    "(name, charname, cdkey, item_uuid, item_name, item_baseitem, item_stacksize, item_iconresref, item_data) " +
                    "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?);";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPlayer));
        NWNX_SQL_PreparedString(1, GetName(oPlayer));
        NWNX_SQL_PreparedString(2, GetPCPublicCDKey(oPlayer));
        NWNX_SQL_PreparedString(3, sItemUUID);
        NWNX_SQL_PreparedString(4, sItemName);
        NWNX_SQL_PreparedInt(5, nItemBaseItem);
        NWNX_SQL_PreparedInt(6, nItemStackSize);
        NWNX_SQL_PreparedString(7, sItemIconResRef);
        NWNX_SQL_PreparedString(8, JsonDump(jItemData));
        NWNX_SQL_ExecutePreparedQuery();
    }
    /*sqlquery sql = SqlPrepareQueryCampaign(PC_GetDatabaseName(oPlayer), sQuery);

    SqlBindString(sql, "@item_uuid", sItemUUID);
    SqlBindString(sql, "@item_name", sItemName);
    SqlBindInt(sql, "@item_baseitem", nItemBaseItem);
    SqlBindInt(sql, "@item_stacksize", nItemStackSize);
    SqlBindString(sql, "@item_iconresref", sItemIconResRef);
    SqlBindJson(sql, "@item_data", jItemData);
    SqlStep(sql);
    */

    int nToken = NuiFindWindow(oPlayer, PC_NUI_WINDOW_ID);
    if (nToken)
    {// Check if the window is still open, if so update the item list and enter targeting mode again if we still have space
        PC_UpdateItemList(oPlayer, nToken);

        if(++nStoredItems != PC_MAX_ITEMS)
        {
            PC_EnterDepositMode(oPlayer);
        }
    }

    // Dunno if this is needed but maybe somehow the player clicks on an item before it is destroyed, we'll try to prevent that
    SetLocalInt(oItem, "PC_ITEM_DESTROYED", TRUE);
    DestroyObject(oItem);
}

void PC_UpdateItemList(object oPlayer, int nToken)
{
    json jUUIDArray = JsonArray();// This array is stored on the player so we can map an array index to an items UUID
    json jNamesArray = JsonArray();// This array is for the list and stores all the names of the items
    json jTooltipArray = JsonArray();// This array is for the list and stores all the baseitem tooltips of the items
    json jIconsArray = JsonArray();// This array is for the list and stores all the icons of the items
    json jSelectedArray = JsonArray();// This array is for the list and stores wether an item is selected or not

    int nNumItems = PC_GetStoredItemAmount(oPlayer);
    string sSearch = GetLocalString(oPlayer, PC_SEARCH_STRING);
    string sQuery = "SELECT item_uuid, item_name, item_baseitem, item_stacksize, item_iconresref FROM Playerchests";
    if (sSearch != "") {
        sQuery = sQuery + " WHERE item_name LIKE ?";
    }
    sQuery = sQuery + " ORDER BY item_baseitem ASC, item_name ASC;";
    //sqlquery sql = SqlPrepareQueryCampaign(PC_GetDatabaseName(oPlayer), sQuery);

    if (NWNX_SQL_PrepareQuery(sQuery)) {
        if (sSearch != "") {
        //SqlBindString(sql, "@search", "%" + sSearch + "%");
            NWNX_SQL_PreparedString(0, sSearch);
        }
        NWNX_SQL_ExecutePreparedQuery();
        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            string sUUID = NWNX_SQL_ReadDataInActiveRow(0);
            string sName = NWNX_SQL_ReadDataInActiveRow(1);
            int nBaseItem = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
            int nStackSize = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
            string sIconResRef = NWNX_SQL_ReadDataInActiveRow(4);

            jUUIDArray = JsonArrayInsert(jUUIDArray, JsonString(sUUID));// Store its UUId
            jNamesArray = JsonArrayInsert(jNamesArray, JsonString(sName + (nStackSize > 1 ? " (x" + IntToString(nStackSize) + ")" : "")));// Store its name and stacksize if >1
            jTooltipArray = JsonArrayInsert(jTooltipArray, JsonString(GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", nBaseItem)))));// Store the tooltip
            jIconsArray = JsonArrayInsert(jIconsArray, JsonString(sIconResRef));// Store the icon
            jSelectedArray = JsonArrayInsert(jSelectedArray, JsonBool(FALSE));// Set the item as not selected
        }
    }
    SetLocalJson(oPlayer, PC_UUID_ARRAY, jUUIDArray);// We save this array on the player for later use
    // Set the list binds to the new arrays
    NuiSetBind(oPlayer, nToken, "icons", jIconsArray);
    NuiSetBind(oPlayer, nToken, "names", jNamesArray);
    NuiSetBind(oPlayer, nToken, "tooltips", jTooltipArray);
    NuiSetBind(oPlayer, nToken, "selected", jSelectedArray);

    // Update our progress tracker and its tooltip
    NuiSetBind(oPlayer, nToken, "progress", JsonFloat(IntToFloat(nNumItems) / IntToFloat(PC_MAX_ITEMS)));
    NuiSetBind(oPlayer, nToken, "progress_tooltip", JsonString(IntToString(nNumItems) + " / " + IntToString(PC_MAX_ITEMS) + " Items Stored"));

    // Disable or enable the withdraw and deposit buttons depending on item amounts
    NuiSetBind(oPlayer, nToken, "btn_withdraw", JsonBool(nNumItems > 0));
    NuiSetBind(oPlayer, nToken, "btn_deposit", JsonBool(nNumItems < PC_MAX_ITEMS));
}

void VoidJsonToObject(json jObject, location locLocation, object oOwner = OBJECT_INVALID, int bLoadObjectState = FALSE)
{
    JsonToObject(jObject, locLocation, oOwner, bLoadObjectState);
}

void PC_WithdrawItems(object oPlayer, int nToken)
{
    json jSelected = NuiGetBind(oPlayer, nToken, "selected");// This gets the array of selected items

    int nNumItems = JsonGetLength(jSelected);
    if (!nNumItems)// Why bother doing anything if we have no items stored
        return;

    string sDatabase = PC_GetDatabaseName(oPlayer);
    string sTable = PC_GetTableName(oPlayer);
    string sSelectQuery = "SELECT item_data FROM Playerchests WHERE item_uuid=? AND name=? AND Charname=? AND cdkey=?;";
    string sDeleteQuery = "DELETE FROM Playerchests WHERE item_uuid=? AND name=? AND charname=? AND cdkey=?;";
    json jUUIDs = GetLocalJson(oPlayer, PC_UUID_ARRAY);// Get our array index <-> uuid map
    location locPlayer = GetLocation(oPlayer);
    int nItem, nWithdrawnItems = 0;
    float fDelay = PC_ITEM_WITHDRAW_DELAY;
    //sqlquery sql;

    for (nItem = 0; nItem < nNumItems; nItem++)
    {// Loop all items, this will need improving for big amounts of items
        if (JsonGetInt(JsonArrayGet(jSelected, nItem)))
        {// Check if the item is selected, if so we withdraw it
            string sUUID = JsonGetString(JsonArrayGet(jUUIDs, nItem));// Use the index of the item to get its uuid from the array we stored earlier
            //sql = SqlPrepareQueryCampaign(sDatabase, sSelectQuery);
            //SqlBindString(sql, "@uuid", sUUID);
            if (NWNX_SQL_PrepareQuery(sSelectQuery)) {
                NWNX_SQL_PreparedString(0, sUUID);
                NWNX_SQL_PreparedString(1, GetPCPlayerName(oPlayer));
                NWNX_SQL_PreparedString(2, GetName(oPlayer));
                NWNX_SQL_PreparedString(3, GetPCPublicCDKey(oPlayer));

                NWNX_SQL_ExecutePreparedQuery();

                //if (SqlStep(sql))
                while (NWNX_SQL_ReadyToReadNextRow()) {
                    NWNX_SQL_ReadNextRow();
                    json jItem = JsonParse(NWNX_SQL_ReadDataInActiveRow(4));

                    if (NWNX_SQL_PrepareQuery(sDeleteQuery)) {
                        NWNX_SQL_PreparedString(0, sUUID);
                        NWNX_SQL_PreparedString(1, GetPCPlayerName(oPlayer));
                        NWNX_SQL_PreparedString(2, GetName(oPlayer));
                        NWNX_SQL_PreparedString(3, GetPCPublicCDKey(oPlayer));
                        NWNX_SQL_ExecutePreparedQuery();
                    }
                    /*
                    sql = SqlPrepareQueryCampaign(sDatabase, sDeleteQuery);// Delete the database entry of the item
                    SqlBindString(sql, "@uuid", sUUID);
                    SqlStep(sql);
                    */
                    DelayCommand(fDelay, VoidJsonToObject(jItem, locPlayer, oPlayer, PC_SAVE_ITEM_OBJECT_STATE));
                    nWithdrawnItems++;
                }
            }
        }

        if (nWithdrawnItems == PC_ITEM_WITHDRAW_BATCH)
        {// Here we do some stuff to not withdraw all items at once
            nWithdrawnItems = 0;
            fDelay += PC_ITEM_WITHDRAW_DELAY;
        }
    }
    // Finally update the item list again
    PC_UpdateItemList(oPlayer, nToken);
}

