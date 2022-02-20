void main() {
    object oPc = GetLastUsedBy();
    object oStore;

    if (GetTag(OBJECT_SELF) == "SHOP_Alchemist_Alrikson") {
        oStore = GetNearestObjectByTag("STORE_Alchemist");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Blumen") {
        oStore = GetNearestObjectByTag("STORE_Blumen");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Lebensmittel_Pina") {
        oStore = GetNearestObjectByTag("STORE_Lebensmittel_Pina");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Lederer_Wilhelm") {
        oStore = GetNearestObjectByTag("STORE_Lederer_Wilhelm");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Musik") {
        oStore = GetNearestObjectByTag("STORE_Musik");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Ooc") {
        oStore = GetNearestObjectByTag("STORE_ooc");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Schmied_Jarnfried") {
        oStore = GetNearestObjectByTag("STORE_Schmied_Jarnfried");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Scheibwaren") {
        oStore = GetNearestObjectByTag("STORE_Schreibwaren");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Schreiner_Ronja") {
        oStore = GetNearestObjectByTag("STORE_Schreiner_Ronja");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Tabak") {
        oStore = GetNearestObjectByTag("STORE_Tabak");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Londor") {
        oStore = GetNearestObjectByTag("STORE_Tempel_Londor");
    }
    if (GetTag(OBJECT_SELF) == "SHOP_Wirt_Fileon") {
        oStore = GetNearestObjectByTag("STORE_Wirt_Fileon");
    }

    if(GetObjectType(oStore) == OBJECT_TYPE_STORE) {
        OpenStore(oStore, oPc);
    }
}
