// Creates loot for creatures
void main() {
    int iTreasure = 0;
    int iRandom;
    DelayCommand(1.0, SetLootable(OBJECT_SELF, TRUE));
    SetIsDestroyable(TRUE, FALSE, TRUE);

    // Leder und Fleisch
    if (GetTag(OBJECT_SELF) == "ENEMY_AbgerichteterWorg" ||
        GetTag(OBJECT_SELF) == "ENEMY_Baer" ||
        GetTag(OBJECT_SELF) == "ENEMY_Duesterwolf" ||
        GetTag(OBJECT_SELF) == "ENEMY_Eber" ||
        GetTag(OBJECT_SELF) == "ENEMY_Ratte" ||
        GetTag(OBJECT_SELF) == "ENEMY_Warg" ||
        GetTag(OBJECT_SELF) == "ENEMY_Wolf") {
        iRandom = Random(100);
        if (iRandom > 50 && iRandom < 90) {
            CreateItemOnObject("sw_ro_leder", OBJECT_SELF, 1);
        } else if (iRandom > 89 && iRandom < 99) {
            CreateItemOnObject("sw_ro_gutesleder", OBJECT_SELF, 1);
        } else if (iRandom == 99) {
            CreateItemOnObject("sw_ro_edlesleder", OBJECT_SELF, 1);
        }
        if (Random(4) == 0) {
            CreateItemOnObject("sw_ro_fleisch", OBJECT_SELF, 1);
        }
        if (Random(10) == 0) {
            CreateItemOnObject("sw_we_fangzahn", OBJECT_SELF, 1);
        }
    }

    // Goblins
    if (GetTag(OBJECT_SELF) == "ENEMY_Goblin" ||
        GetTag(OBJECT_SELF) == "ENEMY_GoblinHaeutpling" ||
        GetTag(OBJECT_SELF) == "ENEMY_GoblinJger" ||
        GetTag(OBJECT_SELF) == "ENEMY_GoblinKrieger" ||
        GetTag(OBJECT_SELF) == "ENEMY_GoblinSchamane" ||
        GetTag(OBJECT_SELF) == "ENEMY_Hobgoblin") {
        if (Random(2) == 0) {
            CreateItemOnObject("sw_qu_goblintali", OBJECT_SELF, 1);
        }
        if (Random(4) == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        if (Random(100) == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        if (Random(100) == 0) {
            CreateItemOnObject("sw_we_zerfkleidu", OBJECT_SELF, 1);
        }
    }

    // Ghoul
    if (GetTag(OBJECT_SELF) == "ENEMY_Ghoul") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
    }

    // Mumie
    if (GetTag(OBJECT_SELF) == "ENEMY_Mumie") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_verbandska", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // Skelettkrieger
    if (GetTag(OBJECT_SELF) == "ENEMY_SkelettKrieger") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // Skelett
    if (GetTag(OBJECT_SELF) == "ENEMY_Skelett") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
    }

    // SkelettMagier
    if (GetTag(OBJECT_SELF) == "ENEMY_SkelettMagier") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // SkelettOger
    if (GetTag(OBJECT_SELF) == "ENEMY_SkelettOger") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // SkelettSchuetze
    if (GetTag(OBJECT_SELF) == "ENEMY_SkelettSchtze") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // Zombie
    if (GetTag(OBJECT_SELF) == "ENEMY_StarkerZombie") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
    }

    // Zombie Krieger
    if (GetTag(OBJECT_SELF) == "ENEMY_ZombieKrieger") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
    }

    // Spinne
    if (GetTag(OBJECT_SELF) == "ENEMY_Spinne" ||
        GetTag(OBJECT_SELF) == "ENEMY_Riesenspinne" ||
        GetTag(OBJECT_SELF) == "ENEMY_Grossspinne") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_gift", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_schleim", OBJECT_SELF, 1);
        }
    }

    // Allip und Geist
    if (GetTag(OBJECT_SELF) == "ENEMY_Allip" ||
        GetTag(OBJECT_SELF) == "ENEMY_Geist") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_plasma", OBJECT_SELF, 1);
        }
    }

    // Bandit
    if (GetTag(OBJECT_SELF) == "ENEMY_Bandit") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, Random(5));
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // Echsenmensch, Kobold
    if (GetTag(OBJECT_SELF) == "ENEMY_EchsenmenschKleriker" ||
        GetTag(OBJECT_SELF) == "ENEMY_EchsenmenschKrieger" ||
        GetTag(OBJECT_SELF) == "ENEMY_Echsenmensch" ||
        GetTag(OBJECT_SELF) == "ENEMY_Kobold" ||
        GetTag(OBJECT_SELF) == "ENEMY_KoboldSaenger" ||
        GetTag(OBJECT_SELF) == "ENEMY_Ork" ||
        GetTag(OBJECT_SELF) == "ENEMY_OrkSchamane" ||
        GetTag(OBJECT_SELF) == "ENEMY_OrkScharfrichter" ||
        GetTag(OBJECT_SELF) == "ENEMY_Sahuagin" ||
        GetTag(OBJECT_SELF) == "ENEMY_SahuaginAnfuehrer" ||
        GetTag(OBJECT_SELF) == "ENEMY_SahuaginKleriker" ||
        GetTag(OBJECT_SELF) == "ENEMY_SahuaginKrieger" ||
        GetTag(OBJECT_SELF) == "ENEMY_SahuaginSchamane") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_muenze", OBJECT_SELF, Random(5));
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_zerfruestu", OBJECT_SELF, 1);
        }
        iTreasure = Random(100);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
    }

    // Harpie, Troll, Werwolf, Oger
    if (GetTag(OBJECT_SELF) == "ENEMY_Harpie" ||
        GetTag(OBJECT_SELF) == "ENEMY_Troll" ||
        GetTag(OBJECT_SELF) == "ENEMY_Werwolf" ||
        GetTag(OBJECT_SELF) == "ENEMY_Oger") {
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_fangzahn", OBJECT_SELF, Random(5));
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, Random(20));
        }
        iTreasure = Random(6);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_we_knochen", OBJECT_SELF, 1);
        }
    }


    /////////////////////////////////////
    // BOSSE
    /////////////////////////////////////

    // Brutmutter (Wölfe)
    if (GetTag(OBJECT_SELF) == "ENEMY_Brutmutter") {
        iRandom = Random(100);
        if (iRandom > 50 && iRandom < 90) {
            CreateItemOnObject("sw_ro_leder", OBJECT_SELF, 1);
        } else if (iRandom > 89 && iRandom < 91) {
            CreateItemOnObject("sw_ro_gutesleder", OBJECT_SELF, 1);
        } else if (iRandom > 90) {
            CreateItemOnObject("sw_ro_edlesleder", OBJECT_SELF, 1);
        }
        if (Random(4) == 0) {
            CreateItemOnObject("sw_ro_fleisch", OBJECT_SELF, 1);
        }
        iTreasure = Random(7);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_re_beutel", OBJECT_SELF, 1);
        }
        if (iTreasure == 1) {
            CreateItemOnObject("sw_re_amudex", OBJECT_SELF, 1);
        }
        if (iTreasure == 2) {
            CreateItemOnObject("sw_re_amuint", OBJECT_SELF, 1);
        }
        if (iTreasure == 3) {
            CreateItemOnObject("sw_re_amucon", OBJECT_SELF, 1);
        }
        if (iTreasure == 4) {
            CreateItemOnObject("sw_re_amustr", OBJECT_SELF, 1);
        }
        if (iTreasure == 5) {
            CreateItemOnObject("sw_re_amuwis", OBJECT_SELF, 1);
        }
        if (iTreasure == 6) {
            CreateItemOnObject("sw_re_amucha", OBJECT_SELF, 1);
        }

    }

    // Kriegsmeister (Goblins)
    if (GetTag(OBJECT_SELF) == "ENEMY_Kriegsmeister") {
        CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, 50 + Random(50));
        iTreasure = Random(5);
        if (iTreasure == 0) {
            CreateItemOnObject("sw_re_guertelele", OBJECT_SELF, 1);
        }
        if (iTreasure == 1) {
            CreateItemOnObject("sw_re_guertelene", OBJECT_SELF, 1);
        }
        if (iTreasure == 2) {
            CreateItemOnObject("sw_re_guertelkra", OBJECT_SELF, 1);
        }
        if (iTreasure == 3) {
            CreateItemOnObject("sw_re_guertelgif", OBJECT_SELF, 1);
        }
        if (iTreasure == 4) {
            CreateItemOnObject("sw_re_guertelver", OBJECT_SELF, 1);
        }
        // Size
        SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 1.2);
    }

    // Random walk
    ActionRandomWalk();
}
