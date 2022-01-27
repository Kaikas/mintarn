#include "nw_inc_nui"
#include "nw_inc_nui_insp"

void MakeSpreadsheet(object pc)
{
    int datarowcount = 10;
    int datacolcount = 5;

    int col, row;

    json template = JsonArray();

    json btndel = NuiVisible(NuiId(NuiButton(JsonString("-")), "btn-"), NuiBind("visible" + IntToString(datacolcount-1)));
    template = JsonArrayInsert(template, NuiListTemplateCell(btndel, 20.0, FALSE));

    template = JsonArrayInsert(template, NuiListTemplateCell(NuiSpacer(), 10.0, FALSE));

    json btnadd = NuiVisible(NuiId(NuiButton(JsonString("+")), "btn+"), NuiBind("visible0"));
    template = JsonArrayInsert(template, NuiListTemplateCell(btnadd, 20.0, FALSE));

    // You could fake adding more columns by templating them, but hiding them with visible=false until needed.
    // NB: The UI system only allows 16 columns in total.
    for (col = 0; col < datacolcount; col++)
    {
      json placeholder = JsonString("empty");
      json value = NuiBind("data" + IntToString(col));
      json elem = NuiTextEdit(placeholder, value, 10, FALSE);
      elem = NuiId(elem, "cell" + IntToString(col));
      elem = NuiMargin(elem, 0.0);
      elem = NuiPadding(elem, 0.0);
      elem = NuiVisible(elem, NuiBind("visible" + IntToString(col)));
      json cell = NuiListTemplateCell(elem, 80.0, FALSE);
      template = JsonArrayInsert(template, cell);
    }

    json jcol = JsonArray();
    jcol = JsonArrayInsert(jcol, NuiList(template, NuiBind("data0"), NUI_STYLE_ROW_HEIGHT, FALSE, NUI_SCROLLBARS_BOTH));

    json jrow = JsonArray();
    jrow = JsonArrayInsert(jrow, NuiHeight(NuiLabel(NuiBind("label"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)), 20.0));
    jcol = JsonArrayInsert(jcol, NuiRow(jrow));

    json root = NuiCol(jcol);
    json nui = NuiWindow(
        root,
        JsonString("Neverwinter Sheets: Excel Edition"),
        NuiBind("geometry"),
        NuiBind("resizable"),
        NuiBind("collapsed"),
        NuiBind("closable"),
        NuiBind("transparent"),
        NuiBind("border"));

    int token = NuiCreate(pc, nui, "spreadsheet");

    NuiSetBind(pc, token, "collapsed", JsonBool(FALSE));
    NuiSetBind(pc, token, "resizable", JsonBool(TRUE));
    NuiSetBind(pc, token, "closable", JsonBool(TRUE));
    NuiSetBind(pc, token, "transparent", JsonBool(FALSE));
    NuiSetBind(pc, token, "border", JsonBool(TRUE));
    NuiSetBind(pc, token, "geometry", NuiRect(830.0, 10.0, 900.0, 600.0));

    NuiSetBind(pc, token, "colcount", JsonInt(datacolcount));

    for (col = 0; col < datacolcount; col++)
    {
      json data = JsonArray();
      json visible = JsonArray();

      for (row = 0; row < datarowcount; row++)
      {
        json seed = JsonString(IntToString(row * datacolcount + col));
        data = JsonArrayInsert(data, seed);
        visible = JsonArrayInsert(visible, JsonBool(1));
      }
      NuiSetBind(pc, token, "data" + IntToString(col), data);
      NuiSetBind(pc, token, "visible" + IntToString(col), visible);
      NuiSetBindWatch(pc, token, "data" + IntToString(col), TRUE);
    }
}

void main() {
    object oPc = OBJECT_SELF;
    SendMessageToPC(oPc, "test");

    MakeSpreadsheet(oPc);
}


