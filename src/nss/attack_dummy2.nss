void main() {
    ActionAttack(GetObjectByTag("CombatDummy1"));
    DelayCommand(10.0, ExecuteScript("attack_dummy2", OBJECT_SELF));
}
