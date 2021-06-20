// Mintarn aussehen ändern

void TransferItemProperties(object oSource, object oTarget);

// Initializes the character appearance conversation
void init(object oPc) {
    string sResRef = GetSubString(GetPortraitResRef(oPc), 3, 1000);
    int i;
    for (i = 1; i < 4692; i++) {
        if (Get2DAString("portraits", "BaseResRef", i) == sResRef) {
            SetLocalInt(oPc, "aussehen_portrait", i);
            SetLocalString(oPc, "aussehen_portrait_string", Get2DAString("portraits", "BaseResRef", i));
            SetLocalInt(oPc, "aussehen_portrait_saved", i);
            SetLocalString(oPc, "aussehen_portrait_saved_string", Get2DAString("portraits", "BaseResRef", i));
        }
    }
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
}

// Switches to the next Portrait
void portraitnext(object oPc) {

    int iPortraitId = GetLocalInt(oPc, "aussehen_portrait") + 1;
    if (iPortraitId == 4692) iPortraitId = 1;

    string sInanimateType = Get2DAString("portraits", "InanimateType", iPortraitId);
    string sRace = Get2DAString("portraits", "Race", iPortraitId);
    // Get a valid portrait
    while (sInanimateType == "1" && (sRace != "0" && sRace != "1" && sRace != "2" && sRace != "3" && sRace != "4" && sRace != "5" && sRace != "6")) {
        iPortraitId = iPortraitId + 1;
        if (iPortraitId == 4692) iPortraitId = 1;
        sInanimateType = Get2DAString("portraits", "InanimateType", iPortraitId);
        sRace = Get2DAString("portraits", "Race", iPortraitId);
    }
    string sPortrait = Get2DAString("portraits", "BaseResRef", iPortraitId);
    SetLocalInt(oPc, "aussehen_portrait", iPortraitId);
    SetPortraitResRef(oPc, "po_" + sPortrait);
    ClearAllActions();
    ActionPauseConversation();
    ActionWait(1.0);
    ActionResumeConversation();

}

// Switches to a previous Portrait
void portraitprevious(object oPc) {
    int iPortraitId = GetLocalInt(oPc, "aussehen_portrait") - 1;
    if (iPortraitId == 0) iPortraitId = 4691;

    string sInanimateType = Get2DAString("portraits", "InanimateType", iPortraitId);
    string sRace = Get2DAString("portraits", "Race", iPortraitId);
    // Get a valid portrait
    while (sInanimateType == "1" && (sRace != "0" || sRace != "1" || sRace != "2" || sRace != "3" || sRace != "4" || sRace != "5" || sRace != "6")) {
        iPortraitId = iPortraitId - 1;
        if (iPortraitId == 0) iPortraitId = 4691;
        sInanimateType = Get2DAString("portraits", "InanimateType", iPortraitId);
        sRace = Get2DAString("portraits", "Race", iPortraitId);
    }
    string sPortrait = Get2DAString("portraits", "BaseResRef", iPortraitId);
    SetPortraitResRef(oPc, "po_" + sPortrait);
    SetLocalInt(oPc, "aussehen_portrait", iPortraitId);
}

// Saves the selected Portrait
void portraitsave(object oPc) {
    SetLocalInt(oPc, "aussehen_portrait_saved", GetLocalInt(oPc, "aussehen_portrait"));
    SetLocalString(oPc, "aussehen_portrait_saved_string", GetSubString(GetPortraitResRef(oPc), 3, 1000));
    ExportSingleCharacter(oPc);
}

// Resets the portait and goes back to the main menu
void portraitback(object oPc) {
    SetPortraitResRef(oPc, "po_" + GetLocalString(oPc, "aussehen_portrait_saved_string"));
}

// Changes the torso to the next optic
void torsonext(object oPc) {
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    int iAppearanceNumber = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO) + 1;
    if (iAppearanceNumber > 255) iAppearanceNumber = 1;
    int nAppearance = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    int nNewAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearanceNumber));
    int tries = 0;
    while (nAC != nNewAC && tries < 500) {
        tries = tries + 1;
        iAppearanceNumber = iAppearanceNumber + 1;
        if (iAppearanceNumber == 256) iAppearanceNumber = 1;
        nNewAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearanceNumber));
    }
    if (tries == 500) {
        iAppearanceNumber = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    }
    object oNewArmor = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO, iAppearanceNumber, FALSE);
    if (oNewArmor != OBJECT_INVALID) {
        TransferItemProperties(oArmor, oNewArmor);
        AssignCommand(oPc, ActionEquipItem(oNewArmor, INVENTORY_SLOT_CHEST));
        DestroyObject(oArmor);
        SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
}

// Changes the torso to the previous optic
void torsoprevious(object oPc) {
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    int iAppearanceNumber = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO) - 1;
    if (iAppearanceNumber < 1) iAppearanceNumber = 255;
    int nAppearance = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    int nNewAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearanceNumber));
    int tries = 0;
    while (nAC != nNewAC && tries < 500) {
        iAppearanceNumber = iAppearanceNumber - 1;
        if (iAppearanceNumber == 0) iAppearanceNumber = 255;
        nNewAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearanceNumber));
    }
    if (tries == 500) {
        iAppearanceNumber = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    }
    object oNewArmor = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO, iAppearanceNumber, FALSE);
    if (oNewArmor != OBJECT_INVALID) {
        TransferItemProperties(oArmor, oNewArmor);
        AssignCommand(oPc, ActionEquipItem(oNewArmor, INVENTORY_SLOT_CHEST));
        DestroyObject(oArmor);
        SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
}


// Changes the appearance of a part to the next available one
void armornext(object oPc, int iType, int iMax) {
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    int iAppearanceNumber = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iType);
    iAppearanceNumber = iAppearanceNumber + 1;
    if (iAppearanceNumber > iMax) iAppearanceNumber = 1;
    object oNewArmor = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iType, iAppearanceNumber, FALSE);
    if (oNewArmor != OBJECT_INVALID) {
        TransferItemProperties(oArmor, oNewArmor);
        AssignCommand(oPc, ActionEquipItem(oNewArmor, INVENTORY_SLOT_CHEST));
        DestroyObject(oArmor);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
    SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
}

