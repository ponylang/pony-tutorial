use "net"
use notifier = "net/notifier"

class MyNotify is notifier.ClientTCPConnectionNotify
  let _out: OutStream

  new iso create(out: OutStream) =>
    _out = out

  fun ref on_connected(conn: notifier.ClientTCPConnection ref) =>
    _out.print("connected")
    conn.close()

  fun ref on_connect_failed(conn: notifier.ClientTCPConnection ref,
    reason: ConnectionFailureReason) =>
    _out.print("connect_failed")

actor Connect
  new create(out: OutStream, auth: TCPConnectAuth) =>
    notifier.ClientTCPConnection(auth, MyNotify(out),
      "example.com", "80")

actor Main
  new create(env: Env) =>
    Connect(env.out, TCPConnectAuth(env.root))
