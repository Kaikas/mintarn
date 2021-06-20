#include "nwnx_sql"
#include "global_helper"

void main() {
    string sQuery = "UPDATE Calendar SET year=?, month=?, day=?, hour=? WHERE id=?";
    if (NWNX_SQL_PrepareQuery(sQuery)) {
        NWNX_SQL_PreparedString(0, IntToString(GetCalendarYear()));
        NWNX_SQL_PreparedString(1, IntToString(GetCalendarMonth()));
        NWNX_SQL_PreparedString(2, IntToString(GetCalendarDay()));
        NWNX_SQL_PreparedString(3, IntToString(GetTimeHour()));
        NWNX_SQL_PreparedString(4, "1");
        NWNX_SQL_ExecutePreparedQuery();
    }
    DelayCommand(600.0, ExecuteScript("calendar", OBJECT_SELF));
}