// Changes the appearance of a part to the previous available one
void armorprevious(object oPc, int iType, int iMax) {
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPc);
    int iAppearanceNumber = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iType);
    iAppearanceNumber = iAppearanceNumber - 1;
    if (iAppearanceNumber < 1) iAppearanceNumber = iMax;
    object oNewArmor = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iType, iAppearanceNumber, FALSE);
    if (oNewArmor != OBJECT_INVALID) {
        TransferItemProperties(oArmor, oNewArmor);
        AssignCommand(oPc, ActionEquipItem(oNewArmor, INVENTORY_SLOT_CHEST));
        DestroyObject(oArmor);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
    SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
}

// Changes the appearance of an item to the next one
void itemnext(object oPc, int iType, int iMax) {
    object oItem = GetItemInSlot(iType, oPc);
    int iAppearanceNumber = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) + 1;
    if (iAppearanceNumber > iMax) iAppearanceNumber = 1;
    if (iType == INVENTORY_SLOT_CLOAK) {
        while (Get2DAString("cloakmodel", "LABEL", iAppearanceNumber) == "") {
            iAppearanceNumber = iAppearanceNumber + 1;
            if (iAppearanceNumber == iMax + 1) iAppearanceNumber = 1;
        }
    }
    object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iAppearanceNumber, FALSE);
    if (oNewItem != OBJECT_INVALID) {
        TransferItemProperties(oItem, oNewItem);
        AssignCommand(oPc, ActionEquipItem(oNewItem, iType));
        DestroyObject(oItem);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
    SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
}

// Changes the appearance of an item to the previous one
void itemprevious(object oPc, int iType, int iMax) {
    object oItem = GetItemInSlot(iType, oPc);
    int iAppearanceNumber = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) - 1;
    if (iAppearanceNumber < 1) iAppearanceNumber = iMax;
    if (iType == INVENTORY_SLOT_CLOAK) {
        while (Get2DAString("cloakmodel", "LABEL", iAppearanceNumber) == "") {
            iAppearanceNumber = iAppearanceNumber - 1;
            if (iAppearanceNumber == 0) iAppearanceNumber = iMax;
        }
    }
    object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iAppearanceNumber, FALSE);
    if (oNewItem != OBJECT_INVALID) {
       TransferItemProperties(oItem, oNewItem);
        AssignCommand(oPc, ActionEquipItem(oNewItem, iType));
        DestroyObject(oItem);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
    SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
}

// Changes the appearance of a shield to the next one
void shieldnext(object oPc) {
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPc);
    if (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD ||
        GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD ||
        GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) {
        int iAppearanceNumber = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) + 1;
        if (iAppearanceNumber > 254) iAppearanceNumber = 1;
        int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearanceNumber));
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iAppearanceNumber, FALSE);
        if (oNewItem != OBJECT_INVALID) {
           TransferItemProperties(oItem, oNewItem);
            AssignCommand(oPc, ActionEquipItem(oNewItem, INVENTORY_SLOT_LEFTHAND));
            DestroyObject(oItem);
        } else {
            SendMessageToPC(oPc, "Could not find valid Model.");
        }
        SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
    }
}

// Change the appearance of a shield to the previous one
void shieldprevious(object oPc) {
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPc);
    if (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD ||
        GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD ||
        GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) {
        int iAppearanceNumber = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) - 1;
        if (iAppearanceNumber < 1) iAppearanceNumber = 255;
        int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", iAppearanceNumber));
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iAppearanceNumber, FALSE);
        if (oNewItem != OBJECT_INVALID) {
            TransferItemProperties(oItem, oNewItem);
            AssignCommand(oPc, ActionEquipItem(oNewItem, INVENTORY_SLOT_LEFTHAND));
            DestroyObject(oItem);
        } else {
            SendMessageToPC(oPc, "Could not find valid Model.");
        }
        SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
    }
}

// Transfers item properties from one item to another
void TransferItemProperties(object oSource, object oTarget) {
    itemproperty ip;
    // Apply properties of source to target.
    ip = GetFirstItemProperty(oSource);
    //while (GetIsItemPropertyValid(ip)) {
    //    AddItemProperty(GetItemPropertyDurationType(ip), ip, oTarget, IntToFloat(GetItemPropertyDurationRemaining(ip)));
    //    ip = GetNextItemProperty(oSource);
    //}
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


// Changes the head to the next available one
void headnext(object oPc) {
    int iMax = 255;
    if (GetRacialType(oPc) == RACIAL_TYPE_DWARF && GetGender(oPc) == GENDER_MALE) iMax = 24;
    if (GetRacialType(oPc) == RACIAL_TYPE_ELF && GetGender(oPc) == GENDER_MALE) iMax = 35;
    if (GetRacialType(oPc) == RACIAL_TYPE_GNOME && GetGender(oPc) == GENDER_MALE) iMax = 35;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFLING && GetGender(oPc) == GENDER_MALE) iMax = 26;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFELF && GetGender(oPc) == GENDER_MALE) iMax = 63;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFORC && GetGender(oPc) == GENDER_MALE) iMax = 25;
    if (GetRacialType(oPc) == RACIAL_TYPE_HUMAN && GetGender(oPc) == GENDER_MALE) iMax = 49;

    if (GetRacialType(oPc) == RACIAL_TYPE_DWARF && GetGender(oPc) == GENDER_FEMALE) iMax = 23;
    if (GetRacialType(oPc) == RACIAL_TYPE_ELF && GetGender(oPc) == GENDER_FEMALE) iMax = 43;
    if (GetRacialType(oPc) == RACIAL_TYPE_GNOME && GetGender(oPc) == GENDER_FEMALE) iMax = 10;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFLING && GetGender(oPc) == GENDER_FEMALE) iMax = 15;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFELF && GetGender(oPc) == GENDER_FEMALE) iMax = 64;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFORC && GetGender(oPc) == GENDER_FEMALE) iMax = 12;
    if (GetRacialType(oPc) == RACIAL_TYPE_HUMAN && GetGender(oPc) == GENDER_FEMALE) iMax = 64;

    int iHead = GetCreatureBodyPart(CREATURE_PART_HEAD, oPc);
    iHead = iHead + 1;
    if (iHead == iMax + 1) iHead = 1;
    SetCreatureBodyPart(CREATURE_PART_HEAD, iHead, oPc);
    SendMessageToPC(oPc, "Model: " + IntToString(iHead));
}

