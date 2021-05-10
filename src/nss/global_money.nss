//void main() {}

// This is a coin money library.
// It contains functions to convert ingame gold into inventory item coins,
// and vice versa.
//
// To use this, you need to place the 'coins_open' and 'coins_close' scripts
// into your stores' open and close events.
//
// To quickly find the functions when you've included the library,
// filter for the prefix "MONEY_".
//
// Love, TheBarbarian.
// TheBarbarianNWN@GMail.com
// Neverwintervault project page:
// https://neverwintervault.org/project/nwn1/script/coin-money-system

    // If this is TRUE, debug messages will show.
    const int MONEY_DEBUG = FALSE;

    // Tag of money container item.
    const string MONEY_CONTAINER_TAG = "coin_bag";

    // This is the ingame gold value of the individual inventory-item coins:
    const int MONEY_VALUE_LUMCRYSTAL = 1000000;
    const int MONEY_VALUE_CRYSTAL    = 100000;
    const int MONEY_VALUE_ETCHEDPLAT = 10000;
    const int MONEY_VALUE_PLATINUM   = 1000;
    const int MONEY_VALUE_GOLD       = 100;
    const int MONEY_VALUE_SILVER     = 10;
    // Copper value is always 1gp.
    // To set up an 1-1 conversion coin type that is not copper,
    // create a custom blueprint and place that as the copper resref
    // (it's a bit further down in this list),
    // and deactivate the other coin types.

    // Switch these to FALSE to deactivate individual coin types.
    const int MONEY_COIN_ACTIVE_LUMCRYSTAL = FALSE;
    const int MONEY_COIN_ACTIVE_CRYSTAL    = FALSE;
    const int MONEY_COIN_ACTIVE_ETCHEDPLAT = FALSE;
    const int MONEY_COIN_ACTIVE_PLATINUM   = FALSE;
    const int MONEY_COIN_ACTIVE_GOLD       = TRUE;
    const int MONEY_COIN_ACTIVE_SILVER     = TRUE;
    // Copper is mandatory.

    // A minimum amount of copper coins should always be output, so that
    // at least some "small change" is present for sure.
    const int MONEY_MINIMUM_COPPERPIECE_OUTPUT = 1;
    const int MONEY_MINIMUM_COPPERPIECE_RANDOMRANGE = 30;

    // Maximum amount of stacks that fit into the container.
    // If there are more coin stacks than this, excess will be placed directly
    // into the PC's inventory.
    const int MONEY_MAX_STACKS_PER_CONTAINER = 35;

    // Maximum stack sizes of the coin inventory items.
    const int MONEY_MAX_STACK_SIZE = 50;

    // ResRef of the coin inventory items:
    const string MONEY_RESREF_LUMCRYSTAL = "coin_lumcrystal";
    const string MONEY_RESREF_CRYSTAL    = "coin_crystal";
    const string MONEY_RESREF_ETCHEDPLAT = "coin_etchedplat";
    const string MONEY_RESREF_PLATINUM   = "coin_platinum";
    const string MONEY_RESREF_GOLD       = "sw_we_gold";
    const string MONEY_RESREF_SILVER     = "sw_we_silber";
    const string MONEY_RESREF_COPPER     = "sw_we_kupfer"; // This is the 1gp coin resref.
    // To have 1-1 conversion with a non-copper item, set up a custom coin blueprint,
    // put that blueprint resref in as the copper resref, and deactivate
    // the other coin types (it's a bit further up in this list of settings).

//void MONEY_Debug(object oTarget, string sMsg);
void MONEY_Debug(object oTarget, string sMsg)
{
    if (MONEY_DEBUG)
        SendMessageToPC(oTarget, "| (COINS DEBUG) | "+sMsg);
}

//int MONEY_GetYPercentOfX(int y, int x);
int MONEY_GetYPercentOfX(int y, int x)
{
    float fY = IntToFloat(y);
    float fX = IntToFloat(x);
    return FloatToInt((fX/100)*fY);
}

