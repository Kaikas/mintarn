void healstep(object oPc, object oHealer) {
    if (GetMaxHitPoints(oPc) == GetCurrentHitPoints(oPc)) {
        effect eEffect = GetFirstEffect(oPc);
        while(GetIsEffectValid(eEffect)) {
            if(GetEffectTag(eEffect) == "eff_immobilize") RemoveEffect(oPc, eEffect);
            if(GetEffectTag(eEffect) == "eff_dazed") RemoveEffect(oPc, eEffect);
            eEffect = GetNextEffect(oPc);
        }
    } else {
        int iRand = Random(10);
        if (iRand == 0) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("<cÙ§`>*Die Halborkin zieht einige male an einem Faden sodass ein leises \"Pling, Pling, Pling\" ertönt.*</c> Und zu die Naht. Hähä.", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Knochensäge! Knochensäge! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString("Nänä, allz gut Collin! <cÙ§`>*Sie winkt in Richtung ihres Papageien*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 1) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("<cÙ§`>*Mit konzentriertem Blick und aus dem Mundwinkel geschobener Zunge macht die Halborkin ein paar Nadelstiche.*</c> ", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Amputieren! Amputieren! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 2) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("<cÙ§`>*Mit den Fingern tastet sie die Ränder einer Wunde entlang.*</c> ", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Verflixt und Zugenäht! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 3) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Drainage! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString("Haltz Schnabl Collin! *<cÙ§`>Sie wirft eine Metallklammer in Collins Richtung.</c>*", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 4) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Herzinfarkt! Herzinfarkt! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString("*<cÙ§`>Konzentriert rückt sie einen Knochen zurecht.</c>*", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 5) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString("*<cÙ§`>Mit zugekniffenen Augen fädelt sie einen Faden in die Nadel ein und macht dann ein paar Stiche.</c>*", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 6) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("*Häh! Nicht so zappln! <cÙ§`>*Etwas grob hält sie euch fest.*</c>", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Der zappelt noch! Der zappelt noch! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 7) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("*<cÙ§`>Mit festem Griff drückt sie auf die Wunde.*</c>Ups! Blutung stillä.", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Blut! Blut! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint einen Fehler gemacht zu haben. Ihr fühlt euch schwächer.");
            if (GetLocalInt(oPc, "tempelheal_const") < 3) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION, 1), oPc, 600.0);
                SetLocalInt(oPc, "tempelheal_const", GetLocalInt(oPc, "tempelheal_const") + 1);
            }
        } else if (iRand == 8) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("*<cÙ§`>Mit einem festen Ruck zieht sie an einem Körperteil.*</c> Fest ziehä, dann is Knochn wiedr drin.", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Amputieren! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint einen Fehler gemacht zu haben. Ihr fühlt euch schwächer.");
            if (GetLocalInt(oPc, "tempelheal_const") < 3) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION, 1), oPc, 600.0);
                SetLocalInt(oPc, "tempelheal_const", GetLocalInt(oPc, "tempelheal_const") + 1);
            }
        } else if (iRand == 9) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("Ohje! Ohje! Nichtz gut genäht.*<cÙ§`>Grob entfernt sie ein paar Nähte.*</c>", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString("<cÙ§`>*krächz*</c> Ohje! Ohje! <cÙ§`>*krächz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint einen Fehler gemacht zu haben. Ihr fühlt euch schwächer.");
            if (GetLocalInt(oPc, "tempelheal_const") < 3) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION, 1), oPc, 600.0);
                SetLocalInt(oPc, "tempelheal_const", GetLocalInt(oPc, "tempelheal_const") + 1);
            }
        }
        DelayCommand(10.0, healstep(oPc, oHealer));
    }
}

void main() {
    int iGold = 10;
    object oPc = GetPCSpeaker();

    if (GetGold(oPc) >= iGold) {
        TakeGoldFromCreature(iGold, oPc);
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cÙ§`>*Die Halborkin winkt euch auf ihren \"Operationstisch\" zu und schnallt euch daran fest. Dann nimmt sie Nadel und Faden zur Hand und beginnt damit eure Wunden zu nähen*</c>", TALKVOLUME_TALK));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectDazed()), "eff_dazed"), oPc);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectCutsceneImmobilize()), "eff_immobilize"), oPc);
        healstep(oPc, OBJECT_SELF);
    } else {
        SendMessageToPC(oPc, "Ihr könnt euch das nicht leisten.");
    }
}