// Changes the head to the previous available one
void headprevious(object oPc) {
    int iMax = 255;
    if (GetRacialType(oPc) == RACIAL_TYPE_DWARF && GetGender(oPc) == GENDER_MALE) iMax = 24;
    if (GetRacialType(oPc) == RACIAL_TYPE_ELF && GetGender(oPc) == GENDER_MALE) iMax = 35;
    if (GetRacialType(oPc) == RACIAL_TYPE_GNOME && GetGender(oPc) == GENDER_MALE) iMax = 35;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFLING && GetGender(oPc) == GENDER_MALE) iMax = 26;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFELF && GetGender(oPc) == GENDER_MALE) iMax = 63;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFORC && GetGender(oPc) == GENDER_MALE) iMax = 25;
    if (GetRacialType(oPc) == RACIAL_TYPE_HUMAN && GetGender(oPc) == GENDER_MALE) iMax = 49;

    if (GetRacialType(oPc) == RACIAL_TYPE_DWARF && GetGender(oPc) == GENDER_FEMALE) iMax = 23;
    if (GetRacialType(oPc) == RACIAL_TYPE_ELF && GetGender(oPc) == GENDER_FEMALE) iMax = 43;
    if (GetRacialType(oPc) == RACIAL_TYPE_GNOME && GetGender(oPc) == GENDER_FEMALE) iMax = 10;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFLING && GetGender(oPc) == GENDER_FEMALE) iMax = 15;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFELF && GetGender(oPc) == GENDER_FEMALE) iMax = 64;
    if (GetRacialType(oPc) == RACIAL_TYPE_HALFORC && GetGender(oPc) == GENDER_FEMALE) iMax = 12;
    if (GetRacialType(oPc) == RACIAL_TYPE_HUMAN && GetGender(oPc) == GENDER_FEMALE) iMax = 64;

    int iHead = GetCreatureBodyPart(CREATURE_PART_HEAD, oPc);
    iHead = iHead - 1;
    if (iHead == 0) iHead = iMax;
    SetCreatureBodyPart(CREATURE_PART_HEAD, iHead, oPc);
    SendMessageToPC(oPc, "Model: " + IntToString(iHead));
}

// Sets the next appearance Model for a weapon
void weaponnext(object oPc, int iPart) {
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPc);
    int iAppearanceNumber = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, iPart);
    iAppearanceNumber = iAppearanceNumber + 1;
    object oNewWeapon = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, iPart, iAppearanceNumber, FALSE);
    if (oNewWeapon == OBJECT_INVALID) {
        oNewWeapon = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, iPart, 1, FALSE);
    }
    if (oNewWeapon != OBJECT_INVALID) {
        TransferItemProperties(oWeapon, oNewWeapon);
        AssignCommand(oPc, ActionEquipItem(oNewWeapon, INVENTORY_SLOT_RIGHTHAND));
        DestroyObject(oWeapon);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
    SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
}

// Sets the previous appearance Model for a weapon
void weaponprevious(object oPc, int iPart) {
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPc);
    int iAppearanceNumber = GetItemAppearance(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, iPart);
    iAppearanceNumber = iAppearanceNumber - 1;
    if (iAppearanceNumber == 0) iAppearanceNumber = 1;
    object oNewWeapon = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, iPart, iAppearanceNumber, FALSE);
    if (oNewWeapon == OBJECT_INVALID) {
        oNewWeapon = CopyItemAndModify(oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, iPart, 1, FALSE);
    }
    if (oNewWeapon != OBJECT_INVALID) {
       TransferItemProperties(oWeapon, oNewWeapon);
        AssignCommand(oPc, ActionEquipItem(oNewWeapon, INVENTORY_SLOT_RIGHTHAND));
        DestroyObject(oWeapon);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
    SendMessageToPC(oPc, "Model: " + IntToString(iAppearanceNumber));
}

// Sets the player to a thin phenotype
void phenotypethin(object oPc) {
    SetPhenoType(PHENOTYPE_NORMAL, oPc);
}

// Sets the player to a thick phenotype
void phenotypethick(object oPc) {
    SetPhenoType(PHENOTYPE_BIG, oPc);
}

// Makes a PC bigger
void sizeincrease(object oPc) {
    float fSize = GetObjectVisualTransform(oPc, OBJECT_VISUAL_TRANSFORM_SCALE) + 0.025;
    SendMessageToPC(oPc, "Faktor: " + FloatToString(fSize));
    if (fSize < 1.50) {
        SetObjectVisualTransform(oPc, OBJECT_VISUAL_TRANSFORM_SCALE, fSize);
    }
}

// Makes a PC smaller
void sizedecrease(object oPc) {
    float fSize = GetObjectVisualTransform(oPc, OBJECT_VISUAL_TRANSFORM_SCALE) - 0.025;
    SendMessageToPC(oPc, "Faktor: " + FloatToString(fSize));
    if (fSize > 0.85) {
        SetObjectVisualTransform(oPc, OBJECT_VISUAL_TRANSFORM_SCALE, fSize);
    }
}

// Sets the next tatoo model on a player
void tattoonext(object oPc) {
    int iAppearance;
    if (GetLocalString(oPc, "tattootarget") == "torso") iAppearance = GetCreatureBodyPart(CREATURE_PART_TORSO, oPc) + 1;
    if (GetLocalString(oPc, "tattootarget") == "armsleft") iAppearance = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oPc) + 1;
    if (GetLocalString(oPc, "tattootarget") == "armsright") iAppearance = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oPc) + 1;
    if (GetLocalString(oPc, "tattootarget") == "forearmsleft") iAppearance = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oPc) + 1;
    if (GetLocalString(oPc, "tattootarget") == "forearmsright") iAppearance = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oPc) + 1;
    if (GetLocalString(oPc, "tattootarget") == "legsleft") iAppearance = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPc) + 1;
    if (GetLocalString(oPc, "tattootarget") == "legslright") iAppearance = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oPc) + 1;
    iAppearance = 2;

    if (GetLocalString(oPc, "tattootarget") == "torso") SetCreatureBodyPart(CREATURE_PART_TORSO, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "armsleft") SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "armsright") SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "forearmsleft") SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "forearmsright") SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "legsleft") SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "legslright") SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, iAppearance, oPc);
}