// Gets as much of Y as fits into X.
//int MONEY_GetAsMuchAsPossible(int y, int x);
int MONEY_GetAsMuchAsPossible(int y, int x)
{
    int nReturn;

    while ((abs(x)-y) < 0)
        y--;

    return y;
}

// Counts all (default) coins in oTarget's inventory, and returns their
// combined GP value.
//
// If nPayout is TRUE, the coins will be destroyed after doing this,
// and oTarget will receive their GP value equivalent as ingame money.
int MONEY_CountCoins(object oTarget=OBJECT_SELF, int nPayout=FALSE);
int MONEY_CountCoins(object oTarget=OBJECT_SELF, int nPayout=FALSE)
{
    object oCheck;
    int nGold, nStackSize, nIsCoin;
    string sResRef;

    // Look through inventory for coins:
    object oItem = GetFirstItemInInventory(oTarget);
    while (oItem != OBJECT_INVALID)
        {
        nIsCoin    = TRUE;
        sResRef    = GetResRef(oItem);
        nStackSize = GetNumStackedItems(oItem);

        if (sResRef == MONEY_RESREF_COPPER)
            nGold += nStackSize;
        else if (sResRef == MONEY_RESREF_SILVER     && MONEY_COIN_ACTIVE_SILVER)
            nGold += nStackSize * MONEY_VALUE_SILVER;
        else if (sResRef == MONEY_RESREF_GOLD       && MONEY_COIN_ACTIVE_GOLD)
            nGold += nStackSize * MONEY_VALUE_GOLD;
        else if (sResRef == MONEY_RESREF_PLATINUM   && MONEY_COIN_ACTIVE_PLATINUM)
            nGold += nStackSize * MONEY_VALUE_PLATINUM;
        else if (sResRef == MONEY_RESREF_ETCHEDPLAT && MONEY_COIN_ACTIVE_ETCHEDPLAT)
            nGold += nStackSize * MONEY_VALUE_ETCHEDPLAT;
        else if (sResRef == MONEY_RESREF_CRYSTAL    && MONEY_COIN_ACTIVE_CRYSTAL)
            nGold += nStackSize * MONEY_VALUE_CRYSTAL;
        else if (sResRef == MONEY_RESREF_LUMCRYSTAL && MONEY_COIN_ACTIVE_LUMCRYSTAL)
            nGold += nStackSize * MONEY_VALUE_LUMCRYSTAL;
        else
            nIsCoin = FALSE;

        if (nIsCoin && nPayout)
            DestroyObject(oItem);

        oItem = GetNextItemInInventory(oTarget);
        }

    if (nPayout && nGold)
        GiveGoldToCreature(oTarget, nGold);

    return nGold;
}

// Turns oTarget's coin money into ingame GP, destroying the coins in the process.
void MONEY_TurnCoinsIntoGP(object oTarget=OBJECT_SELF);
void MONEY_TurnCoinsIntoGP(object oTarget=OBJECT_SELF)
{
    MONEY_CountCoins(oTarget, TRUE);
}

// Determines amount of ingame coins to spawn.
// nGold is the amount of ingame gold available to convert.
// nCurrencyValue is the amount of ingame gold a single coin is worth.
// nPercentOfTotalGold is the percentage of the gold to attempt to convert into coins.
//
// Return value is the amount of coins (nPercentage of nGold divided by nCurrencyValue).
//int MONEY_GetConvertedCoinAmount(int nGold, int nCurrencyValue, int nPercentOfTotalGold=100, object oTarget=OBJECT_SELF);
int MONEY_GetConvertedCoinAmount(int nGold, int nCurrencyValue, int nPercentOfTotalGold=100, object oTarget=OBJECT_SELF)
{
    int nReturn;

    // Safety check:
    if (nGold > nCurrencyValue && nPercentOfTotalGold > 0)
        {
        nReturn = MONEY_GetYPercentOfX(nPercentOfTotalGold, nGold) / nCurrencyValue;
        }

    return nReturn;
}

