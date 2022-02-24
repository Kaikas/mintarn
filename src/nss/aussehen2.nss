#include "global_helper"

string ArmorPartIdToColumn(int iPart) {
    string column;
        switch(iPart) {
        case ITEM_APPR_ARMOR_MODEL_TORSO: column = "TORSO"; break;
        case ITEM_APPR_ARMOR_MODEL_BELT: column = "BELT"; break;
        case ITEM_APPR_ARMOR_MODEL_LBICEP: column = "BICEP"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOOT: column = "FOOT"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM: column = "ARM"; break;
        case ITEM_APPR_ARMOR_MODEL_LHAND: column = "HAND"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN: column = "SHIN"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER: column = "SHOUL"; break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH: column = "THIGH"; break;
        case ITEM_APPR_ARMOR_MODEL_NECK: column = "NECK"; break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS: column = "PELVIS"; break;
        case ITEM_APPR_ARMOR_MODEL_RBICEP: column = "BICEP"; break;
        case ITEM_APPR_ARMOR_MODEL_RFOOT: column = "FOOT"; break;
        case ITEM_APPR_ARMOR_MODEL_RFOREARM: column = "ARM"; break;
        case ITEM_APPR_ARMOR_MODEL_RHAND: column = "HAND"; break;
        case ITEM_APPR_ARMOR_MODEL_ROBE: column = "ROBE"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHIN: column = "SHIN"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: column = "SHOUL"; break;
        case ITEM_APPR_ARMOR_MODEL_RTHIGH: column = "THIGH"; break;
    }
    return column;
}


