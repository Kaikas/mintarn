void main() {
  object oDoor = GetObjectByTag("drawbridge");
    SetLocked(oDoor, FALSE);
    ActionOpenDoor(oDoor);
}
