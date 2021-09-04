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

  // Leichenfresser (Krypta)
  if (GetTag(OBJECT_SELF) == "ENEMY_Leichenfresser") {
    CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, 50 + Random(50));
    CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
    iTreasure = Random(6);
    if (iTreasure == 0) {
      CreateItemOnObject("sw_re_kugelg", OBJECT_SELF, 1);
    }
    if (iTreasure == 1) {
      CreateItemOnObject("sw_re_bolzeng", OBJECT_SELF, 1);
    }
    if (iTreasure == 2) {
      CreateItemOnObject("sw_re_pfeilg", OBJECT_SELF, 1);
    }
    if (iTreasure == 3) {
      CreateItemOnObject("sw_re_grossers", OBJECT_SELF, 1);
    }
    if (iTreasure == 4) {
      CreateItemOnObject("sw_re_kleiners", OBJECT_SELF, 1);
    }
    if (iTreasure == 5) {
      CreateItemOnObject("sw_re_turmschils", OBJECT_SELF, 1);
    }
    // Size
    SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 1.2);
  }

  /////////////////////////////////////
  // KISTEN
  /////////////////////////////////////
  if (GetTag(OBJECT_SELF) == "CHEST_Small") {
    CreateItemOnObject("sw_we_kupfer", OBJECT_SELF, 450 + Random(50));
    CreateItemOnObject("sw_tr_kleineheil", OBJECT_SELF, 1);
    iTreasure = Random(148);
    if (iTreasure == 0) {
      CreateItemOnObject("sw_re_adamantbar.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 1) {
      CreateItemOnObject("sw_re_amucha.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 2) {
      CreateItemOnObject("sw_re_amuchag.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 3) {
      CreateItemOnObject("sw_re_amuchar.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 4) {
      CreateItemOnObject("sw_re_amucon.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 5) {
      CreateItemOnObject("sw_re_amucong.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 6) {
      CreateItemOnObject("sw_re_amuconr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 7) {
      CreateItemOnObject("sw_re_amudex.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 8) {
      CreateItemOnObject("sw_re_amudexg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 9) {
      CreateItemOnObject("sw_re_amudexr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 10) {
      CreateItemOnObject("sw_re_amuint.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 11) {
      CreateItemOnObject("sw_re_amuintg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 12) {
      CreateItemOnObject("sw_re_amuintr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 13) {
      CreateItemOnObject("sw_re_amustr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 14) {
      CreateItemOnObject("sw_re_amustrg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 15) {
      CreateItemOnObject("sw_re_amustrr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 16) {
      CreateItemOnObject("sw_re_amuwis.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 17) {
      CreateItemOnObject("sw_re_amuwisg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 18) {
      CreateItemOnObject("sw_re_amuwisr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 19) {
      CreateItemOnObject("sw_re_bastardg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 20) {
      CreateItemOnObject("sw_re_bastardsch.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 21) {
      CreateItemOnObject("sw_re_beutel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 22) {
      CreateItemOnObject("sw_re_bolzen.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 23) {
      CreateItemOnObject("sw_re_bolzeng.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 24) {
      CreateItemOnObject("sw_re_bolzens.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 25) {
      CreateItemOnObject("sw_re_braten.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 26) {
      CreateItemOnObject("sw_re_dolch.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 27) {
      CreateItemOnObject("sw_re_dolchg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 28) {
      CreateItemOnObject("sw_re_dreizacg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 29) {
      CreateItemOnObject("sw_re_dreizack.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 30) {
      CreateItemOnObject("sw_re_eisenbarre.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 31) {
      CreateItemOnObject("sw_re_fackel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 32) {
      CreateItemOnObject("sw_re_flegel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 33) {
      CreateItemOnObject("sw_re_flegelg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 34) {
      CreateItemOnObject("sw_re_grosserhei.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 35) {
      CreateItemOnObject("sw_re_grosserr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 36) {
      CreateItemOnObject("sw_re_grossers.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 37) {
      CreateItemOnObject("sw_re_grossersch.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 38) {
      CreateItemOnObject("sw_re_grossschwe.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 39) {
      CreateItemOnObject("sw_re_guertelele.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 41) {
      CreateItemOnObject("sw_re_guertelelg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 41) {
      CreateItemOnObject("sw_re_guertelelm.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 42) {
      CreateItemOnObject("sw_re_guertelene.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 43) {
      CreateItemOnObject("sw_re_guerteleng.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 44) {
      CreateItemOnObject("sw_re_guertelenm.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 45) {
      CreateItemOnObject("sw_re_guertelgif.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 46) {
      CreateItemOnObject("sw_re_guertelgig.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 47) {
      CreateItemOnObject("sw_re_guertelgim.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 48) {
      CreateItemOnObject("sw_re_guertelkra.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 49) {
      CreateItemOnObject("sw_re_guertelkrg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 50) {
      CreateItemOnObject("sw_re_guertelkrm.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 51) {
      CreateItemOnObject("sw_re_guertelveg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 52) {
      CreateItemOnObject("sw_re_guertelvem.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 53) {
      CreateItemOnObject("sw_re_guertelver.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 54) {
      CreateItemOnObject("sw_re_hammer.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 55) {
      CreateItemOnObject("sw_re_hammerg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 56) {
      CreateItemOnObject("sw_re_handaxt.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 57) {
      CreateItemOnObject("sw_re_handaxtg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 58) {
      CreateItemOnObject("sw_re_hellebag.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 59) {
      CreateItemOnObject("sw_re_hellebarde.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 60) {
      CreateItemOnObject("sw_re_helm.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 61) {
      CreateItemOnObject("sw_re_helmschgrs.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 62) {
      CreateItemOnObject("sw_re_helmschutz.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 63) {
      CreateItemOnObject("sw_re_kama.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 64) {
      CreateItemOnObject("sw_re_kamag.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 65) {
      CreateItemOnObject("sw_re_katana.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 66) {
      CreateItemOnObject("sw_re_katanag.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 67) {
      CreateItemOnObject("sw_re_kettenpanz.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 68) {
      CreateItemOnObject("sw_re_keule.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 69) {
      CreateItemOnObject("sw_re_keuleg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 70) {
      CreateItemOnObject("sw_re_kleinerhei.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 71) {
      CreateItemOnObject("sw_re_kleinerr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 72) {
      CreateItemOnObject("sw_re_kleiners.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 73) {
      CreateItemOnObject("sw_re_kleinschil.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 74) {
      CreateItemOnObject("sw_re_komposig.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 75) {
      CreateItemOnObject("sw_re_kompositbo.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 76) {
      CreateItemOnObject("sw_re_kriegsag.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 77) {
      CreateItemOnObject("sw_re_kriegsaxt.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 78) {
      CreateItemOnObject("sw_re_kriegshamm.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 79) {
      CreateItemOnObject("sw_re_kriegshg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 80) {
      CreateItemOnObject("sw_re_kugel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 81) {
      CreateItemOnObject("sw_re_kugelg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 82) {
      CreateItemOnObject("sw_re_kugels.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 83) {
      CreateItemOnObject("sw_re_kukri.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 84) {
      CreateItemOnObject("sw_re_kukrig.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 85) {
      CreateItemOnObject("sw_re_kurzbogen.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 86) {
      CreateItemOnObject("sw_re_kurzbogg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 87) {
      CreateItemOnObject("sw_re_kurzschg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 88) {
      CreateItemOnObject("sw_re_kurzschwer.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 89) {
      CreateItemOnObject("sw_re_langbogen.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 90) {
      CreateItemOnObject("sw_re_langbogg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 91) {
      CreateItemOnObject("sw_re_langschg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 92) {
      CreateItemOnObject("sw_re_langschwer.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 93) {
      CreateItemOnObject("sw_re_lederruest.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 94) {
      CreateItemOnObject("sw_re_leicharg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 95) {
      CreateItemOnObject("sw_re_leicharmbr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 96) {
      CreateItemOnObject("sw_re_mithrilbar.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 97) {
      CreateItemOnObject("sw_re_mittlererh.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 98) {
      CreateItemOnObject("sw_re_morgensg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 99) {
      CreateItemOnObject("sw_re_morgenster.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 100) {
      CreateItemOnObject("sw_re_peitsche.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 101) {
      CreateItemOnObject("sw_re_peitschg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 102) {
      CreateItemOnObject("sw_re_pfeil.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 103) {
      CreateItemOnObject("sw_re_pfeilg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 104) {
      CreateItemOnObject("sw_re_pfeils.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 105) {
      CreateItemOnObject("sw_re_pilzragout.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 106) {
      CreateItemOnObject("sw_re_plattenhar.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 107) {
      CreateItemOnObject("sw_re_rapier.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 108) {
      CreateItemOnObject("sw_re_rapierg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 109) {
      CreateItemOnObject("sw_re_saebel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 110) {
      CreateItemOnObject("sw_re_saebelg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 111) {
      CreateItemOnObject("sw_re_schleuder.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 112) {
      CreateItemOnObject("sw_re_schleudg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 113) {
      CreateItemOnObject("sw_re_schwarmbru.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 114) {
      CreateItemOnObject("sw_re_schwarmg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 115) {
      CreateItemOnObject("sw_re_schwfleg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 116) {
      CreateItemOnObject("sw_re_schwflegel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 117) {
      CreateItemOnObject("sw_re_sense.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 118) {
      CreateItemOnObject("sw_re_senseg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 119) {
      CreateItemOnObject("sw_re_shurikeg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 120) {
      CreateItemOnObject("sw_re_shuriken.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 121) {
      CreateItemOnObject("sw_re_sichel.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 122) {
      CreateItemOnObject("sw_re_sichelg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 123) {
      CreateItemOnObject("sw_re_speer.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 124) {
      CreateItemOnObject("sw_re_speerg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 125) {
      CreateItemOnObject("sw_re_stab.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 126) {
      CreateItemOnObject("sw_re_stabg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 127) {
      CreateItemOnObject("sw_re_streitlg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 128) {
      CreateItemOnObject("sw_re_streitlkol.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 129) {
      CreateItemOnObject("sw_re_trankderna.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 130) {
      CreateItemOnObject("sw_re_trankderun.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 131) {
      CreateItemOnObject("sw_re_trankdesge.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 132) {
      CreateItemOnObject("w_re_trankdeskl.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 133) {
      CreateItemOnObject("sw_re_turmr.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 134) {
      CreateItemOnObject("sw_re_turmschild.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 135) {
      CreateItemOnObject("sw_re_turmschils.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 136) {
      CreateItemOnObject("sw_re_umhang.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 137) {
      CreateItemOnObject("sw_re_wurfaxt.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 138) {
      CreateItemOnObject("sw_re_wurfaxtg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 139) {
      CreateItemOnObject("sw_re_wurfpfeg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 140) {
      CreateItemOnObject("sw_re_wurfpfeil.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 141) {
      CreateItemOnObject("sw_re_zhaxt.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 142) {
      CreateItemOnObject("sw_re_zhaxtg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 143) {
      CreateItemOnObject("sw_re_zweiaxt.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 144) {
      CreateItemOnObject("sw_re_zweiaxtg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 145) {
      CreateItemOnObject("sw_re_zweischg.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 146) {
      CreateItemOnObject("sw_re_zweischwer.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 147) {
      CreateItemOnObject("sw_re_zweistreit.uti", OBJECT_SELF, 1);
    } else if (iTreasure == 148) {
      CreateItemOnObject("sw_re_zweistrg.uti", OBJECT_SELF, 1);
    }
  }

  // Random walk
  ActionRandomWalk();
}
