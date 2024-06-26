use "path:/usr/local/opt/libressl/lib" if osx
use "lib:ssl" if not windows
use "lib:crypto" if not windows
use "lib:libssl-32" if windows
use "lib:libcrypto-32" if windows

use @SSL_load_error_strings[None]()
use @SSL_library_init[I32]()

primitive _SSLInit
  """
  This initialises SSL when the program begins.
  """
  fun _init() =>
    @SSL_load_error_strings()
    @SSL_library_init()