void settoken() {
    SetCustomToken(1000, "[000] Sehr helles Braun");
    SetCustomToken(1001, "[001] Helles Braun");
    SetCustomToken(1002, "[002] Dunkles Braun");
    SetCustomToken(1003, "[003] Sehr dunkles Braun");
    SetCustomToken(1004, "[004] Sehr helles Rot");
    SetCustomToken(1005, "[005] Helles Rot");
    SetCustomToken(1006, "[006] Dunkles Rot");
    SetCustomToken(1007, "[007] Sehr dunkles Rot");
    SetCustomToken(1008, "[008] Sehr helles Gelb");
    SetCustomToken(1009, "[009] Helles Gelb");
    SetCustomToken(1010, "[010] Dunkles Gelb");
    SetCustomToken(1011, "[011] Sehr dunkles Gelb");
    SetCustomToken(1012, "[012] Sehr helles Grau");
    SetCustomToken(1013, "[013] Helles Grau");
    SetCustomToken(1014, "[014] Dunkles Grau");
    SetCustomToken(1015, "[015] Sehr dunkles Grau");
    SetCustomToken(1016, "[016] Sehr helles Olive");
    SetCustomToken(1017, "[017] Helles Olive");
    SetCustomToken(1018, "[018] Dunkles Olive");
    SetCustomToken(1019, "[019] Sehr dunkles Olive");
    SetCustomToken(1020, "[020] Weiß");
    SetCustomToken(1021, "[021] Hellgrau");
    SetCustomToken(1022, "[022] Dunkelgrau");
    SetCustomToken(1023, "[023] Schwarz");
    SetCustomToken(1024, "[024] Hellblau");
    SetCustomToken(1025, "[025] Dunkelblau");
    SetCustomToken(1026, "[026] Hellaquamarin");
    SetCustomToken(1027, "[027] Dunkelaquamarin");
    SetCustomToken(1028, "[028] HellTürkis");
    SetCustomToken(1029, "[029] DuneklTürkis");
    SetCustomToken(1030, "[030] Hellgrün");
    SetCustomToken(1031, "[031] Dunkelgrün");
    SetCustomToken(1032, "[032] Hellgelb");
    SetCustomToken(1033, "[033] Dunkelgelb");
    SetCustomToken(1034, "[034] Hellorange");
    SetCustomToken(1035, "[035] Dunkelorange");
    SetCustomToken(1036, "[036] Hellrot");
    SetCustomToken(1037, "[037] Dunkelrot");
    SetCustomToken(1038, "[038] Hellrosa");
    SetCustomToken(1039, "[039] Dunkelrosa");
    SetCustomToken(1040, "[040] Helllila");
    SetCustomToken(1041, "[041] Dunkellila");
    SetCustomToken(1042, "[042] Hellviolett");
    SetCustomToken(1043, "[043] Dunkelviolett");
    SetCustomToken(1044, "[044] Weiß (glänzend)");
    SetCustomToken(1045, "[045] Schwarz (glänzend)");
    SetCustomToken(1046, "[046] Blau (glänzend)");
    SetCustomToken(1047, "[047] Aquamarin (glänzend)");
    SetCustomToken(1048, "[048] Türkis (glänzend)");
    SetCustomToken(1049, "[049] Grün (glänzend)");
    SetCustomToken(1050, "[050] Gelb (glänzend)");
    SetCustomToken(1051, "[051] Orange (glänzend)");
    SetCustomToken(1052, "[052] Rot (glänzend)");
    SetCustomToken(1053, "[053] Rosa (glänzend)");
    SetCustomToken(1054, "[054] Lila (glänzend)");
    SetCustomToken(1055, "[055] Violett (glänzend)");
    SetCustomToken(1056, "[056] Silber");
    SetCustomToken(1057, "[057] Obsidian");
    SetCustomToken(1058, "[058] Gold");
    SetCustomToken(1059, "[059] Kupfer");
    SetCustomToken(1060, "[060] Grau");
    SetCustomToken(1061, "[061] Spiegelnd");
    SetCustomToken(1062, "[062] Reines Weiß");
    SetCustomToken(1063, "[063] Reines Schwarz");
    SetCustomToken(1064, "[064] Malvenfarbien Metallic");
    SetCustomToken(1065, "[065] Malvenfarben Metallic (gegraut)");
    SetCustomToken(1066, "[066] Gold Metallic");
    SetCustomToken(1067, "[067] Gold Metallic (gegraut)");
    SetCustomToken(1068, "[068] Grün Metallic");
    SetCustomToken(1069, "[069] Grün Metallic");
    SetCustomToken(1070, "[070] Indigo Metallic");
    SetCustomToken(1071, "[071] Indigo Metallic (gegraut)");
    SetCustomToken(1072, "[072] Violett Metallic");
    SetCustomToken(1073, "[073] Violett Metallic (gegraut)");
    SetCustomToken(1074, "[074] Braun Metallic");
    SetCustomToken(1075, "[075] Braun Metallic (gegraut)");
    SetCustomToken(1076, "[076] Türkis Metallic");
    SetCustomToken(1077, "[077] Türkis Metallic (gegraut)");
    SetCustomToken(1078, "[078] Blau Metallic");
    SetCustomToken(1079, "[079] Blau Metallic (gegraut)");
    SetCustomToken(1080, "[080] Olive Metallic");
    SetCustomToken(1081, "[081] Olive Metallic (gegraut)");
    SetCustomToken(1082, "[082] Aquamarin Metallic");
    SetCustomToken(1083, "[083] Aquamarin Metallic (gegraut)");
    SetCustomToken(1084, "[084] Farngrün Metallic (gegraut)");
    SetCustomToken(1085, "[085] Marshland Metallic");
    SetCustomToken(1086, "[086] Marshland Metallic (gegraut)");
    SetCustomToken(1087, "[087] Farngrün (Metallic)");
    SetCustomToken(1088, "[088] Hellstes Rot Metallic");
    SetCustomToken(1089, "[089] Hellrot Metallic");
    SetCustomToken(1090, "[090] Rot Metallic");
    SetCustomToken(1091, "[091] Dunkelrot Metallic");
    SetCustomToken(1092, "[092] Hellstes Gelb Metallic");
    SetCustomToken(1093, "[093] Hellgelb Metallic");
    SetCustomToken(1094, "[094] Gelb Metallic");
    SetCustomToken(1095, "[095] Dunkelgelb Metallic");
    SetCustomToken(1096, "[096] Malvenfarben (sehr hell)");
    SetCustomToken(1097, "[097] Malvenfarben (hell)");
    SetCustomToken(1098, "[098] Malvenfarben");
    SetCustomToken(1099, "[099] Malvenfarben (dunkel)");
    SetCustomToken(1100, "[100] Sangriafarben");
    SetCustomToken(1101, "[101] Sangriafarben");
    SetCustomToken(1102, "[102] Sangriafarben");
    SetCustomToken(1103, "[103] Sangriafarben (dunkel)");
    SetCustomToken(1104, "[104] Waldgrün");
    SetCustomToken(1105, "[105] Waldgrün (hell)");
    SetCustomToken(1106, "[106] Waldgrün");
    SetCustomToken(1107, "[107] Waldgrün (dunkel)");
    SetCustomToken(1108, "[108] Kleefarben (sehr hell)");
    SetCustomToken(1109, "[109] Kleefarben (hell)");
    SetCustomToken(1110, "[110] Kleefarben");
    SetCustomToken(1111, "[111] Kleefarben (dunkel)");
    SetCustomToken(1112, "[112] Marshland (sehr hell)");
    SetCustomToken(1113, "[113] Marshland (hell)");
    SetCustomToken(1114, "[114] Marshland");
    SetCustomToken(1115, "[115] Marshland (dunkel)");
    SetCustomToken(1116, "[116] Hellstes Sienna");
    SetCustomToken(1117, "[117] Helles Sienna");
    SetCustomToken(1118, "[118] Sienna");
    SetCustomToken(1119, "[119] Dunkles Sienna");
    SetCustomToken(1120, "[120] Acorn (sehr hell)");
    SetCustomToken(1121, "[121] Acorn (hell)");
    SetCustomToken(1122, "[122] Acorn");
    SetCustomToken(1123, "[123] Acorn (dunkel)");
    SetCustomToken(1124, "[124] Hellstes Gondola");
    SetCustomToken(1125, "[125] Hell-Gondola");
    SetCustomToken(1126, "[126] Gondola");
    SetCustomToken(1127, "[127] Dunkel-Gondola");
    SetCustomToken(1128, "[128] Hellstes Aschbraun");
    SetCustomToken(1129, "[129] Hell-Aschbraun");
    SetCustomToken(1130, "[130] Aschbraun");
    SetCustomToken(1131, "[131] Dunkel-Aschbraun");
    SetCustomToken(1132, "[132] Hellstes Mirage");
    SetCustomToken(1133, "[133] Hell-Mirage");
    SetCustomToken(1134, "[134] Mirage");
    SetCustomToken(1135, "[135] Dunkel-Mirage");
    SetCustomToken(1136, "[136] Hellstes Mitternachtsblau");
    SetCustomToken(1137, "[137] Hell-Mitternachtsblau");
    SetCustomToken(1138, "[138] Mitternachtsblau");
    SetCustomToken(1139, "[139] Dunkel-Mitternachtsblau");
    SetCustomToken(1140, "[140] Hellstes MattTürkis");
    SetCustomToken(1141, "[141] Helles MattTürkis");
    SetCustomToken(1142, "[142] MattTürkis");
    SetCustomToken(1143, "[143] Dunkles MattTürkis");
    SetCustomToken(1144, "[144] Hellstes Magenta");
    SetCustomToken(1145, "[145] Hellmagenta");
    SetCustomToken(1146, "[146] Magenta");
    SetCustomToken(1147, "[147] Dunkelmagenta");
    SetCustomToken(1148, "[148] Hellhimmelblau");
    SetCustomToken(1149, "[149] Himmelblau");
    SetCustomToken(1150, "[150] Hell-Mosque");
    SetCustomToken(1151, "[151] Mosque");
    SetCustomToken(1152, "[152] Hell-Saftgrün");
    SetCustomToken(1153, "[153] Saftgrün");
    SetCustomToken(1154, "[154] Buttered Rum (hell)");
    SetCustomToken(1155, "[155] Buttered Rum");
    SetCustomToken(1156, "[156] Burnt Sienna (hell)");
    SetCustomToken(1157, "[157] Burnt Sienna");
    SetCustomToken(1158, "[158] Cherrywood (hell");
    SetCustomToken(1159, "[159] Cherrywood");
    SetCustomToken(1160, "[160] Brombeerfarben (hell)");
    SetCustomToken(1161, "[161] Brombeerfarben");
    SetCustomToken(1162, "[162] Ziegelfarben");
    SetCustomToken(1163, "[163] Pink");
    SetCustomToken(1164, "[164] Pale Sky");
    SetCustomToken(1165, "[165] Raincloud");
    SetCustomToken(1166, "[166] Snow");
    SetCustomToken(1167, "[167] Kiefer");
    SetCustomToken(1168, "[168] Kastanie (hell)");
    SetCustomToken(1169, "[169] Kastanie");
    SetCustomToken(1170, "[170] Valentino");
    SetCustomToken(1171, "[171] Ebony Clay");
    SetCustomToken(1172, "[172] Black Forest");
    SetCustomToken(1173, "[173] Dark Cedar");
    SetCustomToken(1174, "[174] Wood Brown");
    SetCustomToken(1175, "[175] Gold gesprenkelt");
}

