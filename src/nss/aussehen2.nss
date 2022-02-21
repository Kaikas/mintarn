#include "global_helper"

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


string AppearanceToModel(int iPart, int iAppearance) {
    string sPart = ArmorPartIdToColumn(iPart);
    return Get2DAString("app", sPart, iAppearance);
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
    string sCategory = GetScriptParam("category");
    string sAction = GetScriptParam("action");
    string sPart = GetScriptParam("part");

    // SendMessageToPC(oPc, sPart);

    if (sCategory == "ARMOR") {
        changeArmorPart(oPc, sAction, StringToInt(sPart));
    }

}