// Sets the previous tatoo model on a player
void tattooprevious(object oPc) {
    int iAppearance;
    if (GetLocalString(oPc, "tattootarget") == "torso") iAppearance = GetCreatureBodyPart(CREATURE_PART_TORSO, oPc) - 1;
    if (GetLocalString(oPc, "tattootarget") == "armsleft") iAppearance = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oPc) - 1;
    if (GetLocalString(oPc, "tattootarget") == "armsright") iAppearance = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oPc) - 1;
    if (GetLocalString(oPc, "tattootarget") == "forearmsleft") iAppearance = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oPc) - 1;
    if (GetLocalString(oPc, "tattootarget") == "forearmsright") iAppearance = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oPc) - 1;
    if (GetLocalString(oPc, "tattootarget") == "legsleft") iAppearance = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPc) - 1;
    if (GetLocalString(oPc, "tattootarget") == "legslright") iAppearance = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oPc) - 1;
    iAppearance = 1;
    if (GetLocalString(oPc, "tattootarget") == "torso") SetCreatureBodyPart(CREATURE_PART_TORSO, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "armsleft") SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "armsright") SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "forearmsleft") SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "forearmsright") SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "legsleft") SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, iAppearance, oPc);
    if (GetLocalString(oPc, "tattootarget") == "legslright") SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, iAppearance, oPc);
}

// Colors the players Hair, Skin, Tattoo1, Tattoo2
void colorpc(object oPc, int iColorChannel, string sColor) {
    SetColor(oPc, iColorChannel, StringToInt(sColor));
}

// Sets the color of an item
void coloritem(object oPc, int iSlot, string sMaterial, string sColor) {
    //SetColor(oObject, 0, StringToInt(sColor));
    object oItem = GetItemInSlot(iSlot, oPc);

    object oNewItem;
    if (sMaterial == "cloth1") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, StringToInt(sColor));
    if (sMaterial == "cloth2") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, StringToInt(sColor));
    if (sMaterial == "leather1") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, StringToInt(sColor));
    if (sMaterial == "leather2") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, StringToInt(sColor));
    if (sMaterial == "metal1") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, StringToInt(sColor));
    if (sMaterial == "metal2") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, StringToInt(sColor));

    if (oNewItem != OBJECT_INVALID) {
        TransferItemProperties(oItem, oNewItem);
        AssignCommand(oPc, ActionEquipItem(oNewItem, iSlot));
        DestroyObject(oItem);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
}

// Sets the next color for a weapon
void colorweaponnext(object oPc, string sPart) {
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPc);

    int iAppearance;
    if (sPart == "top") iAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);
    if (sPart == "middle") iAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);
    if (sPart == "bottom") iAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);

    object oNewItem;
    if (sPart == "top") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, iAppearance + 1);
    if (sPart == "middle") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, iAppearance + 1);
    if (sPart == "bottom") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, iAppearance + 1);

    if (oNewItem != OBJECT_INVALID) {
        TransferItemProperties(oItem, oNewItem);
        AssignCommand(oPc, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND));
        DestroyObject(oItem);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
}

// Sets the previous color for a weapon
void colorweaponprevious(object oPc, string sPart) {
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPc);

    int iAppearance;
    if (sPart == "top") iAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);
    if (sPart == "middle") iAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);
    if (sPart == "bottom") iAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);

    object oNewItem;
    if (sPart == "top") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, iAppearance - 1);
    if (sPart == "middle") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, iAppearance - 1);
    if (sPart == "bottom") oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, iAppearance - 1);

    if (oNewItem != OBJECT_INVALID) {
        TransferItemProperties(oItem, oNewItem);
        AssignCommand(oPc, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND));
        DestroyObject(oItem);
    } else {
        SendMessageToPC(oPc, "Could not find valid Model.");
    }
}