void setmetaltoken() {
    SetCustomToken(1000, "[000] Silber (sehr hell, glänzend)");
    SetCustomToken(1001, "[001] Silber (hell, glänzend)");
    SetCustomToken(1002, "[002] Obisdian (dunkel, glänzend)");
    SetCustomToken(1003, "[003] Obsidian (sehr dunkel, glänzend)");
    SetCustomToken(1004, "[004] Silber (sehr hell, matt)");
    SetCustomToken(1005, "[005] Silber (hell, matt)");
    SetCustomToken(1006, "[006] Obsidian (dunkel, matt)");
    SetCustomToken(1007, "[007] Obsidian (sehr dunkel, matt)");
    SetCustomToken(1008, "[008] Gold (sehr hell)");
    SetCustomToken(1009, "[009] Gold (hell)");
    SetCustomToken(1010, "[010] Gold (dunkel)");
    SetCustomToken(1011, "[011] Gold (sehr dunkel)");
    SetCustomToken(1012, "[012] Gold (strahlend, sehr hell)");
    SetCustomToken(1013, "[013] Gold (strahlend, hell)");
    SetCustomToken(1014, "[014] Gold (strahlend, dunkel)");
    SetCustomToken(1015, "[015] Gold (strahlend, sehr dunkel)");
    SetCustomToken(1016, "[016] Kupfer (sehr hell)");
    SetCustomToken(1017, "[017] Kupfer (hell)");
    SetCustomToken(1018, "[018] Kupfer (dunkel)");
    SetCustomToken(1019, "[019] Kupfer (sehr dunkel)");
    SetCustomToken(1020, "[020] Bronze (sehr hell)");
    SetCustomToken(1021, "[021] Bronze (hell)");
    SetCustomToken(1022, "[022] Bronze (dunkel)");
    SetCustomToken(1023, "[023] Bronze (sehr dunkel)");
    SetCustomToken(1024, "[024] Hellrot");
    SetCustomToken(1025, "[025] Dunkelrot");
    SetCustomToken(1026, "[026] Hellrot (matt)");
    SetCustomToken(1027, "[027] Dunkelrot (matt)");
    SetCustomToken(1028, "[028] Hellviolett");
    SetCustomToken(1029, "[029] Dunkelviolett");
    SetCustomToken(1030, "[030] Hellviolett (matt)");
    SetCustomToken(1031, "[031] Dunkelviolett (matt)");
    SetCustomToken(1032, "[032] Hellblau");
    SetCustomToken(1033, "[033] Dunkelblau");
    SetCustomToken(1034, "[034] Hellblau (matt)");
    SetCustomToken(1035, "[035] Dunkelblau (matt)");
    SetCustomToken(1036, "[036] Helltürkis");
    SetCustomToken(1037, "[037] Dunkeltürkis");
    SetCustomToken(1038, "[038] Helltürkis (matt)");
    SetCustomToken(1039, "[039] Dunkeltürkis (matt)");
    SetCustomToken(1040, "[040] Hellgrün");
    SetCustomToken(1041, "[041] Dunkelgrün");
    SetCustomToken(1042, "[042] Hellgrün (matt)");
    SetCustomToken(1043, "[043] Dunkelgrün (matt)");
    SetCustomToken(1044, "[044] Hellolive");
    SetCustomToken(1045, "[045] Dunkelolive");
    SetCustomToken(1046, "[046] Hellolive (matt)");
    SetCustomToken(1047, "[047] Dunkelolive (matt)");
    SetCustomToken(1048, "[048] Prismatisch (hell)");
    SetCustomToken(1049, "[049] Prismatisch (dunkel)");
    SetCustomToken(1050, "[050] Rostfarben (sehr hell)");
    SetCustomToken(1051, "[051] Rostfarben (hell)");
    SetCustomToken(1052, "[052] Rostfarben (dunkel)");
    SetCustomToken(1053, "[053] Rostfarben (sehr dunkel)");
    SetCustomToken(1054, "[054] Altes Metall (hell)");
    SetCustomToken(1055, "[055] Altes Metall (dunkel)");
    SetCustomToken(1056, "[056] Silber");
    SetCustomToken(1057, "[057] Obsidian");
    SetCustomToken(1058, "[058] Gold");
    SetCustomToken(1059, "[059] Kupfer");
    SetCustomToken(1060, "[060] Grau");
    SetCustomToken(1061, "[061] Spiegelnd");
    SetCustomToken(1062, "[062] Reines Weiß");
    SetCustomToken(1063, "[063] Reines Schwarz");
    SetCustomToken(1064, "[064] Malve Metallic");
    SetCustomToken(1065, "[065] Malve Metallic (gegraut)");
    SetCustomToken(1066, "[066] Gold Metallic");
    SetCustomToken(1067, "[067] Gold Metallic (gegraut)");
    SetCustomToken(1068, "[068] Grün Metallic");
    SetCustomToken(1069, "[069] Grün Metallic");
    SetCustomToken(1070, "[070] Indigo Metallic");
    SetCustomToken(1071, "[071] Indigo Metallic (gegraut)");
    SetCustomToken(1072, "[072] Violett Metallic");
    SetCustomToken(1073, "[073] Violett Metallic (gegraut)");
    SetCustomToken(1074, "[074] Braun Metallic");
    SetCustomToken(1075, "[075] Braun Metallic (gegraut)");
    SetCustomToken(1076, "[076] Türkis Metallic");
    SetCustomToken(1077, "[077] Türkis Metallic (gegraut)");
    SetCustomToken(1078, "[078] Blau Metallic");
    SetCustomToken(1079, "[079] Blau Metallic (gegraut)");
    SetCustomToken(1080, "[080] Olive Metallic");
    SetCustomToken(1081, "[081] Olive Metallic (gegraut)");
    SetCustomToken(1082, "[082] Aquamarin Metallic");
    SetCustomToken(1083, "[083] Aquamarin Metallic (gegraut)");
    SetCustomToken(1084, "[084] Farngrün Metallic (gegraut)");
    SetCustomToken(1085, "[085] Marshland Metallic");
    SetCustomToken(1086, "[086] Marshland Metallic (gegraut)");
    SetCustomToken(1087, "[087] Farngrünes Metallic");
    SetCustomToken(1088, "[088] Hellstes Rot Metallic");
    SetCustomToken(1089, "[089] Hellrot Metallic");
    SetCustomToken(1090, "[090] Rot Metallic");
    SetCustomToken(1091, "[091] Dunkelrot Metallic");
    SetCustomToken(1092, "[092] Hellstes Gelb Metallic");
    SetCustomToken(1093, "[093] Hellgelb Metallic");
    SetCustomToken(1094, "[094] Gelb Metallic");
    SetCustomToken(1095, "[095] Dunkelgelb Metallic");
    SetCustomToken(1096, "[096] Malve (sehr hell)");
    SetCustomToken(1097, "[097] Malve (hell)");
    SetCustomToken(1098, "[098] Malve");
    SetCustomToken(1099, "[099] Malve (dunkel)");
    SetCustomToken(1100, "[100] Sangriafarben");
    SetCustomToken(1101, "[101] Sangriafarben");
    SetCustomToken(1102, "[102] Sangriafarben");
    SetCustomToken(1103, "[103] Sangriafarben (dunkel)");
    SetCustomToken(1104, "[104] Waldgrün");
    SetCustomToken(1105, "[105] Waldgrün (hell)");
    SetCustomToken(1106, "[106] Waldgrün");
    SetCustomToken(1107, "[107] Waldgrün (dunkel)");
    SetCustomToken(1108, "[108] Kleefarben (sehr hell)");
    SetCustomToken(1109, "[109] Kleefarben (hell)");
    SetCustomToken(1110, "[110] Kleefarben");
    SetCustomToken(1111, "[111] Kleefarben (dunkel)");
    SetCustomToken(1112, "[112] Marshland (sehr hell)");
    SetCustomToken(1113, "[113] Marshland (hell)");
    SetCustomToken(1114, "[114] Marshland");
    SetCustomToken(1115, "[115] Marshland (dunkel)");
    SetCustomToken(1116, "[116] Hellstes Sienna");
    SetCustomToken(1117, "[117] Helles Sienna");
    SetCustomToken(1118, "[118] Sienna");
    SetCustomToken(1119, "[119] Dunkles Sienna");
    SetCustomToken(1120, "[120] Acorn (sehr hell)");
    SetCustomToken(1121, "[121] Acorn (hell)");
    SetCustomToken(1122, "[122] Acorn");
    SetCustomToken(1123, "[123] Acorn (dunkel)");
    SetCustomToken(1124, "[124] Hellstes Gondola");
    SetCustomToken(1125, "[125] Hell-Gondola");
    SetCustomToken(1126, "[126] Gondola");
    SetCustomToken(1127, "[127] Dunkel-Gondola");
    SetCustomToken(1128, "[128] Hellstes Aschbraun");
    SetCustomToken(1129, "[129] Hell-Aschbraun");
    SetCustomToken(1130, "[130] Aschbraun");
    SetCustomToken(1131, "[131] Dunkel-Aschbraun");
    SetCustomToken(1132, "[132] Hellstes Mirage");
    SetCustomToken(1133, "[133] Hell-Mirage");
    SetCustomToken(1134, "[134] Mirage");
    SetCustomToken(1135, "[135] Dunkel-Mirage");
    SetCustomToken(1136, "[136] Hellstes Mitternachtsblau");
    SetCustomToken(1137, "[137] Hell-Mitternachtsblau");
    SetCustomToken(1138, "[138] Mitternachtsblau");
    SetCustomToken(1139, "[139] Dunkel-Mitternachtsblau");
    SetCustomToken(1140, "[140] Hellstes Matttürkis");
    SetCustomToken(1141, "[141] Helles Mattürkis");
    SetCustomToken(1142, "[142] Matttürkis");
    SetCustomToken(1143, "[143] Dunkles Matttürkis");
    SetCustomToken(1144, "[144] Hellstes Magenta");
    SetCustomToken(1145, "[145] Hellmagenta");
    SetCustomToken(1146, "[146] Magenta");
    SetCustomToken(1147, "[147] Dunkelmagenta");
    SetCustomToken(1148, "[148] Hellhimmelblau");
    SetCustomToken(1149, "[149] Himmelblau");
    SetCustomToken(1150, "[150] Hell-Mosque");
    SetCustomToken(1151, "[151] Mosque");
    SetCustomToken(1152, "[152] Hell-Saftgrün");
    SetCustomToken(1153, "[153] Saftgrün");
    SetCustomToken(1154, "[154] Buttered Rum (hell)");
    SetCustomToken(1155, "[155] Buttered Rum");
    SetCustomToken(1156, "[156] Burnt Sienna (hell)");
    SetCustomToken(1157, "[157] Burnt Sienna");
    SetCustomToken(1158, "[158] Cherrywood (hell)");
    SetCustomToken(1159, "[159] Cherrywood");
    SetCustomToken(1160, "[160] Brombeerfarben (hell)");
    SetCustomToken(1161, "[161] Brombeerfarben");
    SetCustomToken(1162, "[162] Ziegelfarben");
    SetCustomToken(1163, "[163] Pink");
    SetCustomToken(1164, "[164] Pale Sky");
    SetCustomToken(1165, "[165] Raincloud");
    SetCustomToken(1166, "[166] Snow");
    SetCustomToken(1167, "[167] Kiefer");
    SetCustomToken(1168, "[168] Kastanie (hell)");
    SetCustomToken(1169, "[169] Kastanie");
    SetCustomToken(1170, "[170] Valentino");
    SetCustomToken(1171, "[171] Ebony Clay");
    SetCustomToken(1172, "[172] Black Forest");
    SetCustomToken(1173, "[173] Dark Cedar");
    SetCustomToken(1174, "[174] Wood Brown");
    SetCustomToken(1175, "[175] Gold gesprenkelt");
}


