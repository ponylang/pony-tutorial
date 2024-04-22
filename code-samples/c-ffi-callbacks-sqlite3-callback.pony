use @sqlite3_exec[I32](db: Pointer[None] tag, sql: Pointer[U8] tag,
  callback: Pointer[None], data: Pointer[None], err_msg: Pointer[Pointer[U8] tag] tag)

class SQLiteClient
  fun client_code() =>
    ...
    @sqlite3_exec(db, sql.cstring(), addressof this.method_callback,
                  this, addressof zErrMsg)
    ...

  fun @method_callback(client: SQLiteClient, argc: I32,
    argv: Pointer[Pointer[U8]], azColName: Pointer[Pointer[U8]]): I32
  =>
    ...