// Sets the tokens for all colors except metal
void settoken() {
    SetCustomToken(1000, "Sehr helles Braun");
    SetCustomToken(1001, "Helles Braun");
    SetCustomToken(1002, "Dunkles Braun");
    SetCustomToken(1003, "Sehr dunkles Braun");
    SetCustomToken(1004, "Sehr helles Rot");
    SetCustomToken(1005, "Helles Rot");
    SetCustomToken(1006, "Dunkles Rot");
    SetCustomToken(1007, "Sehr dunkles Rot");
    SetCustomToken(1008, "Sehr helles Gelb");
    SetCustomToken(1009, "Helles Gelb");
    SetCustomToken(1010, "Dunkles Gelb");
    SetCustomToken(1011, "Sehr dunkles Gelb");
    SetCustomToken(1012, "Sehr helles Grau");
    SetCustomToken(1013, "Helles Grau");
    SetCustomToken(1014, "Dunkles Grau");
    SetCustomToken(1015, "Sehr dunkles Grau");
    SetCustomToken(1016, "Sehr helles Olive");
    SetCustomToken(1017, "Helles Olive");
    SetCustomToken(1018, "Dunkles Olive");
    SetCustomToken(1019, "Sehr dunkles Olive");
    SetCustomToken(1020, "Weiß");
    SetCustomToken(1021, "Hellgrau");
    SetCustomToken(1022, "Dunkelgrau");
    SetCustomToken(1023, "Schwarz");
    SetCustomToken(1024, "Hellblau");
    SetCustomToken(1025, "Dunkelblau");
    SetCustomToken(1026, "Hellaquamarin");
    SetCustomToken(1027, "Dunkelaquamarin");
    SetCustomToken(1028, "Helltürkis");
    SetCustomToken(1029, "Dunekltürkis");
    SetCustomToken(1030, "Hellgrün");
    SetCustomToken(1031, "Dunkelgrün");
    SetCustomToken(1032, "Hellgelb");
    SetCustomToken(1033, "Dunkelgelb");
    SetCustomToken(1034, "Hellorange");
    SetCustomToken(1035, "Dunkelorange");
    SetCustomToken(1036, "Hellrot");
    SetCustomToken(1037, "Dunkelrot");
    SetCustomToken(1038, "Hellrosa");
    SetCustomToken(1039, "Dunkelrosa");
    SetCustomToken(1040, "Helllila");
    SetCustomToken(1041, "Dunkellila");
    SetCustomToken(1042, "Hellviolett");
    SetCustomToken(1043, "Dunkelviolett");
    SetCustomToken(1044, "Weiß (glänzend)");
    SetCustomToken(1045, "Schwarz (glänzend)");
    SetCustomToken(1046, "Blau (glänzend)");
    SetCustomToken(1047, "Aquamarin (glänzend)");
    SetCustomToken(1048, "Türkis (glänzend)");
    SetCustomToken(1049, "Grün (glänzend)");
    SetCustomToken(1050, "Gelb (glänzend)");
    SetCustomToken(1051, "Orange (glänzend)");
    SetCustomToken(1052, "Rot (glänzend)");
    SetCustomToken(1053, "Rosa (glänzend)");
    SetCustomToken(1054, "Lila (glänzend)");
    SetCustomToken(1055, "Violett (glänzend)");
    SetCustomToken(1056, "Silber");
    SetCustomToken(1057, "Obsidian");
    SetCustomToken(1058, "Gold");
    SetCustomToken(1059, "Kupfer");
    SetCustomToken(1060, "Grau");
    SetCustomToken(1061, "Spiegelnd");
    SetCustomToken(1062, "Reines Weiß");
    SetCustomToken(1063, "Reines Schwarz");
    SetCustomToken(1064, "Malvenfarbien Metallic");
    SetCustomToken(1065, "Malvenfarben Metallic (gegraut)");
    SetCustomToken(1066, "Gold Metallic");
    SetCustomToken(1067, "Gold Metallic (gegraut)");
    SetCustomToken(1068, "Grün Metallic");
    SetCustomToken(1069, "Grün Metallic");
    SetCustomToken(1070, "Indigo Metallic");
    SetCustomToken(1071, "Indigo Metallic (gegraut)");
    SetCustomToken(1072, "Violett Metallic");
    SetCustomToken(1073, "Violett Metallic (gegraut)");
    SetCustomToken(1074, "Braun Metallic");
    SetCustomToken(1075, "Braun Metallic (gegraut)");
    SetCustomToken(1076, "Türkis Metallic");
    SetCustomToken(1077, "Türkis Metallic (gegraut)");
    SetCustomToken(1078, "Blau Metallic");
    SetCustomToken(1079, "Blau Metallic (gegraut)");
    SetCustomToken(1080, "Olive Metallic");
    SetCustomToken(1081, "Olive Metallic (gegraut)");
    SetCustomToken(1082, "Aquamarin Metallic");
    SetCustomToken(1083, "Aquamarin Metallic (gegraut)");
    SetCustomToken(1084, "Farngrün Metallic (gegraut)");
    SetCustomToken(1085, "Marshland Metallic");
    SetCustomToken(1086, "Marshland Metallic (gegraut)");
    SetCustomToken(1087, "Farngrün (Metallic)");
    SetCustomToken(1088, "Hellstes Rot Metallic");
    SetCustomToken(1089, "Hellrot Metallic");
    SetCustomToken(1090, "Rot Metallic");
    SetCustomToken(1091, "Dunkelrot Metallic");
    SetCustomToken(1092, "Hellstes Gelb Metallic");
    SetCustomToken(1093, "Hellgelb Metallic");
    SetCustomToken(1094, "Gelb Metallic");
    SetCustomToken(1095, "Dunkelgelb Metallic");
    SetCustomToken(1096, "Malvenfarben (sehr hell)");
    SetCustomToken(1097, "Malvenfarben (hell)");
    SetCustomToken(1098, "Malvenfarben");
    SetCustomToken(1099, "Malvenfarben (dunkel)");
    SetCustomToken(1100, "Sangriafarben");
    SetCustomToken(1101, "Sangriafarben");
    SetCustomToken(1102, "Sangriafarben");
    SetCustomToken(1103, "Sangriafarben (dunkel)");
    SetCustomToken(1104, "Waldgrün");
    SetCustomToken(1105, "Waldgrün (hell)");
    SetCustomToken(1106, "Waldgrün");
    SetCustomToken(1107, "Waldgrün (dunkel)");
    SetCustomToken(1108, "Kleefarben (sehr hell)");
    SetCustomToken(1109, "Kleefarben (hell)");
    SetCustomToken(1110, "Kleefarben");
    SetCustomToken(1111, "Kleefarben (dunkel)");
    SetCustomToken(1112, "Marshland (sehr hell)");
    SetCustomToken(1113, "Marshland (hell)");
    SetCustomToken(1114, "Marshland");
    SetCustomToken(1115, "Marshland (dunkel)");
    SetCustomToken(1116, "Hellstes Sienna");
    SetCustomToken(1117, "Helles Sienna");
    SetCustomToken(1118, "Sienna");
    SetCustomToken(1119, "Dunkles Sienna");
    SetCustomToken(1120, "Acorn (sehr hell)");
    SetCustomToken(1121, "Acorn (hell)");
    SetCustomToken(1122, "Acorn");
    SetCustomToken(1123, "Acorn (dunkel)");
    SetCustomToken(1124, "Hellstes Gondola");
    SetCustomToken(1125, "Hell-Gondola");
    SetCustomToken(1126, "Gondola");
    SetCustomToken(1127, "Dunkel-Gondola");
    SetCustomToken(1128, "Hellstes Aschbraun");
    SetCustomToken(1129, "Hell-Aschbraun");
    SetCustomToken(1130, "Aschbraun");
    SetCustomToken(1131, "Dunkel-Aschbraun");
    SetCustomToken(1132, "Hellstes Mirage");
    SetCustomToken(1133, "Hell-Mirage");
    SetCustomToken(1134, "Mirage");
    SetCustomToken(1135, "Dunkel-Mirage");
    SetCustomToken(1136, "Hellstes Mitternachtsblau");
    SetCustomToken(1137, "Hell-Mitternachtsblau");
    SetCustomToken(1138, "Mitternachtsblau");
    SetCustomToken(1139, "Dunkel-Mitternachtsblau");
    SetCustomToken(1140, "Hellstes Matttürkis");
    SetCustomToken(1141, "Helles Matttürkis");
    SetCustomToken(1142, "Matttürkis");
    SetCustomToken(1143, "Dunkles Matttürkis");
    SetCustomToken(1144, "Hellstes Magenta");
    SetCustomToken(1145, "Hellmagenta");
    SetCustomToken(1146, "Magenta");
    SetCustomToken(1147, "Dunkelmagenta");
    SetCustomToken(1148, "Hellhimmelblau");
    SetCustomToken(1149, "Himmelblau");
    SetCustomToken(1150, "Hell-Mosque");
    SetCustomToken(1151, "Mosque");
    SetCustomToken(1152, "Hell-Saftgrün");
    SetCustomToken(1153, "Saftgrün");
    SetCustomToken(1154, "Buttered Rum (hell)");
    SetCustomToken(1155, "Buttered Rum");
    SetCustomToken(1156, "Burnt Sienna (hell)");
    SetCustomToken(1157, "Burnt Sienna");
    SetCustomToken(1158, "Cherrywood (hell");
    SetCustomToken(1159, "Cherrywood");
    SetCustomToken(1160, "Brombeerfarben (hell)");
    SetCustomToken(1161, "Brombeerfarben");
    SetCustomToken(1162, "Ziegelfarben");
    SetCustomToken(1163, "Pink");
    SetCustomToken(1164, "Pale Sky");
    SetCustomToken(1165, "Raincloud");
    SetCustomToken(1166, "Snow");
    SetCustomToken(1167, "Kiefer");
    SetCustomToken(1168, "Kastanie (hell)");
    SetCustomToken(1169, "Kastanie");
    SetCustomToken(1170, "Valentino");
    SetCustomToken(1171, "Ebony Clay");
    SetCustomToken(1172, "Black Forest");
    SetCustomToken(1173, "Dark Cedar");
    SetCustomToken(1174, "Wood Brown");
    SetCustomToken(1175, "Gold gesprenkelt");
}