void TransferItemProperties(object oSource, object oTarget) {
    itemproperty ip = GetFirstItemProperty(oSource);

    string sDescription = GetDescription(oSource);
    if (GetDescription(oTarget) != sDescription) {
        SetDescription(oTarget, sDescription);
    }

    int nItemCursedFlag = GetItemCursedFlag(oSource);
    if (GetItemCursedFlag(oTarget) != nItemCursedFlag) {
        SetItemCursedFlag(oTarget, nItemCursedFlag);
    }

    int nPlotFlag = GetPlotFlag(oSource);
    if (GetPlotFlag(oTarget) != nPlotFlag) {
        SetPlotFlag(oTarget, nPlotFlag);
    }
}


string AppearanceToModel(int iPart, int iAppearance) {
    string sPart = ArmorPartIdToColumn(iPart);
    return Get2DAString("parts_appearance", sPart, iAppearance);
}


int getCurrentArmorModel(object oPc, int iPart) {
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    int iModel = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iPart);
    return iModel;
}


int ModelToAppearance(int iModel, int iPart) {
    int iAppearance = 0;
    while (StringToInt(AppearanceToModel(iPart, iAppearance)) != iModel) {
        iAppearance++;
    }
    return iAppearance;
}


int getFirstValidAppearance(int iPart, int iAC) {
    int i = 0;

    if (iPart == 7) {
        while (StringToInt(Get2DAString("parts_chest", "ACBONUS", StringToInt(AppearanceToModel(7, i)))) != iAC) {
            i++;
        }
    } else {
        i = 0;
    }

    // MessageAll("FirstValid: " + IntToString(i));
    return i;
}


