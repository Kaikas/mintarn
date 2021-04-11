#include "nwnx_sql"

void main() {
    object oPc = GetPCSpeaker();
    int gold = -1;
    // Get old xp
    string sQuery = "SELECT * FROM Tribut WHERE name=? AND charname=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(1, GetName(oPc));
        NWNX_SQL_PreparedString(2, "moschen");
        NWNX_SQL_ExecutePreparedQuery();

        while (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            gold = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        }
    }

    // If no entry exists, insert
    if (gold == -1) {
        sQuery = "INSERT INTO Tribut (name, charname, gold) VALUES (?, ?, ?)";
        if (NWNX_SQL_PrepareQuery(sQuery)) {
            NWNX_SQL_PreparedString(0, GetPCPlayerName(oPc));
            NWNX_SQL_PreparedString(1, GetName(oPc));
            NWNX_SQL_PreparedString(2, "0");
            NWNX_SQL_ExecutePreparedQuery();
        }
    }

    gold = gold + StringToInt(GetScriptParam("gold"));

    sQuery = "UPDATE Tribute SET gold=? WHERE name=? AND charname=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, IntToString(gold));
        NWNX_SQL_PreparedString(1, GetPCPlayerName(oPc));
        NWNX_SQL_PreparedString(2, GetName(oPc));
        NWNX_SQL_ExecutePreparedQuery();
    }

    TakeGoldFromCreature(StringToInt(GetScriptParam("gold")), oPc, TRUE);

    // Buff
    effect eEffect = GetFirstEffect(oPc);
    while(GetIsEffectValid(eEffect)) {
        if(GetEffectTag(eEffect) == "eff_tribut") {
            RemoveEffect(oPc, eEffect);
        }
        eEffect = GetNextEffect(oPc);
    }
    if (GetScriptParam("gold") == "5") ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectTemporaryHitpoints(1), "eff_tribut"), oPc);
    if (GetScriptParam("gold") == "50") ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectTemporaryHitpoints(2), "eff_tribut"), oPc);
    if (GetScriptParam("gold") == "500") ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectTemporaryHitpoints(5), "eff_tribut"), oPc);
    if (GetScriptParam("gold") == "1000") ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectTemporaryHitpoints(10), "eff_tribut"), oPc);
}