// Sets the tokens for metal colors
void setmetaltoken() {
    SetCustomToken(1000, "Silber (sehr hell, glänzend)");
    SetCustomToken(1001, "Silber (hell, glänzend)");
    SetCustomToken(1002, "Obisdian (dunkel, glänzend)");
    SetCustomToken(1003, "Obsidian (sehr dunkel, glänzend)");
    SetCustomToken(1004, "Silber (sehr hell, matt)");
    SetCustomToken(1005, "Silber (hell, matt)");
    SetCustomToken(1006, "Obsidian (dunkel, matt)");
    SetCustomToken(1007, "Obsidian (sehr dunkel, matt)");
    SetCustomToken(1008, "Gold (sehr hell)");
    SetCustomToken(1009, "Gold (hell)");
    SetCustomToken(1010, "Gold (dunkel)");
    SetCustomToken(1011, "Gold (sehr dunkel)");
    SetCustomToken(1012, "Gold (strahlend, sehr hell)");
    SetCustomToken(1013, "Gold (strahlend, hell)");
    SetCustomToken(1014, "Gold (strahlend, dunkel)");
    SetCustomToken(1015, "Gold (strahlend, sehr dunkel)");
    SetCustomToken(1016, "Kupfer (sehr hell)");
    SetCustomToken(1017, "Kupfer (hell)");
    SetCustomToken(1018, "Kupfer (dunkel)");
    SetCustomToken(1019, "Kupfer (sehr dunkel)");
    SetCustomToken(1020, "Bronze (sehr hell)");
    SetCustomToken(1021, "Bronze (hell)");
    SetCustomToken(1022, "Bronze (dunkel)");
    SetCustomToken(1023, "Bronze (sehr dunkel)");
    SetCustomToken(1024, "Hellrot");
    SetCustomToken(1025, "Dunkelrot");
    SetCustomToken(1026, "Hellrot (matt)");
    SetCustomToken(1027, "Dunkelrot (matt)");
    SetCustomToken(1028, "Hellviolett");
    SetCustomToken(1029, "Dunkelviolett");
    SetCustomToken(1030, "Hellviolett (matt)");
    SetCustomToken(1031, "Dunkelviolett (matt)");
    SetCustomToken(1032, "Hellblau");
    SetCustomToken(1033, "Dunkelblau");
    SetCustomToken(1034, "Hellblau (matt)");
    SetCustomToken(1035, "Dunkelblau (matt)");
    SetCustomToken(1036, "Helltürkis");
    SetCustomToken(1037, "Dunkeltürkis");
    SetCustomToken(1038, "Helltürkis (matt)");
    SetCustomToken(1039, "Dunkeltürkis (matt)");
    SetCustomToken(1040, "Hellgrün");
    SetCustomToken(1041, "Dunkelgrün");
    SetCustomToken(1042, "Hellgrün (matt)");
    SetCustomToken(1043, "Dunkelgrün (matt)");
    SetCustomToken(1044, "Hellolive");
    SetCustomToken(1045, "Dunkelolive");
    SetCustomToken(1046, "Hellolive (matt)");
    SetCustomToken(1047, "Dunkelolive (matt)");
    SetCustomToken(1048, "Prismatisch (hell)");
    SetCustomToken(1049, "Prismatisch (dunkel)");
    SetCustomToken(1050, "Rostfarben (sehr hell)");
    SetCustomToken(1051, "Rostfarben (hell)");
    SetCustomToken(1052, "Rostfarben (dunkel)");
    SetCustomToken(1053, "Rostfarben (sehr dunkel)");
    SetCustomToken(1054, "Altes Metall (hell)");
    SetCustomToken(1055, "Altes Metall (dunkel)");
    SetCustomToken(1056, "Silber");
    SetCustomToken(1057, "Obsidian");
    SetCustomToken(1058, "Gold");
    SetCustomToken(1059, "Kupfer");
    SetCustomToken(1060, "Grau");
    SetCustomToken(1061, "Spiegelnd");
    SetCustomToken(1062, "Reines Weiß");
    SetCustomToken(1063, "Reines Schwarz");
    SetCustomToken(1064, "Malve Metallic");
    SetCustomToken(1065, "Malve Metallic (gegraut)");
    SetCustomToken(1066, "Gold Metallic");
    SetCustomToken(1067, "Gold Metallic (gegraut)");
    SetCustomToken(1068, "Grün Metallic");
    SetCustomToken(1069, "Grün Metallic");
    SetCustomToken(1070, "Indigo Metallic");
    SetCustomToken(1071, "Indigo Metallic (gegraut)");
    SetCustomToken(1072, "Violett Metallic");
    SetCustomToken(1073, "Violett Metallic (gegraut)");
    SetCustomToken(1074, "Braun Metallic");
    SetCustomToken(1075, "Braun Metallic (gegraut)");
    SetCustomToken(1076, "Türkis Metallic");
    SetCustomToken(1077, "Türkis Metallic (gegraut)");
    SetCustomToken(1078, "Blau Metallic");
    SetCustomToken(1079, "Blau Metallic (gegraut)");
    SetCustomToken(1080, "Olive Metallic");
    SetCustomToken(1081, "Olive Metallic (gegraut)");
    SetCustomToken(1082, "Aquamarin Metallic");
    SetCustomToken(1083, "Aquamarin Metallic (gegraut)");
    SetCustomToken(1084, "Farngrün Metallic (gegraut)");
    SetCustomToken(1085, "Marshland Metallic");
    SetCustomToken(1086, "Marshland Metallic (gegraut)");
    SetCustomToken(1087, "Farngrünes Metallic");
    SetCustomToken(1088, "Hellstes Rot Metallic");
    SetCustomToken(1089, "Hellrot Metallic");
    SetCustomToken(1090, "Rot Metallic");
    SetCustomToken(1091, "Dunkelrot Metallic");
    SetCustomToken(1092, "Hellstes Gelb Metallic");
    SetCustomToken(1093, "Hellgelb Metallic");
    SetCustomToken(1094, "Gelb Metallic");
    SetCustomToken(1095, "Dunkelgelb Metallic");
    SetCustomToken(1096, "Malve (sehr hell)");
    SetCustomToken(1097, "Malve (hell)");
    SetCustomToken(1098, "Malve");
    SetCustomToken(1099, "Malve (dunkel)");
    SetCustomToken(1100, "Sangriafarben");
    SetCustomToken(1101, "Sangriafarben");
    SetCustomToken(1102, "Sangriafarben");
    SetCustomToken(1103, "Sangriafarben (dunkel)");
    SetCustomToken(1104, "Waldgrün");
    SetCustomToken(1105, "Waldgrün (hell)");
    SetCustomToken(1106, "Waldgrün");
    SetCustomToken(1107, "Waldgrün (dunkel)");
    SetCustomToken(1108, "Kleefarben (sehr hell)");
    SetCustomToken(1109, "Kleefarben (hell)");
    SetCustomToken(1110, "Kleefarben");
    SetCustomToken(1111, "Kleefarben (dunkel)");
    SetCustomToken(1112, "Marshland (sehr hell)");
    SetCustomToken(1113, "Marshland (hell)");
    SetCustomToken(1114, "Marshland");
    SetCustomToken(1115, "Marshland (dunkel)");
    SetCustomToken(1116, "Hellstes Sienna");
    SetCustomToken(1117, "Helles Sienna");
    SetCustomToken(1118, "Sienna");
    SetCustomToken(1119, "Dunkles Sienna");
    SetCustomToken(1120, "Acorn (sehr hell)");
    SetCustomToken(1121, "Acorn (hell)");
    SetCustomToken(1122, "Acorn");
    SetCustomToken(1123, "Acorn (dunkel)");
    SetCustomToken(1124, "Hellstes Gondola");
    SetCustomToken(1125, "Hell-Gondola");
    SetCustomToken(1126, "Gondola");
    SetCustomToken(1127, "Dunkel-Gondola");
    SetCustomToken(1128, "Hellstes Aschbraun");
    SetCustomToken(1129, "Hell-Aschbraun");
    SetCustomToken(1130, "Aschbraun");
    SetCustomToken(1131, "Dunkel-Aschbraun");
    SetCustomToken(1132, "Hellstes Mirage");
    SetCustomToken(1133, "Hell-Mirage");
    SetCustomToken(1134, "Mirage");
    SetCustomToken(1135, "Dunkel-Mirage");
    SetCustomToken(1136, "Hellstes Mitternachtsblau");
    SetCustomToken(1137, "Hell-Mitternachtsblau");
    SetCustomToken(1138, "Mitternachtsblau");
    SetCustomToken(1139, "Dunkel-Mitternachtsblau");
    SetCustomToken(1140, "Hellstes Matttürkis");
    SetCustomToken(1141, "Helles Mattürkis");
    SetCustomToken(1142, "Matttürkis");
    SetCustomToken(1143, "Dunkles Matttürkis");
    SetCustomToken(1144, "Hellstes Magenta");
    SetCustomToken(1145, "Hellmagenta");
    SetCustomToken(1146, "Magenta");
    SetCustomToken(1147, "Dunkelmagenta");
    SetCustomToken(1148, "Hellhimmelblau");
    SetCustomToken(1149, "Himmelblau");
    SetCustomToken(1150, "Hell-Mosque");
    SetCustomToken(1151, "Mosque");
    SetCustomToken(1152, "Hell-Saftgrün");
    SetCustomToken(1153, "Saftgrün");
    SetCustomToken(1154, "Buttered Rum (hell)");
    SetCustomToken(1155, "Buttered Rum");
    SetCustomToken(1156, "Burnt Sienna (hell)");
    SetCustomToken(1157, "Burnt Sienna");
    SetCustomToken(1158, "Cherrywood (hell)");
    SetCustomToken(1159, "Cherrywood");
    SetCustomToken(1160, "Brombeerfarben (hell)");
    SetCustomToken(1161, "Brombeerfarben");
    SetCustomToken(1162, "Ziegelfarben");
    SetCustomToken(1163, "Pink");
    SetCustomToken(1164, "Pale Sky");
    SetCustomToken(1165, "Raincloud");
    SetCustomToken(1166, "Snow");
    SetCustomToken(1167, "Kiefer");
    SetCustomToken(1168, "Kastanie (hell)");
    SetCustomToken(1169, "Kastanie");
    SetCustomToken(1170, "Valentino");
    SetCustomToken(1171, "Ebony Clay");
    SetCustomToken(1172, "Black Forest");
    SetCustomToken(1173, "Dark Cedar");
    SetCustomToken(1174, "Wood Brown");
    SetCustomToken(1175, "Gold gesprenkelt");
}