int getLastValidAppearance(int iPart, int iAC) {
    int i = 0;

    if (iPart == 7) {
        while (StringToInt(Get2DAString("parts_chest", "ACBONUS", StringToInt(AppearanceToModel(7, i)))) <= iAC) {
            i++;
        }
    } else {
        while (AppearanceToModel(iPart, i) != "") {
            i++;
        }
    }

    // MessageAll("LastValid: " + IntToString(i));
    return i-1;
}


int getNext(int iPart, int iCurModel, int iStep) {
    int iCurAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iCurModel));
    int iAppearance = ModelToAppearance(iCurModel, iPart);

    int iFirst = getFirstValidAppearance(iPart, iCurAC);
    int iLast = getLastValidAppearance(iPart, iCurAC);

    iAppearance = iAppearance + iStep;

    if (iAppearance > iLast) {
        iAppearance = iFirst;
    } else if (iAppearance < iFirst) {
        iAppearance = iLast;
    } else {
        // iAppearance = iAppearance + iStep;
    }

    // MessageAll("New Appearance: " + IntToString(iAppearance));

    string sModel = AppearanceToModel(iPart, iAppearance);
    return StringToInt(sModel);
}


void changeArmorPartModel(object oPc, int iPart, int iNewModel) {
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    object oNewArmor = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iPart, iNewModel, FALSE);

    // SendMessageToPC(oPc, "Old: " + IntToString(GetItemACValue(oArmor)));
    // SendMessageToPC(oPc, "New: " + IntToString(GetItemACValue(oNewArmor)));

    if (oNewArmor != OBJECT_INVALID) {
        TransferItemProperties(oArmor, oNewArmor);
        AssignCommand(oPc, ActionEquipItem(oNewArmor, INVENTORY_SLOT_CHEST));
        DestroyObject(oArmor);
    }
}


