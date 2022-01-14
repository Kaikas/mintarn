void main()
{
    int iToken = 666;
    object oPC = GetPCSpeaker();
    string sItem = GetScriptParam("item");
    int iSell = StringToInt(GetScriptParam("sell"));
    int iCount = 0;


    //Goblin-Talismane
    if(sItem == "goblin"){
    object oItem = GetFirstItemInInventory(oPC);
        while (oItem != OBJECT_INVALID)
        {
            if(GetTag(oItem) == "QUEST_GoblinTalisman"){
                iCount++;
                if(iSell == 1){DestroyObject(oItem);}
            }
            oItem = GetNextItemInInventory(oPC);
        }

        if(iSell == 0){
        SetCustomToken(iToken, "Also " + IntToString(iCount) + " Anhänger, ja?\nDas sind dann " + IntToString(iCount*2) + " Kupferstücke.");
        }
        if(iSell == 1){
        CreateItemOnObject("sw_we_kupfer", oPC, iCount*2);
        }
    }
    //Holzscheite
    if(sItem == "holz"){
        object oItem = GetFirstItemInInventory(oPC);
        while (oItem != OBJECT_INVALID)
        {
            if(GetTag(oItem) == "CRAFT_Eichenholz" ||
                GetTag(oItem) == "CRAFT_Eschenholz" ||
                GetTag(oItem) == "CRAFT_Birkenholz"){
                iCount++;
                if(iSell == 1){DestroyObject(oItem);}
            }
            oItem = GetNextItemInInventory(oPC);
        }

        if(iSell == 0){
        SetCustomToken(iToken, "Also " + IntToString(iCount) + " Stück Holz, ja?\nDas sind dann " + IntToString(iCount*2) + " Kupferstücke.");
        }
        if(iSell == 1){
        CreateItemOnObject("sw_we_kupfer", oPC, iCount*2);
        }
    }
    //Jegliche Kräuter
    if(sItem == "kraut"){
        object oItem = GetFirstItemInInventory(oPC);
        while (oItem != OBJECT_INVALID)
        {
            if(GetTag(oItem) == "CRAFT_Arganwurzel" ||
                GetTag(oItem) == "CRAFT_Brorkwilb" ||
                GetTag(oItem) == "CRAFT_Arkasu" ||
                GetTag(oItem) == "CRAFT_Carlog" ||
                GetTag(oItem) == "CRAFT_Pilz" ||
                GetTag(oItem) == "CRAFT_Chronichinis" ||
                GetTag(oItem) == "CRAFT_Hiradwurz" ||
                GetTag(oItem) == "CRAFT_Wirselkraut"){
                iCount++;
                if(iSell == 1){DestroyObject(oItem);}
            }
            oItem = GetNextItemInInventory(oPC);
        }

        if(iSell == 0){
            SetCustomToken(iToken, "Also " + IntToString(iCount) + " Kräuter, ja?\nDas sind dann " + IntToString(iCount*2) + " Kupferstücke.");
        }
        if(iSell == 1){
            CreateItemOnObject("sw_we_kupfer", oPC, iCount*2);
        }
    }
    //Erzbrocken
    if(sItem == "erz"){
        object oItem = GetFirstItemInInventory(oPC);
        while (oItem != OBJECT_INVALID)
        {
            if(GetTag(oItem) == "CRAFT_Adamanterz" ||
                GetTag(oItem) == "CRAFT_Eisenerz" ||
                GetTag(oItem) == "CRAFT_Mithrilerz"){
                iCount++;
                if(iSell == 1){DestroyObject(oItem);}
            }
            oItem = GetNextItemInInventory(oPC);
        }

        if(iSell == 0){
            SetCustomToken(iToken, "Also " + IntToString(iCount) + " Erzbrocken, ja?\nDas sind dann " + IntToString(iCount*3) + " Kupferstücke.");
        }
        if(iSell == 1){
            CreateItemOnObject("sw_we_kupfer", oPC, iCount*2);
        }
    }
}
