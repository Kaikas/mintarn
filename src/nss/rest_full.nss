void main() {
    object oPc = GetPCSpeaker();
    SetLocalInt(oPc, "rast", 1);
    DelayCommand(1.0, ExecuteScript("global_restb", oPc));
}