void changeArmorPart(object oPc, string sAction, int iPart) {
    int iCurModel = getCurrentArmorModel(oPc, iPart);
    int iNewModel;

    if(sAction == "RESET") iNewModel = StringToInt(AppearanceToModel(iPart, 0));
    if(sAction == "NEXT") iNewModel = getNext(iPart, iCurModel, 1);
    if(sAction == "PREVIOUS") iNewModel = getNext(iPart, iCurModel, -1);

    changeArmorPartModel(oPc, iPart, iNewModel);

    SendMessageToPC(oPc, "Neues Aussehen: " + IntToString(ModelToAppearance(iNewModel, iPart)));
}



void main() {

    object oPc = GetPCSpeaker();
    object oCurArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);

    if (oCurArmor != OBJECT_INVALID) {
        string sCategory = GetScriptParam("category");

        string sFunction = GetScriptParam("function");
        if (sFunction == "settoken") {settoken(); sCategory = "ARMORCOLOR";};
        if (sFunction == "setvariable") SetLocalString(oPc, GetScriptParam("key"), GetScriptParam("value"));


        int iMaterial = StringToInt(GetLocalString(oPc, "material"));
        if (iMaterial < 4) {
            settoken();
        } else if (iMaterial >= 4) {
            setmetaltoken();
        }

        // SendMessageToPC(oPc, "part " + GetLocalString(oPc, "part"));
        // SendMessageToPC(oPc, "material " + GetLocalString(oPc, "material"));
        // SendMessageToPC(oPc, "color " + GetLocalString(oPc, "color"));


        if (sCategory == "ARMOR" && oCurArmor != OBJECT_INVALID) {
            string sAction = GetScriptParam("action");
            string sPart = GetScriptParam("part");
            changeArmorPart(oPc, sAction, StringToInt(sPart));
        } else if (GetLocalString(oPc, "color") != "" && oCurArmor != OBJECT_INVALID) {
            string sPart = GetLocalString(oPc, "part");
            string sMaterial = GetLocalString(oPc, "material");
            string sColor = GetLocalString(oPc, "color");
            // SendMessageToPC(oPc, "part " + sPart);
            // SendMessageToPC(oPc, "material " + sMaterial);
            // SendMessageToPC(oPc, "color " + sColor);

            int iPart = StringToInt(sPart);
            int iMaterial = StringToInt(sMaterial);
            int iNewColor = StringToInt(sColor) - 1; // -1 to fix offset in conversation
            int iIndex = 6 + (iPart * 6) + iMaterial;

            object oNewArmor = CopyItemAndModify(oCurArmor, ITEM_APPR_TYPE_ARMOR_COLOR, iIndex, iNewColor, FALSE);

            if (oNewArmor != OBJECT_INVALID) {
                TransferItemProperties(oCurArmor, oNewArmor);
                AssignCommand(oPc, ActionEquipItem(oNewArmor, INVENTORY_SLOT_CHEST));
                DestroyObject(oCurArmor);
            }

            SetLocalString(oPc, "color", "");
        }
    } else {
        SendMessageToPC(oPc, "Keine gültige Rüstung gefunden.");
    }
}
