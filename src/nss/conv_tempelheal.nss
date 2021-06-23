#include "global_helper"

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
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Die Halborkin zieht einige male an einem Faden sodass ein leises \"Pling, Pling, Pling\" ert�nt.*</c> Und zu die Naht. H�h�.", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Knochens�ge! Knochens�ge! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString("N�n�, allz gut Collin! " + GetToken(101) +  "*Sie winkt in Richtung ihres Papageien*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 1) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Mit konzentriertem Blick und aus dem Mundwinkel geschobener Zunge macht die Halborkin ein paar Nadelstiche.*</c> ", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Amputieren! Amputieren! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 2) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Mit den Fingern tastet sie die R�nder einer Wunde entlang.*</c> ", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Verflixt und Zugen�ht! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 3) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Drainage! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString("Haltz Schnabl Collin! " + GetToken(101) + "*Sie wirft eine Metallklammer in Collins Richtung.</c>*", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 4) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Herzinfarkt! Herzinfarkt! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Konzentriert r�ckt sie einen Knochen zurecht.</c>*", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 5) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Mit zugekniffenen Augen f�delt sie einen Faden in die Nadel ein und macht dann ein paar Stiche.</c>*", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 6) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("*H�h! Nicht so zappln! " + GetToken(101) + "*Etwas grob h�lt sie euch fest.*</c>", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Der zappelt noch! Der zappelt noch! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint ihre Aufgabe richtig zu machen, ihr werdet um ein paar Lebenspunkte geheilt.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetCurrentHitPoints(oPc) + GetMaxHitPoints(oPc)/5), oPc);
        } else if (iRand == 7) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Mit festem Griff dr�ckt sie auf die Wunde.*</c>Ups! Blutung still�.", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Blut! Blut! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint einen Fehler gemacht zu haben. Ihr f�hlt euch schw�cher.");
            if (GetLocalInt(oPc, "tempelheal_const") < 3) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION, 1), oPc, 600.0);
                SetLocalInt(oPc, "tempelheal_const", GetLocalInt(oPc, "tempelheal_const") + 1);
            }
        } else if (iRand == 8) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString(GetToken(101) + "*Mit einem festen Ruck zieht sie an einem K�rperteil.*</c> Fest zieh�, dann is Knochn wiedr drin.", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Amputieren! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint einen Fehler gemacht zu haben. Ihr f�hlt euch schw�cher.");
            if (GetLocalInt(oPc, "tempelheal_const") < 3) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION, 1), oPc, 600.0);
                SetLocalInt(oPc, "tempelheal_const", GetLocalInt(oPc, "tempelheal_const") + 1);
            }
        } else if (iRand == 9) {
            AssignCommand(oHealer, ClearAllActions(TRUE));
            AssignCommand(oHealer, ActionSpeakString("Ohje! Ohje! Nichtz gut gen�ht." + GetToken(101) + "*Grob entfernt sie ein paar N�hte.*</c>", TALKVOLUME_TALK));
            AssignCommand(GetObjectByTag("NPC_Collin"), ActionSpeakString(GetToken(101) + "*kr�chz*</c> Ohje! Ohje! " + GetToken(101) + "*kr�chz*</c>", TALKVOLUME_TALK));
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 5.0);
            SendMessageToPC(oPc, "Die Heilerin scheint einen Fehler gemacht zu haben. Ihr f�hlt euch schw�cher.");
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
        AssignCommand(OBJECT_SELF, ActionSpeakString(GetToken(101) + "*Die Halborkin winkt euch auf ihren \"Operationstisch\" zu und schnallt euch daran fest. Dann nimmt sie Nadel und Faden zur Hand und beginnt damit eure Wunden zu n�hen*</c>", TALKVOLUME_TALK));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectDazed()), "eff_dazed"), oPc);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectCutsceneImmobilize()), "eff_immobilize"), oPc);
        healstep(oPc, OBJECT_SELF);
    } else {
        SendMessageToPC(oPc, "Ihr k�nnt euch das nicht leisten.");
    }
}