// Creates nCoinAmount inventory items with resref sResRef, to
// maximum stack sizes of nStackSize, into the money container of oTarget.
// If the amount of stacks exceeds nMaxStacksIntoContainer,
// coins will be deposited into oTarget's inventory instead.
//
// Returns the amount of stacks created.
//int MONEY_CreateCoins(int nCoinAmount, string sResRef, int nMaxStacksIntoContainer=1, object oTarget=OBJECT_SELF);
int MONEY_CreateCoins(int nCoinAmount, string sResRef, int nMaxStacksIntoContainer=1, object oTarget=OBJECT_SELF)
{
    // Abort check:
    if (nCoinAmount <= 0)
        return 0;

    int nStacksTotal, nStackSize;
    object oContainer;

    MONEY_Debug(oTarget, "Creating "+IntToString(nCoinAmount)+" '"+sResRef+"' coins.");

    // If the PC does not have a coinpurse, deposit into their inventory instead.
    oContainer = GetItemPossessedBy(oTarget, MONEY_CONTAINER_TAG);
    if (oContainer == OBJECT_INVALID)
        oContainer = oTarget;

    while (nCoinAmount)
        {
        if (nCoinAmount >= MONEY_MAX_STACK_SIZE)
            nStackSize = MONEY_MAX_STACK_SIZE;
        else
            nStackSize = nCoinAmount;

        CreateItemOnObject(sResRef, oContainer, nStackSize);
        nCoinAmount -= nStackSize;

        nStacksTotal++;
        if (nStacksTotal >= nMaxStacksIntoContainer)
            oContainer = oTarget;
        }

    return nStacksTotal;
}