// Main
void main() {
    object oPc = GetPCSpeaker();
    if (GetScriptParam("action") == "init") init(oPc);
    // Armour
    if (GetScriptParam("action") == "portraitnext") portraitnext(oPc);
    if (GetScriptParam("action") == "portraitprevious") portraitprevious(oPc);
    if (GetScriptParam("action") == "portraitsave") portraitsave(oPc);
    if (GetScriptParam("action") == "portraitback") portraitback(oPc);
    if (GetScriptParam("action") == "torsonext") torsonext(oPc);
    if (GetScriptParam("action") == "torsoprevious") torsoprevious(oPc);
    if (GetScriptParam("action") == "robenext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_ROBE, 200);
    if (GetScriptParam("action") == "robeprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_ROBE, 200);
    if (GetScriptParam("action") == "bizepslinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LBICEP, 85);
    if (GetScriptParam("action") == "bizepslinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LBICEP, 85);
    if (GetScriptParam("action") == "bizepsrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RBICEP, 85);
    if (GetScriptParam("action") == "bizepsrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RBICEP, 85);
    if (GetScriptParam("action") == "unterarmlinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LFOREARM, 75);
    if (GetScriptParam("action") == "unterarmlinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LFOREARM, 75);
    if (GetScriptParam("action") == "unterarmrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RFOREARM, 75);
    if (GetScriptParam("action") == "unterarmrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RFOREARM, 75);
    if (GetScriptParam("action") == "schulterrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RSHOULDER, 39);
    if (GetScriptParam("action") == "schulterrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RSHOULDER, 39);
    if (GetScriptParam("action") == "schulterlinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LSHOULDER, 39);
    if (GetScriptParam("action") == "schulterlinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LSHOULDER, 39);
    if (GetScriptParam("action") == "guertelnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_BELT, 149);
    if (GetScriptParam("action") == "guertelprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_BELT, 149);
    if (GetScriptParam("action") == "beckennext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_PELVIS, 53);
    if (GetScriptParam("action") == "beckenprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_PELVIS, 53);
    if (GetScriptParam("action") == "fusslinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LFOOT, 55);
    if (GetScriptParam("action") == "fusslinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LFOOT, 55);
    if (GetScriptParam("action") == "fussrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RFOOT, 55);
    if (GetScriptParam("action") == "fussrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RFOOT, 55);
    if (GetScriptParam("action") == "halsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_NECK, 40);
    if (GetScriptParam("action") == "halsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_NECK, 40);
    if (GetScriptParam("action") == "schienbeinlinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LSHIN, 76);
    if (GetScriptParam("action") == "schienbeinlinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LSHIN, 76);
    if (GetScriptParam("action") == "schienbeinrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RSHIN, 76);
    if (GetScriptParam("action") == "schienbeinrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RSHIN, 76);
    if (GetScriptParam("action") == "handlinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LHAND, 35);
    if (GetScriptParam("action") == "handlinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LHAND, 35);
    if (GetScriptParam("action") == "handrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RHAND, 35);
    if (GetScriptParam("action") == "handrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RHAND, 35);
    if (GetScriptParam("action") == "oberschenkellinksnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_LTHIGH, 73);
    if (GetScriptParam("action") == "oberschenkellinksprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_LTHIGH, 73);
    if (GetScriptParam("action") == "oberschenkelrechtsnext") armornext(oPc, ITEM_APPR_ARMOR_MODEL_RTHIGH, 73);
    if (GetScriptParam("action") == "oberschenkelrechtsprevious") armorprevious(oPc, ITEM_APPR_ARMOR_MODEL_RTHIGH, 73);
    // Helmets
    if (GetScriptParam("action") == "helmnext") itemnext(oPc, INVENTORY_SLOT_HEAD, 124);
    if (GetScriptParam("action") == "helmprevious") itemprevious(oPc, INVENTORY_SLOT_HEAD, 124);
    // Cloaks
    if (GetScriptParam("action") == "umhangnext") itemnext(oPc, INVENTORY_SLOT_CLOAK, 255);
    if (GetScriptParam("action") == "umhangprevious") itemprevious(oPc, INVENTORY_SLOT_CLOAK, 255);
    // Shields
    if (GetScriptParam("action") == "schildnext") shieldnext(oPc);
    if (GetScriptParam("action") == "schildprevious") shieldprevious(oPc);
    // Head
    if (GetScriptParam("action") == "kopfnext") headnext(oPc);
    if (GetScriptParam("action") == "kopfprevious") headprevious(oPc);
    // Waffe
    if (GetScriptParam("action") == "waffespitzenext") weaponnext(oPc, ITEM_APPR_WEAPON_MODEL_TOP);
    if (GetScriptParam("action") == "waffespitzeprevious") weaponprevious(oPc, ITEM_APPR_WEAPON_MODEL_TOP);
    if (GetScriptParam("action") == "waffemitteenext") weaponnext(oPc, ITEM_APPR_WEAPON_MODEL_MIDDLE);
    if (GetScriptParam("action") == "waffemitteprevious") weaponprevious(oPc, ITEM_APPR_WEAPON_MODEL_MIDDLE);
    if (GetScriptParam("action") == "waffegriffnext") weaponnext(oPc, ITEM_APPR_WEAPON_MODEL_BOTTOM);
    if (GetScriptParam("action") == "waffegriffprevious") weaponprevious(oPc, ITEM_APPR_WEAPON_MODEL_BOTTOM);
    // Phenotype
    if (GetScriptParam("action") == "phenotypduenn") phenotypethin(oPc);
    if (GetScriptParam("action") == "phenotypdick") phenotypethick(oPc);
    // Size
    if (GetScriptParam("action") == "sizeincrease") sizeincrease(oPc);
    if (GetScriptParam("action") == "sizedecrease") sizedecrease(oPc);
    // Tattoo
    if (GetScriptParam("action") == "tattoonext") tattoonext(oPc);
    if (GetScriptParam("action") == "tattooprevious") tattooprevious(oPc);
    if (GetScriptParam("action") == "settattootarget") SetLocalString(oPc, "tattootarget", GetScriptParam("target"));
    // Set the color target
    if (GetScriptParam("action") == "setcolortarget") {
        SetLocalString(oPc, "colortarget", GetScriptParam("target"));
        settoken();
    }
    // Set the color Material
    if (GetScriptParam("action") == "setcolormaterial") SetLocalString(oPc, "colormaterial", GetScriptParam("material"));
    if (GetScriptParam("action") == "setcolormaterial" && (GetScriptParam("material") == "metal1" || GetScriptParam("material") == "metal2")) {
        setmetaltoken();
    }
    // Skin, Hair, Tattoos
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "skin") colorpc(oPc, COLOR_CHANNEL_SKIN, GetScriptParam("color"));
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "hair") colorpc(oPc, COLOR_CHANNEL_HAIR, GetScriptParam("color"));
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "tattoo1") colorpc(oPc, COLOR_CHANNEL_TATTOO_1, GetScriptParam("color"));
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "tattoo2") colorpc(oPc, COLOR_CHANNEL_TATTOO_2, GetScriptParam("color"));
    // Helms
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "helm") coloritem(oPc, INVENTORY_SLOT_HEAD, GetLocalString(oPc, "colormaterial"), GetScriptParam("color"));
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "cloak") coloritem(oPc, INVENTORY_SLOT_CLOAK, GetLocalString(oPc, "colormaterial"), GetScriptParam("color"));
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "armor") coloritem(oPc, INVENTORY_SLOT_CHEST, GetLocalString(oPc, "colormaterial"), GetScriptParam("color"));
    if (GetScriptParam("action") == "dye" && GetLocalString(oPc, "colortarget") == "shield") coloritem(oPc, INVENTORY_SLOT_LEFTHAND, GetLocalString(oPc, "colormaterial"), GetScriptParam("color"));
    // Weapons
    if (GetScriptParam("action") == "weaponcolornext") colorweaponnext(oPc, GetScriptParam("part"));
    if (GetScriptParam("action") == "weaponcolorprevious") colorweaponprevious(oPc, GetScriptParam("part"));




    // https://nwnlexicon.com/index.php?title=Item_appr
    // https://nwnlexicon.com/index.php?title=Inventory_slot
}
