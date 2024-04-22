typedef int (*sqlite3_callback)(void*,int,char**, char**);

...

SQLITE_API int SQLITE_STDCALL sqlite3_exec(
sqlite3 *db,                /* The database on which the SQL executes */
const char *zSql,           /* The SQL to be executed */
sqlite3_callback xCallback, /* Invoke this callback routine */
void *pArg,                 /* First argument to xCallback() */
char **pzErrMsg             /* Write error messages here */
)
{
  ...
  xCallback(pArg, nCol, azVals, azCols)
  ...
}