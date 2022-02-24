#include "global_money"
#include "nwnx_webhook"
#include "nwnx_chat"
#include "nwnx_util"
#include "nw_inc_nui"

int CountItems(object oPc, string sTag) {
    int iResult = 0;
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (sTag == GetTag(oItem)) {
            iResult = iResult + 1;
        }
        oItem = GetNextItemInInventory(oPc);
    }
    return iResult;
}

void DestroyItem(object oPc, string sTag) {
    object oItem = GetFirstItemInInventory(oPc);
    while (oItem != OBJECT_INVALID)
    {
        if (sTag == GetTag(oItem)) {
            if (GetItemStackSize(oItem) > 1) {
                SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            } else {
                DestroyObject(oItem);
            }
            return;
        }
        oItem = GetNextItemInInventory(oPc);
    }
}

void DowntimeEvents(object oPc, int nToken, string sType, string sElement) {
    if (sType == "click") {
            if (sElement == "button_abort") {
                NuiDestroy(oPc, nToken);
            }
            if (sElement == "button_select") {
                // Tagewerk
                if (JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected")) == 1) {
                    if (CountItems(oPc, "CRAFT_Aktivitaet")) {
                        DestroyItem(oPc, "CRAFT_Aktivitaet");
                        MONEY_GiveCoinMoneyWorth(1000, oPc);
                        SetLocalString(oPc, "nui_message", "Für eure Arbeit habt ihr 10 Gold erhalten.");
                        //SendMessageToPC(oPc, JsonDump(NuiGetBind(oPc, nToken, "input")));
                        string sAccountName = GetPCPlayerName(oPc);
                        string sName = GetName(oPc);
                        string webhook = NWNX_Util_GetEnvironmentVariable("WEBHOOK_DOWNTIME");
                        NWNX_WebHook_SendWebHookHTTPS("discordapp.com", webhook, sAccountName + " (" + sName +
                            ") hat die Aktivität Tagewerk gewählt und dafür 10 Gold erhalten.", "Mintarn");
                        //StringReplace(JsonGetString(NuiGetBind(oPc, nToken, "input")), "\n", " ")
                        NuiDestroy(oPc, nToken);
                        ExecuteScript("nui_message", oPc);
                    } else {
                        NuiDestroy(oPc, nToken);
                        SetLocalString(oPc, "nui_message", "Ihr habt nicht genügend Aktivitätstoken!");
                        ExecuteScript("nui_message", oPc);
                    }
                }
            }
        }
        if (sType == "watch" && sElement == "dropdownbox_selected") {
            if (JsonGetInt(NuiGetBind(oPc, nToken, "dropdownbox_selected")) == 1) {
                NuiSetBind(oPc, nToken, "text", JsonString("Tagewerk: Ihr geht einem Beruf nach. "));
            }
        }
}

void DowntimeInit(object oPc) {
    json jCol = JsonArray();
    json jCol2 = JsonArray();
    json jCol3 = JsonArray();
    json jRow = JsonArray();

    json jTextContent = JsonString("Dies sind Aktivitäten denen euer " +
        "Charakter nachgehen kann, während ihr nicht eingeloggt seid.");
    json jText = NuiText(NuiBind("text"));
    jText = NuiId(jText, "text");
    json jButtonSelect = NuiButton(JsonString("Wählen"));
    jButtonSelect = NuiId(jButtonSelect, "button_select");
    json jButtonAbort = NuiButton(JsonString("Abbrechen"));
    jButtonAbort = NuiId(jButtonAbort, "button_abort");

    // Dropdown
    json jDropdownboxElement = JsonArray();
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Wähle eine Aktion", 0));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Tagewerk", 1));
    /*
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Eine Zauberschriftrolle herstellen", 2));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Einen Gegenstand herstellen", 3));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Einen magischen Gegenstand kaufen", 4));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Einen magischen Gegenstand verkaufen", 5));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Entspannung", 6));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Glücksspiel", 7));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Gottesdienste", 8));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Grubenkämpfe", 9));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Recherche", 10));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Training", 11));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Verbrechen", 12));
    jDropdownboxElement = JsonArrayInsert(jDropdownboxElement, NuiComboEntry("Zechen", 13));
    */
    json jDropdownbox = NuiCombo(NuiBind("dropdownbox"), NuiBind("dropdownbox_selected"));
    //jDropdownbox = NuiWidth(jDropdownbox, 35);
    jDropdownbox = NuiId(jDropdownbox, "select_downtime");

    jRow = JsonArrayInsert(jRow, jDropdownbox);

    //json jInput = NuiTextEdit(JsonString("Freitext zur Beschreibung der Aktivität."), NuiBind("input"), 1000, TRUE);
    //jInput = NuiHeight(jInput, 100.0);
    //jInput = NuiId(jInput, "input");

    jCol = JsonArrayInsert(JsonArray(), jText);
    //jCol2 = JsonArrayInsert(JsonArray(), jInput);
    jCol3 = JsonArrayInsert(JsonArray(), jButtonSelect);
    jCol3 = JsonArrayInsert(jCol3, jButtonAbort);
    jRow = JsonArrayInsert(jRow, NuiRow(jCol));
    //jRow = JsonArrayInsert(jRow, NuiRow(jCol2));
    jRow = JsonArrayInsert(jRow, NuiRow(jCol3));

    json jRoot = NuiCol(jRow);

    //SendMessageToPC(oPc, JsonDump(jRoot));

    json jWindow = NuiWindow(jRoot,
        JsonString("Aktivitäten"),
        NuiRect(-1.0, -1.0, 330.0, 400.0),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE));
    int token = NuiCreate(oPc, jWindow, "downtime");

    NuiSetBind(oPc, token, "dropdownbox", jDropdownboxElement);
    NuiSetBind(oPc, token, "dropdownbox_selected", jDropdownboxElement);
    NuiSetBindWatch(oPc, token, "dropdownbox_selected", TRUE);
    NuiSetBindWatch(oPc, token, "dropdownbox", TRUE);
    NuiSetBindWatch(oPc, token, "select_downtime", TRUE);
    NuiSetBind(oPc, token, "text", jTextContent);
    //NuiSetBindWatch(oPc, token, "input_watch", TRUE);
    //NuiSetBind(oPc, token, "input", JsonString(""));
}
