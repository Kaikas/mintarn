void giveArrows(object oNpc) {
    CreateItemOnObject("sw_mu_bolzen", oNpc);
    DelayCommand(6000.0, giveArrows(oNpc));
}

void main() {
    ActionAttack(GetObjectByTag("ArcheryTarget1"));
    DelayCommand(10.0, ExecuteScript("attack_dummy1", OBJECT_SELF));
    DelayCommand(6000.0, giveArrows(OBJECT_SELF));
}