// Gives oTarget nGPAmount worth of coin items.
// If nUpdateExisting is TRUE, incorporates turning existing coins to GP first,
// so the total coin amount gets "refreshed", rather than generating the
// new coin items in addition to the existing ones.
void MONEY_GiveCoinMoneyWorth(int nGPAmount, object oTarget=OBJECT_SELF);
void MONEY_GiveCoinMoneyWorth(int nGPAmount, object oTarget=OBJECT_SELF)
{
    int nTally;
    MONEY_Debug(oTarget, "MONEY_GiveCoinMoneyWorth. Amount: "+IntToString(nGPAmount));

    // Determine the individual coin type amounts:
    int nLumCrystal, nCrystal, nEtchedPlat, nPlatinum, nGoldCoins, nSilver, nCopper;

    // Always save some of the gold for copper pieces beforehand:
    nCopper     = MONEY_GetAsMuchAsPossible(MONEY_MINIMUM_COPPERPIECE_OUTPUT+Random(MONEY_MINIMUM_COPPERPIECE_RANDOMRANGE), nGPAmount);
    nGPAmount  -= nCopper;
    nTally     += nCopper;
    MONEY_Debug(oTarget, "Saving "+IntToString(nCopper)+" copper pieces.");

    if (MONEY_COIN_ACTIVE_LUMCRYSTAL)
        {
        // Attempt to convert 97% of the remaining gold into luminous crystals.
        nLumCrystal           = MONEY_GetConvertedCoinAmount(nGPAmount, MONEY_VALUE_LUMCRYSTAL, 97,            oTarget);
        nGPAmount            -= nLumCrystal * MONEY_VALUE_LUMCRYSTAL;
        nTally               += nLumCrystal * MONEY_VALUE_LUMCRYSTAL;
        }

    if (MONEY_COIN_ACTIVE_CRYSTAL)
        {
        // Attempt to convert 95% of the remaining gold into crystals.
        nCrystal              = MONEY_GetConvertedCoinAmount(nGPAmount, MONEY_VALUE_CRYSTAL,    95,            oTarget);
        nGPAmount            -= nCrystal    * MONEY_VALUE_CRYSTAL;
        nTally               += nCrystal    * MONEY_VALUE_CRYSTAL;
        }

    if (MONEY_COIN_ACTIVE_ETCHEDPLAT)
        {
        // Attempt to convert between 95% and 97% of the remaining gold into etched platinum.
        nEtchedPlat           = MONEY_GetConvertedCoinAmount(nGPAmount, MONEY_VALUE_ETCHEDPLAT, 95+Random(3),  oTarget);
        nGPAmount            -= nEtchedPlat * MONEY_VALUE_ETCHEDPLAT;
        nTally               += nEtchedPlat * MONEY_VALUE_ETCHEDPLAT;
        }

    if (MONEY_COIN_ACTIVE_PLATINUM)
        {
        // Attempt to convert between 50% and 95% of the remaining gold into platinum.
        nPlatinum             = MONEY_GetConvertedCoinAmount(nGPAmount, MONEY_VALUE_PLATINUM,   50+Random(46), oTarget);
        nGPAmount            -= nPlatinum   * MONEY_VALUE_PLATINUM;
        nTally               += nPlatinum   * MONEY_VALUE_PLATINUM;
        }

    if (MONEY_COIN_ACTIVE_GOLD)
        {
        // Attempt to convert between 75% and 95% of the remaining gold into platinum.
        nGoldCoins            = MONEY_GetConvertedCoinAmount(nGPAmount, MONEY_VALUE_GOLD,       75+Random(21), oTarget);
        nGPAmount            -= nGoldCoins  * MONEY_VALUE_GOLD;
        nTally               += nGoldCoins  * MONEY_VALUE_GOLD;
        }

    if (MONEY_COIN_ACTIVE_SILVER)
        {
        // Attempt to convert the remaining gold into silver.
        nSilver               = MONEY_GetConvertedCoinAmount(nGPAmount, MONEY_VALUE_SILVER,     100,           oTarget);
        nGPAmount            -= nSilver     * MONEY_VALUE_SILVER;
        nTally               += nSilver     * MONEY_VALUE_SILVER;
        }

    // Leftovers become copper:
    nCopper += nGPAmount;
    nTally  += nGPAmount;
    nGPAmount    = 0;

    // Now create the actual coins, in the amounts we've determined.
    int nStacksLeft = MONEY_MAX_STACKS_PER_CONTAINER;

    nStacksLeft -= MONEY_CreateCoins(nLumCrystal, MONEY_RESREF_LUMCRYSTAL, nStacksLeft, oTarget);
    nStacksLeft -= MONEY_CreateCoins(nCrystal,    MONEY_RESREF_CRYSTAL,    nStacksLeft, oTarget);
    nStacksLeft -= MONEY_CreateCoins(nEtchedPlat, MONEY_RESREF_ETCHEDPLAT, nStacksLeft, oTarget);
    nStacksLeft -= MONEY_CreateCoins(nPlatinum,   MONEY_RESREF_PLATINUM,   nStacksLeft, oTarget);
    nStacksLeft -= MONEY_CreateCoins(nGoldCoins,  MONEY_RESREF_GOLD,       nStacksLeft, oTarget);
    nStacksLeft -= MONEY_CreateCoins(nSilver,     MONEY_RESREF_SILVER,     nStacksLeft, oTarget);
    nStacksLeft -= MONEY_CreateCoins(nCopper,     MONEY_RESREF_COPPER,     nStacksLeft, oTarget);

    MONEY_Debug(oTarget, "Total value: "+IntToString(nTally)+" GP.");
}

// bleh!
void MONEY_TakeCoinMoneyWorthPrivate(int nGPAmount, object oTarget)
{
    int nTargetGold = GetGold(oTarget);
    ActionDoCommand(MONEY_GiveCoinMoneyWorth(nTargetGold-nGPAmount, oTarget));
    ActionDoCommand(TakeGoldFromCreature(nTargetGold, oTarget, TRUE));
}

// Takes coin money worth nGPAmount GP away from oTarget,
// by converting them to GP, subtracting, and then turning them into coins again.
void MONEY_TakeCoinMoneyWorth(int nGPAmount, object oTarget=OBJECT_SELF);
void MONEY_TakeCoinMoneyWorth(int nGPAmount, object oTarget=OBJECT_SELF)
{
    ActionDoCommand(MONEY_TurnCoinsIntoGP(oTarget));
    ActionWait(0.1);
    ActionDoCommand(MONEY_TakeCoinMoneyWorthPrivate(nGPAmount, oTarget));
}

